// lib/screens/home_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:summarization_system/Services/PdfServices.dart';
import 'package:summarization_system/Utils/Fonts.dart';
import 'package:summarization_system/Utils/MainColors.dart';
import 'package:summarization_system/Utils/TextStyle.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ExtactHighlightText extends StatefulWidget {
  const ExtactHighlightText({super.key});

  @override
  State<ExtactHighlightText> createState() => _ExtactHighlightTextState();
}

class _ExtactHighlightTextState extends State<ExtactHighlightText>
    with WidgetsBindingObserver {
  final TextEditingController combinedController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  bool _loading = false;
  bool _hasExtractedText = false;
  File? _previewFile;
  double _keyboardPadding = 16;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _keyboardPadding = bottomInset > 0 ? bottomInset : 16;
    });
  }

  Future<void> extractTextWithHighlightCheck() async {
    combinedController.clear();
    setState(() {
      _loading = true;
      _hasExtractedText = false;
    });

    final pickedLines = await PdfService.extractHighlightedText();
    if (pickedLines != null && pickedLines.isNotEmpty) {
      final combinedText = pickedLines.map((line) => line.text).join("\n\n");
      setState(() {
        combinedController.text = combinedText;
        _hasExtractedText = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text was extracted from the file')),
      );
    }

    setState(() => _loading = false);
  }

  void makeSelectionBold() {
    final text = combinedController.text;
    final selection = combinedController.selection;
    if (!selection.isValid || selection.isCollapsed) return;

    final selectedText = selection.textInside(text);
    final isAlreadyBold =
        selectedText.startsWith('**') && selectedText.endsWith('**');

    final newText =
        isAlreadyBold
            ? selection.textBefore(text) +
                selectedText.replaceAll('**', '') +
                selection.textAfter(text)
            : selection.textBefore(text) +
                '**$selectedText**' +
                selection.textAfter(text);

    setState(() {
      combinedController.text = newText;
      combinedController.selection = TextSelection.collapsed(
        offset:
            selection.start +
            (isAlreadyBold ? -2 : 2) +
            selectedText.length +
            (isAlreadyBold ? -2 : 2),
      );
    });
  }

  Future<File> generatePdfPreview(String fileName) async {
    final PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

    double yOffset = 0;
    final lines = combinedController.text.split("\n");
    for (final line in lines) {
      final cleanLine = line.replaceAll('**', '');
      if (yOffset > page.getClientSize().height - 20) {
        page = document.pages.add();
        yOffset = 0;
      }
      page.graphics.drawString(
        cleanLine,
        font,
        bounds: Rect.fromLTWH(0, yOffset, page.getClientSize().width, 20),
      );
      yOffset += 20;
    }

    final List<int> bytes = await document.save();
    document.dispose();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);

    return file;
  }

  void showPreviewDialog() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name of file';
                  } else if (value.contains(".")) {
                    return 'Please enter a valid name';
                  }

                  return null;
                },
                controller: fileNameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "File name",
                  hintStyle: Text_Style.textStyleNormal(Colors.black38, 15),

                  labelStyle: TextStyle(
                    fontFamily: Fonts.PrimaryFont,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1.9,
                      color: MainColors.mainColor.withOpacity(0.6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1.9,
                      color: MainColors.mainColor.withValues(alpha: 0.6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: MainColors.mainColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  fileNameController.clear();
                },
                child: Text(
                  'Cancel',
                  style: Text_Style.textStyleNormal(MainColors.mainColor, 16),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(MainColors.mainColor),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = fileNameController.text;
                    final preview = await generatePdfPreview(name);
                    setState(() => _previewFile = preview);
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PDFPreviewScreen(
                              filePath: preview.path,
                              fileName: name,
                            ),
                      ),
                    );
                    fileNameController.clear();
                  }
                },
                child: Text(
                  'Preview',
                  style: Text_Style.textStyleNormal(Colors.white, 16),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Text Extraction & Highlight')),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            height: heightScreen * 0.9,
            width: widthScreen,
            child: Column(
              children: [
                SizedBox(height: 50),
                _loading
                    ? Expanded(
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: MainColors.mainColor,
                          size: 40,
                        ),
                      ),
                    )
                    : Expanded(
                      child: Column(
                        children: [
                          if (_hasExtractedText)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkResponse(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: combinedController.text,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Text copied'),
                                        ),
                                      );
                                    },

                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MainColors.secondColor,
                                      ),
                                      height: 40,
                                      width: 80,
                                      child: Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),

                                  InkResponse(
                                    onTap: showPreviewDialog,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                        ),
                                        color: MainColors.mainColor,
                                      ),
                                      height: 40,
                                      width: 80,
                                      child: Icon(
                                        Icons.download,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          combinedController.text.isEmpty
                              ? Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Opacity(
                                        opacity: 0.5,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          child: Lottie.asset(
                                            "assets/animation/extractPdf.json",
                                            repeat: true,
                                            reverse: true,

                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              )
                              : Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  padding: const EdgeInsets.all(10),
                                  constraints: BoxConstraints(
                                    maxHeight: heightScreen * 0.65,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                    ),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: TextField(
                                    controller: combinedController,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: const InputDecoration.collapsed(
                                      hintText: 'Extracted text...',
                                    ),
                                  ),
                                ),
                              ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: 50,
                            width: widthScreen,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  MainColors.mainColor,
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        combinedController.text.isEmpty
                                            ? BorderRadius.all(
                                              Radius.circular(15),
                                            )
                                            : BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                  ),
                                ),
                              ),
                              onPressed: extractTextWithHighlightCheck,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (combinedController.text == "")
                                    Text(
                                      'Choose PDF File',
                                      style: Text_Style.textStyleNormal(
                                        Colors.white,
                                        17,
                                      ),
                                    ),
                                  if (combinedController.text != "")
                                    Text(
                                      'Choose another PDF File',
                                      style: Text_Style.textStyleNormal(
                                        Colors.white,
                                        17,
                                      ),
                                    ),
                                  Icon(Icons.upload),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PDFPreviewScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PDFPreviewScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  Future<void> saveFinalPdf(BuildContext context) async {
    final bytes = await File(filePath).readAsBytes();
    final directory = Directory('/storage/emulated/0/Download');
    final file = File('${directory.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved as $fileName.pdf in Downloads')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Preview')),
      body: Column(
        children: [
          Expanded(child: SfPdfViewer.file(File(filePath))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(MainColors.mainColor),
              ),
              onPressed: () => saveFinalPdf(context),
              icon: const Icon(Icons.save, color: Colors.white),
              label: Text(
                'Save to Downloads',
                style: Text_Style.textStyleNormal(Colors.white, 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/screens/extract_text_from_image_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:summarization_system/Utils/MainColors.dart';
import 'package:summarization_system/Utils/TextStyle.dart';
import 'package:summarization_system/Utils/Fonts.dart';

class ExtractTextFromImageScreen extends StatefulWidget {
  const ExtractTextFromImageScreen({super.key});

  @override
  State<ExtractTextFromImageScreen> createState() =>
      _ExtractTextFromImageScreenState();
}

class _ExtractTextFromImageScreenState extends State<ExtractTextFromImageScreen>
    with WidgetsBindingObserver {
  final TextEditingController combinedController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _hasExtractedText = false;
  double _keyboardPadding = 16;
  File? _previewFile;

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

  Future<void> pickImageAndExtractText() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    _hasExtractedText = false;
    combinedController.clear();
    if (pickedFile == null) return;

    setState(() {
      _loading = true;
      combinedController.clear();
      _hasExtractedText = false;
    });

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    if (recognizedText.text.isNotEmpty) {
      setState(() {
        combinedController.text = recognizedText.text;
        _hasExtractedText = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text was detected in the image.')),
      );
    }

    setState(() => _loading = false);
  }

  Future<File> generatePdfPreview(String fileName) async {
    final PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

    double yOffset = 0;
    final lines = combinedController.text.split("\n");
    for (final line in lines) {
      if (yOffset > page.getClientSize().height - 20) {
        page = document.pages.add();
        yOffset = 0;
      }
      page.graphics.drawString(
        line,
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
                  if (value!.isEmpty) return 'Please enter a file name';
                  if (value.contains('.')) return 'Name should not contain dot';
                  return null;
                },
                controller: fileNameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "File name",
                  hintStyle: Text_Style.textStyleNormal(Colors.black38, 15),
                  border: OutlineInputBorder(
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
      appBar: AppBar(title: const Text('Extract Text From Image')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                        ? BorderRadius.all(Radius.circular(15))
                                        : BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                              ),
                            ),
                          ),
                          onPressed: pickImageAndExtractText,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (combinedController.text == "")
                                Text(
                                  'Pick an Image',
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
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('PDF Preview')),
      body: Column(
        children: [
          Expanded(child: SfPdfViewer.file(File(filePath))),
          Container(
            height: 80,
            width: widthScreen,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(MainColors.mainColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                onPressed: () => saveFinalPdf(context),
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Save to Downloads',
                  style: Text_Style.textStyleNormal(Colors.white, 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

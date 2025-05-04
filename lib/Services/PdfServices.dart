// lib/services/pdf_service.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:summarization_system/Models/LineData.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  static Future<List<LineData>?> extractHighlightedText() async {
    List<LineData> lines = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);

      for (int pageIndex = 0; pageIndex < document.pages.count; pageIndex++) {
        final page = document.pages[pageIndex];
        final annotations = page.annotations;
        final textLines = extractor.extractTextLines(
          startPageIndex: pageIndex,
          endPageIndex: pageIndex,
        );

        for (final line in textLines) {
          final lineBounds = line.bounds;
          bool isHighlighted = false;
          Color highlightColor = Colors.white;

          for (int j = 0; j < annotations.count; j++) {
            final annotation = annotations[j];
            if (annotation is PdfTextMarkupAnnotation) {
              final rect = annotation.bounds;
              if (rect.overlaps(lineBounds)) {
                isHighlighted = true;
                highlightColor = Color.fromRGBO(
                  annotation.color.r.round(),
                  annotation.color.g.round(),
                  annotation.color.b.round(),
                  1,
                );
                break;
              }
            }
          }

          final yellowLikeColors = [
            const Color.fromRGBO(255, 193, 0, 1),
            const Color.fromRGBO(252, 244, 133, 1),
            const Color.fromRGBO(197, 251, 114, 1),
            const Color.fromRGBO(6, 138, 28, 1),
          ];

          final blueColor = const Color.fromRGBO(56, 229, 255, 1);

          bool isYellowLike = yellowLikeColors.any(
            (c) => isSimilarTo(highlightColor, c),
          );
          bool isBlueLike = isSimilarTo(highlightColor, blueColor);

          if (isYellowLike || isBlueLike) {
            lines.add(
              LineData(text: line.text, backgroundColor: highlightColor),
            );
          }
        }
      }

      document.dispose();
      return lines;
    }
    return null;
  }

  static bool isSimilarTo(Color a, Color b, [int tolerance = 20]) {
    return (a.red - b.red).abs() <= tolerance &&
        (a.green - b.green).abs() <= tolerance &&
        (a.blue - b.blue).abs() <= tolerance;
  }
}

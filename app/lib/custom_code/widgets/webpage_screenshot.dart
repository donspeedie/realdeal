// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../../search/search_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';

// class WebpageScreenshot extends StatefulWidget {
//   const WebpageScreenshot({
//     super.key,
//     this.width,
//     this.height,
//     required this.showExportButton,
//   });

//   final double? width;
//   final double? height;
//   final bool showExportButton;

//   @override
//   State<WebpageScreenshot> createState() => _WebpageScreenshotState();
// }

// class _WebpageScreenshotState extends State<WebpageScreenshot> {
//   final ScreenshotController screenshotController = ScreenshotController();

//   Future<void> captureAndDownloadPdf() async {
//     try {
//       final Uint8List? imageBytes = await screenshotController.capture(
//           delay: Duration(milliseconds: 100));

//       if (imageBytes == null) throw Exception('Could not capture image');

//       final pdf = pw.Document();
//       final pdfImage = pw.MemoryImage(imageBytes);

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
//           },
//         ),
//       );

//       final bytes = await pdf.save();
//       final blob = html.Blob([bytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);

//       final anchor = html.AnchorElement(href: url)
//         ..setAttribute('download', 'screenshot.pdf')
//         ..click();

//       html.Url.revokeObjectUrl(url);
//     } catch (e) {
//       print('Error creating PDF: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Screenshot(
//           controller: screenshotController,
//           child: SearchWidget(), // Your page widget
//         ),
//         if (widget.showExportButton)
//           Positioned(
//             top: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: captureAndDownloadPdf,
//               child: Text('Export PDF'),
//             ),
//           ),
//       ],
//     );
//   }
// }

class WebpageScreenshot extends StatefulWidget {
  const WebpageScreenshot({
    super.key,
    this.width,
    this.height,
    required this.showExportButton,
  });

  final double? width;
  final double? height;
  final bool showExportButton;

  @override
  State<WebpageScreenshot> createState() => _WebpageScreenshotState();
}

class _WebpageScreenshotState extends State<WebpageScreenshot> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController scrollController = ScrollController();

  Future<void> captureAndDownloadPdf() async {
    try {
      final pdf = pw.Document();

      const int scrollSteps = 3;
      for (int i = 0; i < scrollSteps; i++) {
        // Scroll to next position
        double targetOffset =
            scrollController.position.maxScrollExtent * (i / scrollSteps);
        await scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        // Wait a little for rendering to settle
        await Future.delayed(const Duration(milliseconds: 600));

        // Take screenshot
        final Uint8List? imageBytes = await screenshotController.capture();
        if (imageBytes == null) throw Exception('Failed to capture image');

        final pdfImage = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                  child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
            },
          ),
        );
      }

      // Save PDF and download
      final bytes = await pdf.save();
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'screenshot.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error creating PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: List.generate(
                  50, (index) => ListTile(title: Text('Item $index'))),
              // Replace with your actual content or SearchWidget
            ),
          ),
        ),
        if (widget.showExportButton)
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: captureAndDownloadPdf,
              child: Text('Export PDF'),
            ),
          ),
      ],
    );
  }
}

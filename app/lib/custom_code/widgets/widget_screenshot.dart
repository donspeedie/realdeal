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

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class WidgetScreenshot extends StatefulWidget {
  const WidgetScreenshot({
    Key? key,
    this.width,
    this.height,
    required this.screenshotChild,
    required this.initialPosition, // New parameter
    this.markerCoordinates = const [], // New parameter with default empty list
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget Function() screenshotChild;
  final LatLng initialPosition; // Map center
  final List<LatLng> markerCoordinates; // List of marker positions

  @override
  _WidgetScreenshotState createState() => _WidgetScreenshotState();
}

class _WidgetScreenshotState extends State<WidgetScreenshot> {
  final GlobalKey _repaintKey = GlobalKey();

  // Replace with your actual Google Maps Static API Key
  static const String googleMapsApiKey =
      'AIzaSyBJDJQZEJh6kRfdslUQ8uEbzVsRSW-WwFc'; // IMPORTANT: Replace with your actual API key

  Future<Uint8List?> _fetchStaticMapImage(
      int zoom, LatLng center, List<LatLng> additionalMarkers) async {
    // Renamed for clarity
    const String size = '600x300';

    // Explicitly format center coordinates (still good practice)
    final String formattedCenter = '${center.latitude},${center.longitude}';

    // --- START CHANGE HERE ---
    // Combine initialPosition with other markers
    List<LatLng> allMarkers = [center]; // Start with initialPosition
    allMarkers.addAll(additionalMarkers); // Add the rest

    String markersString = '';
    if (allMarkers.isNotEmpty) {
      markersString = '&markers=color:red%7C'; // Default red marker
      // Format all combined markers
      markersString +=
          allMarkers.map((m) => '${m.latitude},${m.longitude}').join('%7C');
    }
    // --- END CHANGE HERE ---

    final String mapUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$formattedCenter&zoom=$zoom&size=$size$markersString&key=$googleMapsApiKey';

    print('Constructed Static Map URL: $mapUrl'); // For debugging

    try {
      final response = await http.get(Uri.parse(mapUrl));
      if (response.statusCode == 200) {
        print("Call Succeed");
        return response.bodyBytes;
      } else {
        print(
            'Failed to load static map image (Zoom: $zoom): ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching static map image (Zoom: $zoom): $e');
      return null;
    }
  }

  Future<void> captureAndDownloadPdf() async {
    try {
      // Capture screenshot from RepaintBoundary
      final boundary = _repaintKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('RepaintBoundary not found');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert screenshot image to bytes');
      }

      final Uint8List screenshotImageBytes = byteData.buffer.asUint8List();

      // Verify PNG signature (first 8 bytes of a PNG file) for screenshot
      final header = screenshotImageBytes.take(8).toList();
      if (header[0] != 137 || header[1] != 80 || header[2] != 78) {
        throw Exception('Captured screenshot image is not a valid PNG.');
      }

      // Fetch static map image with zoom 12
      final Uint8List? staticMapImageBytesZoom12 = await _fetchStaticMapImage(
          12, widget.initialPosition, widget.markerCoordinates);

      // Fetch static map image with zoom 19
      final Uint8List? staticMapImageBytesZoom19 = await _fetchStaticMapImage(
          19, widget.initialPosition, widget.markerCoordinates);

      // Create PDF and embed images
      final pdf = pw.Document();

      // Add screenshot page
      final pdfScreenshotImage = pw.MemoryImage(screenshotImageBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfScreenshotImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      // Add static map image with zoom 12 page if available
      if (staticMapImageBytesZoom12 != null) {
        final pdfStaticMapImage12 = pw.MemoryImage(staticMapImageBytesZoom12);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Map with Zoom 12',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Image(pdfStaticMapImage12, fit: pw.BoxFit.contain),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        print('Static map image with Zoom 12 could not be added to PDF.');
      }

      // Add static map image with zoom 19 page if available
      if (staticMapImageBytesZoom19 != null) {
        final pdfStaticMapImage19 = pw.MemoryImage(staticMapImageBytesZoom19);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Map with Zoom 19',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Image(pdfStaticMapImage19, fit: pw.BoxFit.contain),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        print('Static map image with Zoom 19 could not be added to PDF.');
      }

      final pdfBytes = await pdf.save();

      // Download using universal_html
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download',
            'screenshot_and_maps_${DateTime.now().millisecondsSinceEpoch}.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to generate PDF: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: _repaintKey,
              child: widget.screenshotChild(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: captureAndDownloadPdf,
          child: const Text('Download as PDF'),
        ),
      ],
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

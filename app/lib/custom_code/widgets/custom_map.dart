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

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat;
import 'package:cached_network_image/cached_network_image.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    this.width,
    this.height,
    required this.coordinates,
    required this.zoomSetting,
    required this.compCoordinates,
    this.markerImage,
    this.markerImage2,
    this.markerImage3,
    this.minZoom,
    this.maxZoom,
  });

  final double? width;
  final double? height;
  final LatLng coordinates;
  final double zoomSetting;
  final List<LatLng> compCoordinates;
  final String? markerImage;
  final String? markerImage2;
  final String? markerImage3;
  final int? minZoom;
  final int? maxZoom;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  lat.LatLng _convertLatLng(LatLng coord) =>
      lat.LatLng(coord.latitude, coord.longitude);

  @override
  Widget build(BuildContext context) {
    final lat.LatLng mainLatLng = _convertLatLng(widget.coordinates);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: mainLatLng,
          initialZoom: widget.zoomSetting,
          minZoom: widget.minZoom?.toDouble() ??
              5, // set your desired minimum zoom level
          maxZoom: widget.maxZoom?.toDouble() ??
              18, // set your desired maximum zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.mycompany.habu',
          ),
          MarkerLayer(
            markers: [
              // Main Marker
              Marker(
                width: 60,
                height: 60,
                point: mainLatLng,
                child:
                    _buildMarker(widget.markerImage, fallbackColor: Colors.red),
              ),
              // Comparison Markers
              ...widget.compCoordinates.map(
                (coord) => Marker(
                  width: 50,
                  height: 50,
                  point: _convertLatLng(coord),
                  child: _buildMarker(widget.markerImage3,
                      fallbackColor: Colors.yellow),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String? imageUrl, {required Color fallbackColor}) {
    if (imageUrl != null && imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 20,
        height: 20,
        placeholder: (context, url) =>
            const CircularProgressIndicator(strokeWidth: 2),
        errorWidget: (context, url, error) => _fallbackMarker(fallbackColor),
      );
    } else {
      return _fallbackMarker(fallbackColor);
    }
  }

  Widget _fallbackMarker(Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 2),
      ),
    );
  }
}

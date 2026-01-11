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
import '../../components/main_map_marker_widget.dart';

class MainMap extends StatefulWidget {
  const MainMap({
    super.key,
    this.width,
    this.height,
    required this.coordinates,
    required this.zoomSetting,
    required this.propertyCoordinates,
    this.minZoom,
    this.maxZoom,
    required this.onPropertyTap,
    required this.properties,
  });

  final double? width;
  final double? height;
  final LatLng coordinates;
  final double zoomSetting;
  final List<LatLng> propertyCoordinates;
  final double? minZoom;
  final double? maxZoom;
  final Future Function(String zpid, String method) onPropertyTap;
  final List<dynamic> properties;

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
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
          minZoom: widget.minZoom ?? 5, // <- limit zoom out
          maxZoom: widget.maxZoom ?? 18, // <- limit zoom in
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.mycompany.habu',
          ),
          MarkerLayer(
            markers: [
              // Property Markers
              ...widget.propertyCoordinates.asMap().entries.map(
                    (entry) => Marker(
                      width: 80,
                      height: 50,
                      point: _convertLatLng(entry.value),
                      child: _buildMarker(
                        widget.onPropertyTap,
                        widget.properties[entry.key],
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(Future Function(String zpid, String method) onPropertyTap,
      dynamic property) {
    return MainMapMarkerWidget(
        property: property, onPropertyTap: onPropertyTap);
  }
}

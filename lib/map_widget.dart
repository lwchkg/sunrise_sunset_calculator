import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const _zoomLevel = 15.0;
const _attributionPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 4);

const _openStreetMapMaxZoomLevel = 18.0;
const _openStreetMapAttributionMessage = 'Map powered by OpenStreetMap';
const _openStreetMapUrlTemplate =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _appPackageName = 'com.example.app';

FlutterMap flutterMap(
    {required double latitude,
    required double longitude,
    required MapController controller}) {
  return FlutterMap(
    mapController: controller,
    options: MapOptions(
      center: LatLng(latitude, longitude),
      // Disable scroll view and drag to allow scrolling of the page.
      enableScrollWheel: false,
      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.drag,
      maxZoom: _openStreetMapMaxZoomLevel,
      zoom: _zoomLevel,
    ),
    nonRotatedChildren: const [
      Align(
        alignment: Alignment.bottomRight,
        child: ColoredBox(
          color: Color(0xc0ffffff),
          child: Padding(
            padding: _attributionPadding,
            child: Text(_openStreetMapAttributionMessage),
          ),
        ),
      ),
    ],
    children: [
      TileLayer(
        urlTemplate: _openStreetMapUrlTemplate,
        userAgentPackageName: _appPackageName,
      ),
      MarkerLayer(
        markers: [
          Marker(
            point: LatLng(latitude, longitude),
            width: 36.0,
            height: 36.0,
            builder: (context) =>
                const Icon(Icons.place_outlined, color: Colors.red, size: 36.0),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        ],
      ),
    ],
  );
}

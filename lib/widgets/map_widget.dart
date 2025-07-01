import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const _zoomLevel = 15.0;
const _attributionPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 4);

const _openStreetMapMaxZoomLevel = 18.0;
const _openStreetMapAttributionMessage = 'Map powered by OpenStreetMap';
const _openStreetMapUrlTemplate =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _appPackageName = 'com.lwchkg.app';

class AttributionWidget extends StatelessWidget {
  const AttributionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
        alignment: Alignment.bottomRight,
        child: ColoredBox(
            color: Color(0xc0ffffff),
            child: Padding(
              padding: _attributionPadding,
              child: Text(_openStreetMapAttributionMessage,
                  // Do not use theme color because in dark mode it is under a
                  // color filter, so the default white in dark mode becomes
                  // black!
                  style: TextStyle(color: Color(0xc0000000))),
            )));
  }
}

FlutterMap flutterMap({
  required double latitude,
  required double longitude,
  required MapController controller,
}) {
  return FlutterMap(
    mapController: controller,
    options: MapOptions(
      initialCenter: LatLng(latitude, longitude),
      // Disable scroll wheel and drag to make the underlying page scrollable.
      interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.drag,
          scrollWheelVelocity: 0.0),
      maxZoom: _openStreetMapMaxZoomLevel,
      initialZoom: _zoomLevel,
    ),
    children: [
      TileLayer(
        urlTemplate: _openStreetMapUrlTemplate,
        userAgentPackageName: _appPackageName,
      ),
      const AttributionWidget(),
      MarkerLayer(
        markers: [
          Marker(
            point: LatLng(latitude, longitude),
            width: 36.0,
            height: 36.0,
            child:
                const Icon(Icons.place_outlined, color: Colors.red, size: 36.0),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    ],
  );
}

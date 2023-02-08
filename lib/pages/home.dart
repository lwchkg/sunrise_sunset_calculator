import 'dart:math' show min;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

import '../widgets/map_widget.dart';
import '../widgets/multi_day_info.dart';
import '../widgets/single_day_info.dart';

const padding = 16.0;
const horizontalSpacing = 32.0;

const maxMapHeight = 600.0;

toLocalizedString(n) =>
    NumberFormat.decimalPatternDigits(decimalDigits: 5).format(n);

bool isLatitude(String s) {
  try {
    double latitude = NumberFormat.decimalPattern().parse(s).toDouble();
    return latitude >= -90 && latitude <= 90;
  } on FormatException {
    return false;
  }
}

bool isLongitude(String s) {
  try {
    double longitude = NumberFormat.decimalPattern().parse(s).toDouble();
    return longitude >= -180 && longitude <= 180;
  } on FormatException {
    return false;
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const initialLatitude = 37.3387;
const initialLongitude = -121.8853;

class _MyHomePageState extends State<MyHomePage> {
  double _latitude = initialLatitude;
  double _longitude = initialLongitude;
  tz.Location _location =
      tz.getLocation(latLngToTimezoneString(initialLatitude, initialLongitude));

  var _now = DateTime.now();

  final _latitudeController = TextEditingController(
    text: toLocalizedString(initialLatitude),
  );
  final _longitudeController = TextEditingController(
    text: toLocalizedString(initialLongitude),
  );
  final _mapController = MapController();

  final _latitudeFocusNode = FocusNode();
  final _longitudeFocusNode = FocusNode();

  final _locations = tz.timeZoneDatabase.locations.keys.toList(growable: false);

  _MyHomePageState() {
    getOwnLocation();
  }

  void moveMap() {
    _mapController.move(LatLng(_latitude, _longitude), _mapController.zoom);
  }

  void getOwnLocation() async {
    try {
      var location = await _determinePosition();
      setState(() {
        _latitude = location.latitude;
        _longitude = location.longitude;
        _location =
            tz.getLocation(latLngToTimezoneString(_latitude, _longitude));
      });
      _latitudeFocusNode.unfocus();
      _longitudeFocusNode.unfocus();
      _latitudeController.text = toLocalizedString(_latitude);
      _longitudeController.text = toLocalizedString(_longitude);
      moveMap();
    } catch (e) {
      debugPrint('Get location failed. Reason: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _now = DateTime.now();

    const textBoxContentPadding = EdgeInsets.fromLTRB(0, 12, 0, 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: OutlinedButton(
              onPressed: getOwnLocation,
              child: const Text('Use your own location'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      contentPadding: textBoxContentPadding,
                      labelText: 'Latitude',
                    ),
                    focusNode: _latitudeFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onChanged: (String? value) {
                      if (value != null && isLatitude(value)) {
                        setState(() {
                          _latitude = NumberFormat.decimalPattern()
                              .parse(value)
                              .toDouble();
                          _location = tz.getLocation(
                              latLngToTimezoneString(_latitude, _longitude));
                        });
                        moveMap();
                      }
                    },
                    validator: (String? value) {
                      return value == null || isLatitude(value)
                          ? null
                          : 'Must be between -90 to 90.';
                    },
                  ),
                ),
                const SizedBox(width: horizontalSpacing),
                Flexible(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      contentPadding: textBoxContentPadding,
                      labelText: 'Longitude',
                    ),
                    focusNode: _longitudeFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onChanged: (String? value) {
                      if (value != null && isLongitude(value)) {
                        setState(() {
                          _longitude = NumberFormat.decimalPattern()
                              .parse(value)
                              .toDouble();
                          _location = tz.getLocation(
                              latLngToTimezoneString(_latitude, _longitude));
                        });
                        moveMap();
                      }
                    },
                    validator: (String? value) {
                      return value == null || isLongitude(value)
                          ? null
                          : 'Must be between -180 to 180.';
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: padding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: DropdownSearch<String>(
              items: _locations,
              dropdownDecoratorProps: DropDownDecoratorProps(
                // Set to default text style of TextField.
                baseStyle: Theme.of(context).textTheme.titleMedium,
                dropdownSearchDecoration: const InputDecoration(
                  contentPadding: textBoxContentPadding,
                  labelText: 'Time Zone',
                ),
              ),
              onChanged: (String? T) {
                if (T == null) return;
                setState(() {
                  _location = tz.getLocation(T);
                });
              },
              popupProps: PopupProps.menu(
                constraints: const BoxConstraints(maxHeight: 500),
                favoriteItemProps: FavoriteItemProps<String>(
                  favoriteItems: (_) =>
                      [latLngToTimezoneString(_latitude, _longitude)],
                  showFavoriteItems: true,
                ),
                showSearchBox: true,
                showSelectedItems: true,
              ),
              selectedItem: _location.name,
            ),
          ),
          const SizedBox(height: padding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: SingleDayInfo(
              latitude: _latitude,
              longitude: _longitude,
              location: _location,
              now: _now,
            ),
          ),
          const SizedBox(height: padding),
          SizedBox(
            height:
                min(MediaQuery.of(context).size.width * 3 / 4, maxMapHeight),
            child: flutterMap(
              latitude: _latitude,
              longitude: _longitude,
              controller: _mapController,
            ),
          ),
          const SizedBox(height: padding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: MultiDayInfo(
              latitude: _latitude,
              longitude: _longitude,
              location: _location,
              days: daysFrom(tz.TZDateTime.from(_now, _location), 7 + 1),
              title: 'Today and next week',
            ),
          ),
          const SizedBox(height: padding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: TextButton(
              onPressed: () {
                context.push(Uri(path: '/monthly_info', queryParameters: {
                  'latitude': _latitude.toString(),
                  'longitude': _longitude.toString(),
                  'location': _location.name,
                  'year': _now.year.toString(),
                  'month': _now.month.toString(),
                }).toString());
              },
              child: const Text('More days...'),
            ),
          ),
        ],
      ),
    );
  }
}

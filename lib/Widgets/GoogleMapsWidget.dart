import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;

  bool mapDarkMode = true;
  late String _darkMapStyle;
  late String _lightMapStyle;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    _loadMapStyles();
    super.initState();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_style/light.json');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _setMapStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      GoogleMap(
        mapType: MapType.normal,
        rotateGesturesEnabled: true,
        zoomGesturesEnabled: true,
        trafficEnabled: false,
        tiltGesturesEnabled: false,
        scrollGesturesEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(30.029585, 31.022356),
          zoom: 14.47,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapPins([LatLng(30.029585, 31.022356)]);
          _setMapStyle();
        },
      ),
      Positioned(
          top: 100,
          right: 30,
          child: Container(
            height: 30,
            width: 30,
            child: IconButton(
              icon: Icon(
                mapDarkMode ? Icons.brightness_4 : Icons.brightness_5,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  mapDarkMode = !mapDarkMode;
                  _setMapStyle();
                });
              },
            ),
          )),
      ]
    );
  }

  _setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      markersLocation.forEach((markerLocation) {
        _markers.add(Marker(
          markerId: MarkerId(markerLocation.toString()),
          position: markerLocation,
          icon: customIcon,
        ));
      });
    });
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (mapDarkMode)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
        initialCameraPosition: CameraPosition(
          target: LatLng(26.8206, 30.8025),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onCameraMove: (position) {
          print(position.zoom);
          print(position.target.longitude);
          print(position.target.latitude);
        },
      );
  }
}

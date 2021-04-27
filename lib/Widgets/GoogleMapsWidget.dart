import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_car.png')
        .then((icon) {
      customIcon = icon;
    });
    super.initState();
  }

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
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: LatLng(30.029585, 31.022356),
        zoom: 14.47,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _setMapPins([LatLng(30.029585, 31.022356)]);
      },
      onCameraMove: (position) {
        print(position.zoom);
        print(position.target.longitude);
        print(position.target.latitude);
      },
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
}

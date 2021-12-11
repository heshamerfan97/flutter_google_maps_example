import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_example/Repositories/map_repository.dart';
import 'package:google_maps_flutter_example/Utils/map_utils.dart';
import 'package:google_maps_flutter_example/app_bloc.dart';
import 'package:google_maps_flutter_example/controller/live_location_cubit.dart';
import 'package:location/location.dart';

class GoogleMapsWidget extends StatefulWidget {
  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  Completer<GoogleMapController> _controller = Completer();
  double lat = 30.029585;
  double lng = 31.022356;
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  final LatLng destinationLatLng = LatLng(30.060567, 30.962413);

  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;

  bool mapDarkMode = true;
  late String _darkMapStyle;
  late String _lightMapStyle;

  Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(50, 50)), 'assets/images/marker_car.png')
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
    return Stack(children: [
      BlocListener<LiveLocationCubit, LocationData?>(
        listener: (context, liveLocation) {
          if (liveLocation != null) {
            _updateUserMarker(liveLocation);
          }
        },
        child: GoogleMap(
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
          polylines: _polyline,
          initialCameraPosition: CameraPosition(
            target: initialLatLng,
            zoom: 14.47,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _setMapPins([LatLng(30.029585, 31.022356)]);
            _setMapStyle();
            _addPolyLines();
          },
        ),
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
      Positioned(
          bottom: 50,
          left: 30,
          child: Container(
            height: 30,
            width: 30,
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                AppBloc.liveLocationCubit.startService();
              },
            ),
          )),
    ]);
  }

  _moveCamera([double? zoom]) async {
    final CameraPosition myPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom ?? 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(myPosition));
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
      _markers.add(Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position: destinationLatLng,
      ));
    });
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (mapDarkMode)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  _addPolyLines() {
    setState(() {
      lat = (initialLatLng.latitude + destinationLatLng.latitude) / 2;
      lng = (initialLatLng.longitude + destinationLatLng.longitude) / 2;
      _moveCamera(13.0);
      _setPolyLine();
    });
  }

  _setPolyLine() async {
    final result = await MapRepository().getRouteCoordinates(initialLatLng, destinationLatLng);
    final route = result.data["routes"][0]["overview_polyline"]["points"];
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId("tripRoute"),
          //pass any string here
          width: 3,
          geodesic: true,
          points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
          color: Theme.of(context).primaryColor));
    });
  }

  _updateUserMarker(LocationData currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'user');
      lat = currentLocation.latitude!;
      lng = currentLocation.longitude!;
      _moveCamera();
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('user'),
            position: LatLng(currentLocation.latitude!, currentLocation.longitude!)));
      });
    }
  }
}

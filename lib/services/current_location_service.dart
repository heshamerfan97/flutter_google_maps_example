import 'dart:async';

import 'package:google_maps_flutter_example/app_bloc.dart';
import 'package:location/location.dart';


class CurrentLocationService {
  Location location = Location();
  late StreamSubscription<LocationData> currentLocationStream;
  bool serviceEnabled = false;


  Future<bool> startService() async {
    serviceEnabled = await  location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
    }
    final permissionGranted = await checkLocationPermission();
    if (permissionGranted) {
      try {
        currentLocationStream =
            location.onLocationChanged.listen((LocationData currentLocation) {
              return AppBloc.liveLocationCubit.updateUserLocation(currentLocation);
            });
      }catch(e){
        print(e);
      }
    }
    return permissionGranted;
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus isGranted = await location.hasPermission();
    if (isGranted == PermissionStatus.granted )
      return true;
    else {
      PermissionStatus requestResult = await location.requestPermission();
      if (requestResult == PermissionStatus.granted)
        return true;
      return false;
    }
  }

  dispose() {
    serviceEnabled = false;
    currentLocationStream.cancel();
  }
}

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter_example/services/current_location_service.dart';
import 'package:location/location.dart';


class LiveLocationCubit extends Cubit<LocationData?> {
  LiveLocationCubit() : super(null);
  LocationData? currentLocation;
  List<LocationData> locations = [];
  CurrentLocationService currentLocationService = CurrentLocationService();

  Future<bool> startService() async {
    if(!currentLocationService.serviceEnabled) {
      return await currentLocationService.startService();
    }else {
      return true;
    }
  }

  closeService() => currentLocationService.dispose();

  updateUserLocation(LocationData? currentLocation){
    if(currentLocation != null){
      locations.add(currentLocation);
      this.currentLocation = currentLocation;
      emit(this.currentLocation);
    }
  }
}
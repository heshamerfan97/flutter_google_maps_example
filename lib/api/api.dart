import 'package:google_maps_flutter_example/models/api_result_model.dart';
import 'package:google_maps_flutter_example/api/dio_manager.dart';

class API {
  ///Map APIs
  static const String GET_COORDINATES_URL = 'maps.googleapis.com';
  static const String GET_COORDINATES_PATH = '/maps/api/directions/json';


  ///Authentication APIs
  static Future<APIResultModel> getRouteCoordinates(dynamic parameters) async {
    print(parameters);
    return APIResultModel.fromResponse(
        response: await DioManager.get(path: GET_COORDINATES_PATH, parameters: parameters),
        data: null);
  }

}

import 'package:dio/dio.dart';
import 'package:google_maps_flutter_example/application.dart';

import '../utils/logger.dart';

class DioManager {
  static const String BaseUrl = 'beautyv1.herokuapp.com';

  static Dio mainDio = Dio(BaseOptions(
      baseUrl: BaseUrl));

  static Options getOptions() => Options(
    headers: {
      'Authorization': 'Bearer ${Application.accessToken}',
      "Content-Type": "application/json",
      "Accept-Language": "en",
    },
    validateStatus: (_) => true,
    contentType: "application/json",
    responseType: ResponseType.json,
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
  );

  ///POST Method
  static Future<Response?> post(
      {Dio? dio, required String path, required Map<String, dynamic>? body, Map<String, dynamic>? parameters}) async {
    dio ??= mainDio;
      final options = getOptions();
      try {
        Logger.logInfo(
            "Body posted to ${dio.options.baseUrl + path}: $body with header ${options.headers}, and Parameters: $parameters");
        final response = await dio.post(path, data: body, options: options, queryParameters: parameters);
        Logger.log('Response of posting to ${dio.options.baseUrl + path}:\n ${response.data}');
        return response;
      } catch (error) {
        Logger.log('Error in ${dio.options.baseUrl + path}:\n $error');
        return null;
      }

  }

  ///GET Method
  static Future<Response?> get({
    Dio? dio,
    required String path,
    required Map<String, dynamic>? parameters,
  }) async {
    dio ??= mainDio;
      try {
        final options = getOptions();
        Logger.log(
            'we are getting ${dio.options.baseUrl + path}:\n with param $parameters with header ${options.headers}');
        final response = await dio.get(path, queryParameters: parameters, options: options);
        //final responseBody = json.decode(response.body);
        Logger.log('Response of getting ${dio.options.baseUrl + path}:\n ${response.data}');
        return response;
      } catch (error) {
        Logger.log('Error in getting ${dio.options.baseUrl + path}:\n $error');
        return null;
      }

  }
}

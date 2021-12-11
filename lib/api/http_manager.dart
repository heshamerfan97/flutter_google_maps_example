import 'dart:convert';

import 'package:google_maps_flutter_example/application.dart';
import 'package:http/http.dart' as http;

class HttpManager {
  static const String BaseUrl = 'beautyv1.herokuapp.com';

  static Map<String, String> getHeader() {
    return {
      'Authorization': 'Bearer ${Application.accessToken}',
      "Content-Type": "application/json",
    };
  }

  ///POST Method
  static Future<http.Response?> post({
    String? baseUrl,
    required String path,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(Uri.https(baseUrl??BaseUrl, '/api$path'),
          headers: getHeader(), body: json.encode(body));
      return response;
    } catch (error) {
      return null;
    }
  }

  ///GET Method
  static Future<http.Response?> get({
    String? baseUrl,
    required String path,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final response = await http.get(
          Uri.https(baseUrl??BaseUrl, path, parameters),
          headers: getHeader());
      return response;
    } catch (error) {
      return null;
    }
  }
}

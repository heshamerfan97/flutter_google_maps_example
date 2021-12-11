import 'dart:convert';

import 'package:http/http.dart';

class APIResultModel {
  final bool success;
  final String message;
  final dynamic data;

  APIResultModel({
    required this.success,
    required this.message,
    this.data,
  });


  factory APIResultModel.fromResponse({Response? response, String? data}){
    if(response != null){
      try{
        final responseBody = json.decode(response.body);
        return APIResultModel(
          success: response.statusCode == 200,
          message: responseBody['message']?? 'No message',
          data: data==null?responseBody:responseBody[data],
        );
      }catch(error){
        print('Error in getting result from response:\n $error');
        return APIResultModel(
          success: false,
          data: null,
          message: "cannot init result api",
        );
      }
    } else {
      print('Response is null');
      return APIResultModel(
        success: false,
        data: null,
        message: "Response is null",
      );
    }
  }

}
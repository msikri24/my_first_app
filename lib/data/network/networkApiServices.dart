import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/data/app_exception.dart';
import 'package:flutter_app/data/network/base_services.dart';
import 'package:http/http.dart' as http;
class NetworkApiServices extends BaseApiServices {
  @override
  Future  getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url) ,
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async{
    dynamic responseJson;
    try{
      http.Response response = await http.post(
          Uri.parse(url),
          body:data).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  // Implement DELETE request
  @override
  Future<dynamic> getDeleteApiResponse(String url) async {
    try {
      final response = await http.delete(Uri.parse(url));

      // Log the response status and body for debugging
      print("DELETE Request URL: $url");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Handle successful DELETE with a 200 or 204 status code
      if (response.statusCode == 200 || response.statusCode == 204) {
        // No content to return for 204
        return null;
      } else {
        // If it's not a success code, throw an error
        throw Exception("Failed to delete user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error with DELETE request: $e");
      throw Exception("Error with DELETE request: $e");
    }
  }
}

  dynamic returnResponse(http.Response response) {
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:  // Created
        return jsonDecode(response.body); // Successful response
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:  // Unauthorized
        throw UnauthorisedException("Unauthorized: ${response.body}");
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error occurred while communicating with server${response.statusCode}');
    }
  }

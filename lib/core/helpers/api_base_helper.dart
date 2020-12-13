import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:service_now/preferences/user_preferences.dart';

import 'app_exceptions.dart';

class ApiBaseHelper {
  // final String baseUrl = 'https://test.konxulto.com/service_now/public/api/';
  final String baseUrl = 'https://test.konxulto.com/service_now_desa/public/api/';

  Future<dynamic> get(String url) async {
    var responseJson;
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    
    IOClient ioClient = new IOClient(httpClient);

    try {
      final response = await ioClient.get(baseUrl + url, headers: { 'Authorization': 'Bearer ${UserPreferences.instance.token}', 'Content-Type': 'application/json', 'Accept': 'application/json' });
      responseJson = _returnResponse(response);
    } on SocketException {
      return json.decode('{"error": 1, "message": "Compruebe su conexión a internet."}');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    
    IOClient ioClient = new IOClient(httpClient);
    try {
      final response = await ioClient.post(
        Uri.encodeFull(baseUrl + url), 
        headers: { 
          'Authorization'   : 'Bearer ${UserPreferences.instance.token}', 
          'Content-type'    : 'application/json',
          'Accept'          : 'application/json'
        }, 
        body: json.encode(body)
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      return json.decode('{"error": 1, "message": "Compruebe su conexión a internet."}');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        var responseJson = json.decode('{"error": 401, "message": "Unauthenticated"}');
        return responseJson;
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
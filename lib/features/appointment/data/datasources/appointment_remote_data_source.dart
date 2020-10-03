import 'package:service_now/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/appointment/data/models/business_model.dart';
import 'package:service_now/features/appointment/data/request/get_business_request.dart';
import 'package:service_now/features/appointment/data/response/get_business_response.dart';
import 'dart:convert';

import 'package:service_now/preferences/user_preferences.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<BusinessModel>> getBusiness(GetBusinessRequest request);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final http.Client client;

  AppointmentRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<BusinessModel>> getBusiness(GetBusinessRequest request) => _getBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business/nearest_business');

  Future<List<BusinessModel>> _getBusinessFromUrl(GetBusinessRequest request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(request.toJson())
    );

    if (response.statusCode == 200) {
      final body = GetBusinessResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }
}
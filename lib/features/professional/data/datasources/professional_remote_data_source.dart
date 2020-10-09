import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/features/professional/data/models/professional_business_model.dart';
import 'package:service_now/features/professional/data/requests/get_professional_business_request.dart';
import 'package:service_now/features/professional/data/responses/get_professional_business_response.dart';
import 'package:service_now/preferences/user_preferences.dart';

abstract class ProfessionalRemoteDataSource {
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request);
}

class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final http.Client client;

  ProfessionalRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request) => _getProfessionalBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business/nearest_business');

  Future<List<ProfessionalBusinessModel>> _getProfessionalBusinessFromUrl(GetProfessionalBusinessRequest request, String url) async {
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
      final body = GetProfessionalBusinessResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }
}
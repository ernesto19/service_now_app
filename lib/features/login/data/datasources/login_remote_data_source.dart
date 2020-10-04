import 'dart:convert';
import 'package:service_now/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/login/data/models/user_model.dart';
import 'package:service_now/features/login/data/requests/login_request.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> login(LoginRequest request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({ @required this.client });

  @override
  Future<UserModel> login(LoginRequest request) => _loginFromUrl(request, 'https://test.konxulto.com/service_now/public/api/login');

  Future<UserModel> _loginFromUrl(LoginRequest request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(request.toJson())
    );

    if (response.statusCode == 200) {
      final body = LoginResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }
}
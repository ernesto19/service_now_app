import 'dart:convert';
import 'package:service_now/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/login/data/requests/login_request.dart';
import 'package:service_now/features/login/data/requests/sign_up_request.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/data/responses/sign_up_response.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponse> logIn(LoginRequest request);
  Future<LoginResponse> logInByFacebook(String request);
  Future<SignUpResponse> signUp(SignUpRequest request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({ @required this.client });

  @override
  Future<LoginResponse> logIn(LoginRequest request) => _logInFromUrl(request, ApiBaseHelper().baseUrl + 'login');

  @override
  Future<LoginResponse> logInByFacebook(String request) => _logInByFacebookFromUrl(request, ApiBaseHelper().baseUrl + 'login/facebook/get_token_from_facebook');

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) => _signUpFromUrl(request, ApiBaseHelper().baseUrl + 'register');

  Future<LoginResponse> _logInFromUrl(LoginRequest request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(request.toJson())
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<LoginResponse> _logInByFacebookFromUrl(String request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode( { 'token' : request } )
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<SignUpResponse> _signUpFromUrl(SignUpRequest request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(request.toJson())
    );

    if (response.statusCode == 200) {
      return SignUpResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
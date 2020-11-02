import 'dart:convert';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/preferences/user_preferences.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<LoginResponse> acquireMembership();
}

class CategoryRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<CategoryModel>> getCategories() => _getCategoriesFromUrl('https://test.konxulto.com/service_now/public/api/favorite_business_categories');

  @override
  Future<LoginResponse> acquireMembership() => _acquireMembershipFromUrl('https://test.konxulto.com/service_now/public/api/permissions/add_role');

  Future<List<CategoryModel>> _getCategoriesFromUrl(String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = CategoryResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<LoginResponse> _acquireMembershipFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
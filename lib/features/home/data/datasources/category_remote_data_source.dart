import 'dart:convert';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/preferences/user_preferences.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String token);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<CategoryModel>> getCategories(String token) => _getCategoriesFromUrl('https://test.konxulto.com/service_now/public/api/favorite_business_categories');

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
}
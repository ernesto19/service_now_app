import 'dart:convert';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/home/data/models/membership_model.dart';
import 'package:service_now/features/home/data/models/message_model.dart';
import 'package:service_now/features/home/data/responses/get_membership_response.dart';
import 'package:service_now/features/home/data/responses/get_messages_response.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/preferences/user_preferences.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<LoginResponse> acquireMembership();
  Future<List<MessageModel>> getMessages();
  Future<MembershipModel> getMembership();
}

class CategoryRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<CategoryModel>> getCategories() => _getCategoriesFromUrl(ApiBaseHelper().baseUrl + 'favorite_business_categories');

  @override
  Future<LoginResponse> acquireMembership() => _acquireMembershipFromUrl(ApiBaseHelper().baseUrl + 'permissions/add_role');

  @override
  Future<List<MessageModel>> getMessages() => _getMessagesFromUrl(ApiBaseHelper().baseUrl + 'business_service/get_push_notification_log');

  @override
  Future<MembershipModel> getMembership() => _getMembershipFromUrl(ApiBaseHelper().baseUrl + 'permissions/membership');

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

  Future<List<MessageModel>> _getMessagesFromUrl(String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(
        {
          'request_type' : [ 'pnRequestService' ]
        }
      )
    );

    if (response.statusCode == 200) {
      final body = GetMessagesResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<MembershipModel> _getMembershipFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetMembershipResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }
}
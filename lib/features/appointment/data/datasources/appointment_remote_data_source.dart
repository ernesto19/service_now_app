import 'package:service_now/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/appointment/data/models/business_model.dart';
import 'package:service_now/features/appointment/data/models/comment_model.dart';
import 'package:service_now/features/appointment/data/models/gallery_model.dart';
import 'package:service_now/features/appointment/data/requests/get_business_request.dart';
import 'package:service_now/features/appointment/data/requests/get_comments_request.dart';
import 'package:service_now/features/appointment/data/requests/get_galleries_request.dart';
import 'package:service_now/features/appointment/data/requests/request_business_request.dart';
import 'package:service_now/features/appointment/data/responses/get_business_response.dart';
import 'package:service_now/features/appointment/data/responses/get_comments_response.dart';
import 'package:service_now/features/appointment/data/responses/get_galleries_response.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'dart:convert';

import 'package:service_now/preferences/user_preferences.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<BusinessModel>> getBusiness(GetBusinessRequest request);
  Future<List<CommentModel>> getComments(GetCommentsRequest request);
  Future<List<GalleryModel>> getGalleries(GetGalleriesRequest request);
  Future<RequestBusinessResponse> requestBusiness(RequestBusinessRequest request);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final http.Client client;

  AppointmentRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<BusinessModel>> getBusiness(GetBusinessRequest request) => _getBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business/nearest_business');

  @override
  Future<List<CommentModel>> getComments(GetCommentsRequest request) => _getCommentsFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business_service/get_comment_by_business');

  @override
  Future<List<GalleryModel>> getGalleries(GetGalleriesRequest request) => _getGalleriesFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business_service/get_all_galleries');

  @override
  Future<RequestBusinessResponse> requestBusiness(RequestBusinessRequest request) => _requestBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business_service/pn_request_service');

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

  Future<List<CommentModel>> _getCommentsFromUrl(GetCommentsRequest request, String url) async {
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
      final body = GetCommentsResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<List<GalleryModel>> _getGalleriesFromUrl(GetGalleriesRequest request, String url) async {
    final response = await client.get(
      '$url?business_id=${request.businessId}',
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetGalleriesResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<RequestBusinessResponse> _requestBusinessFromUrl(RequestBusinessRequest request, String url) async {
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
      return RequestBusinessResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/professional/data/models/professional_business_model.dart';
import 'package:service_now/features/professional/data/models/professional_service_model.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';
import 'package:service_now/features/professional/data/requests/register_business_request.dart';
import 'package:service_now/features/professional/data/requests/register_service_request.dart';
import 'package:service_now/features/professional/data/requests/response_request_request.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/get_professional_business_response.dart';
import 'package:service_now/features/professional/data/responses/get_professional_services_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/data/responses/response_request_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class ProfessionalRemoteDataSource {
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness();
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request);
  Future<IndustryCategory> getIndustries();
  Future<RegisterBusinessResponse> registerBusiness(RegisterBusinessRequest request);
  Future<RegisterBusinessResponse> updateBusiness(RegisterBusinessRequest request);
  Future<CreateServiceForm> getCreateServiceForm();
  Future<RegisterServiceResponse> registerService(RegisterServiceRequest request);
  Future<RegisterServiceResponse> updateService(RegisterServiceRequest request);
  Future<void> updateBusinessStatus(ProfessionalBusiness business);
  Future<ResponseRequestResponse> responseRequest(ResponseRequestRequest request);
  Future<DeleteImageResponse> deleteImage(int id);
}

class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final http.Client client;

  ProfessionalRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness() => _getProfessionalBusinessFromUrl(ApiBaseHelper().baseUrl + 'business/business_by_professional');

  @override
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request) => _getProfessionalServicesFromUrl(request, ApiBaseHelper().baseUrl + 'business/get_services');

  @override
  Future<IndustryCategory> getIndustries() => _getIndustriesFromUrl(ApiBaseHelper().baseUrl + 'business/industries_categories');

  @override
  Future<RegisterBusinessResponse> registerBusiness(RegisterBusinessRequest request) => _registerBusinessFromUrl(request, ApiBaseHelper().baseUrl + 'business/create');

  @override
  Future<RegisterBusinessResponse> updateBusiness(RegisterBusinessRequest request) => _updateBusinessFromUrl(request, ApiBaseHelper().baseUrl + 'business/update');

  @override
  Future<CreateServiceForm> getCreateServiceForm() => _getCreateServiceFormFromUrl(ApiBaseHelper().baseUrl + 'business/ind_cat_serv');

  @override
  Future<RegisterServiceResponse> registerService(RegisterServiceRequest request) => _registerServiceFromUrl(request, ApiBaseHelper().baseUrl + 'business/add_service');

  @override
  Future<RegisterServiceResponse> updateService(RegisterServiceRequest request) => _updateServiceFromUrl(request, ApiBaseHelper().baseUrl + 'business/update_service');

  @override
  Future<ResponseRequestResponse> responseRequest(ResponseRequestRequest request) => _responseRequestFromUrl(request, ApiBaseHelper().baseUrl + 'business_service/pn_response_service');

  @override
  Future<void> updateBusinessStatus(ProfessionalBusiness business) => _updateBusinessStatusFromUrl(business, ApiBaseHelper().baseUrl + 'business/active');

  @override
  Future<DeleteImageResponse> deleteImage(int id) => _deleteImageFromUrl(id, ApiBaseHelper().baseUrl + 'business/delete_gallery');
  
  Future<List<ProfessionalBusinessModel>> _getProfessionalBusinessFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetProfessionalBusinessResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<List<ProfessionalServiceModel>> _getProfessionalServicesFromUrl(GetProfessionalServicesRequest request, String url) async {
    final response = await client.get(
      '$url?business_id=${request.professionalBusinessId}',
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetProfessionalServicesResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<IndustryCategory> _getIndustriesFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetIndustriesResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<RegisterBusinessResponse> _registerBusinessFromUrl(RegisterBusinessRequest request, String url) async {
    final uri = Uri.parse(url 
      + '?'
      + 'name=${request.name}&'
      + 'description=${request.description}&'
      + 'category_id=${request.categoryId}&'
      + 'industry_id=${request.industryId}&'
      + 'license=${request.licenseNumber}&'
      + 'job_offer=${request.jobOffer}&'
      + 'lat=${request.latitude}&'
      + 'lng=${request.longitude}&'
      + 'address=${request.address}&'
      + 'phone=${request.phone}&'
      + 'fanpage=${request.fanpage}');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (request.images != null ) {
      for (int i = 0; i < request.images.length; i++) {
        Asset asset = request.images[i];
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        final multipartFile = http.MultipartFile.fromBytes(
          'files[]',
          imageData,
          filename: 'name.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipartRequest.files.add(multipartFile);
      }
    }

    final streamResponse = await multipartRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw ServerException();
    }

    return RegisterBusinessResponse.fromJson(json.decode(resp.body));
  }

  Future<RegisterBusinessResponse> _updateBusinessFromUrl(RegisterBusinessRequest request, String url) async {
    final uri = Uri.parse(url 
      + '?'
      + 'business_id=${request.businessId}&'
      + 'name=${request.name}&'
      + 'description=${request.description}&'
      + 'category_id=${request.categoryId}&'
      + 'industry_id=${request.industryId}&'
      + 'license=${request.licenseNumber}&'
      + 'job_offer=${request.jobOffer}&'
      + 'lat=${request.latitude}&'
      + 'lng=${request.longitude}&'
      + 'address=${request.address}&'
      + 'phone=${request.phone}&'
      + 'fanpage=${request.fanpage}');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (request.images != null ) {
      for (int i = 0; i < request.images.length; i++) {
        Asset asset = request.images[i];
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        final multipartFile = http.MultipartFile.fromBytes(
          'files[]',
          imageData,
          filename: 'name.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipartRequest.files.add(multipartFile);
      }
    }

    final streamResponse = await multipartRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw ServerException();
    }

    return RegisterBusinessResponse.fromJson(json.decode(resp.body));
  }

  Future<CreateServiceForm> _getCreateServiceFormFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetCreateServiceFormResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<RegisterServiceResponse> _registerServiceFromUrl(RegisterServiceRequest request, String url) async {
    final uri = Uri.parse(url 
      + '?'
      + 'service_id=${request.serviceId}&'
      + 'price=${request.price}&'
      + 'business_id=${request.businessId}');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (request.images != null ) {
      for (int i = 0; i < request.images.length; i++) {
        Asset asset = request.images[i];
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        final multipartFile = http.MultipartFile.fromBytes(
          'files[]',
          imageData,
          filename: 'name.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipartRequest.files.add(multipartFile);
      }
    }

    final streamResponse = await multipartRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      throw ServerException();
    }

    return RegisterServiceResponse.fromJson(json.decode(resp.body));
  }

  Future<RegisterServiceResponse> _updateServiceFromUrl(RegisterServiceRequest request, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(request.toJsonUpdate())
    );

    if (response.statusCode == 200) {
      return RegisterServiceResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<void> _updateBusinessStatusFromUrl(ProfessionalBusiness business, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode({ 'business_id': business.id } )
    );

    if (response.statusCode == 200) {
      return Right(response.body);
    } else {
      throw ServerException();
    }
  }

  Future<ResponseRequestResponse> _responseRequestFromUrl(ResponseRequestRequest request, String url) async {
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
      return ResponseRequestResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<DeleteImageResponse> _deleteImageFromUrl(int id, String url) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode({ 'id': id })
    );

    if (response.statusCode == 200) {
      return DeleteImageResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
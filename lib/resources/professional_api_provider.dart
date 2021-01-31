import 'dart:async';
import 'dart:convert';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/preferences/user_preferences.dart';

class ProfessionalApiProvider {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProfessionalBusinessResponse> fetchProfessionalBusiness() async {
    final response = await _helper.get('business/business_by_professional');
    return ProfessionalBusinessResponse.fromJson(response);
  }

  Future<GalleryResponse> fetchProfessionalBusinessGallery(int id) async {
    final response = await _helper.get('business/get_gallery?business_id=$id');
    return GalleryResponse.fromJson(response);
  }

  Future<GalleryResponse> fetchProfessionalServiceGallery(int id) async {
    final response = await _helper.get('business_service/get_gallery?business_service_id=$id');
    return GalleryResponse.fromJson(response);
  }

  Future<ProfessionalCRUDResponse> deleteBusinessImage(int id) async {
    final response = await _helper.post(
      'business/delete_gallery', 
      {
        'id': id     
      }
    );
    return ProfessionalCRUDResponse.fromJson(response);
  }

  Future<ProfessionalCRUDResponse> deleteServiceImage(int id) async {
    final response = await _helper.post(
      'business_service/delete_gallery', 
      {
        'id': id     
      }
    );
    return ProfessionalCRUDResponse.fromJson(response);
  }

  Future<void> updateBusinessStatus(int id) async {
    await _helper.post(
      'business/active', 
      {
        'business_id': id     
      }
    );
  }

  Future<void> updateBusinessProfessionalStatus(int id, int estado) async {
    await _helper.post(
      'professional/business_status', 
      {
        'business_id': id,
        'active': estado
      }
    );
  }
  
  Future<ProfessionalCRUDResponse> registerPromotion(String name, String description, var amount, String type, int businessId) async {
    final response = await _helper.post(
      'promotion/create', 
      {
        'name': name,
        'description': description,
        'amount': amount,
        'type': type,
        'business_id': businessId
      }
    );
    return ProfessionalCRUDResponse.fromJson(response);
  }

  Future<PromotionResponse> fetchPromotions(int id) async {
    final response = await _helper.post(
      'promotion/get', 
      {
        'business_id': id     
      }
    );
    return PromotionResponse.fromJson(response);
  }

  Future<void> updatePromotionStatus(int id, int status) async {
    await _helper.post(
      'promotion/toogle', 
      {
        'id': id,
        'active': status
      }
    );
  }

  Future<RequestResponse> obtenerBandejaSolicitudes(int businessId) async {
    final response = await _helper.get('business_request/inbox?business_id=$businessId');
    return RequestResponse.fromJson(response);
  }

  Future<void> aprobarSolicitud(int id) async {
    await _helper.post(
      'business_request/aprove', 
      {
        'id': id
      }
    );
  }

  Future<void> denegarSolicitud(int id) async {
    await _helper.post(
      'business_request/deny', 
      {
        'id': id
      }
    );
  }

  Future<ProfessionalCRUDResponse> responderSolicitudServicio(List<ProfessionalService> services, int userId) async {
    var serviceArray = [];

    services.forEach((service) { 
      serviceArray.add(service.id);
    });

    final response = await _helper.post(
      'business_service/pn_response_service', 
      {
        'user_id': userId,
        'services': serviceArray
      }
    );
    return ProfessionalCRUDResponse.fromJson(response);
  }

  Future<ServiciosPendientesResponse> obtenerBandejaServiciosPendientes() async {
    final response = await _helper.post(
      'business_service/get_client_services', 
      {
        'professional_user_id': UserPreferences.instance.userId
      }
    );
    return ServiciosPendientesResponse.fromJson(response);
  }

  Future<void> iniciarServicio(int id) async {
    await _helper.post(
      'business_service/service_status', 
      {
        'payment_id': id,
        "status": 1
      }
    );
  }

  Future<void> terminarServicio(int id) async {
    await _helper.post(
      'business_service/service_status', 
      {
        'payment_id': id,
        "status": 2
      }
    );
  }

  Future<ProfessionalCRUDResponse> agregarImagenesNegocio(int id, List<Asset> images) async {
    final uri = Uri.parse(ApiBaseHelper().baseUrl + 'business/upload_gallery' 
      + '?'
      + 'business_id=$id');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (images != null ) {
      for (int i = 0; i < images.length; i++) {
        Asset asset = images[i];
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
      return null;
    }

    return ProfessionalCRUDResponse.fromJson(json.decode(resp.body));
  }

  Future<ProfessionalCRUDResponse> agregarImagenesServicio(int id, List<Asset> images) async {
    final uri = Uri.parse(ApiBaseHelper().baseUrl + 'business_service/upload_gallery' 
      + '?'
      + 'business_service_id=$id');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (images != null ) {
      for (int i = 0; i < images.length; i++) {
        Asset asset = images[i];
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
      return null;
    }

    return ProfessionalCRUDResponse.fromJson(json.decode(resp.body));
  }

  Future<ProfessionalCRUDResponse> registerPaypal(String key, String secret, int businessId) async {
    final response = await _helper.post(
      'business/update_paypal', 
      {
        'id': businessId,
        'paypal_key': key,
        'paypal_secret': secret
      }
    );
    return ProfessionalCRUDResponse.fromJson(response);
  }
}
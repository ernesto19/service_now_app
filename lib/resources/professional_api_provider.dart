import 'dart:async';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';

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
    List<ServicioPendiente> data = [
      ServicioPendiente(
        id: 1,
        firstName: 'Ernesto',
        lastName: 'Chira',
        businessName: 'Baberia ABC',
        servicesName: 'Corte de cabello, peinado',
        total: 'S/ 45.00',
        status: 1
      ),
      ServicioPendiente(
        id: 2,
        firstName: 'Leslie',
        lastName: 'Arroyo',
        businessName: 'Baberia ABC',
        servicesName: 'Corte de cabello, peinado',
        total: 'S/ 45.00',
        status: 2
      ),
      ServicioPendiente(
        id: 3,
        firstName: 'Gustavo',
        lastName: 'Ramirez',
        businessName: 'Baberia ABC',
        servicesName: 'Corte de cabello, peinado',
        total: 'S/ 45.00',
        status: 1
      )
    ];

    ServiciosPendientesResponse response = ServiciosPendientesResponse(
      error: 0,
      message: 'ok',
      data: data
    );

    return response;
    // final response = await _helper.get('business_request/inbox');
    // return ServiciosPendientesResponse.fromJson(response);
  }

  Future<void> iniciarServicio(int id) async {
    // await _helper.post(
    //   'business_request/aprove', 
    //   {
    //     'id': id
    //   }
    // );
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> terminarServicio(int id) async {
    // await _helper.post(
    //   'business_request/aprove', 
    //   {
    //     'id': id
    //   }
    // );
    await Future.delayed(Duration(seconds: 3));
  }
}
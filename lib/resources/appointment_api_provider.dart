import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/preferences/user_preferences.dart';

class AppointmentApiProvider {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AppointmentCRUDResponse> solicitarColaboracion(int businessId) async {
    final response = await _helper.post(
      'business_request/send', 
      {
        'business_id': businessId,
        'professional_user_id': UserPreferences.instance.userId
      }
    );
    return AppointmentCRUDResponse.fromJson(response);
  }

  Future<ProfessionalResponse> obtenerProfesionalesPorNegocio(int businessId) async {
    final response = await _helper.get('business/get_professionals?business_id=$businessId');
    return ProfessionalResponse.fromJson(response);
  }

  Future<ProfessionalDetailResponse> obtenerPerfilProfesional(int id) async {
    final response = await _helper.get('professional/profile/get?user_id=$id');
    return ProfessionalDetailResponse.fromJson(response);
  }

  Future<AppointmentCRUDResponse> solicitarServicio(int businessId, int professionalId) async {
    final response = await _helper.post(
      'business_service/pn_request_service', 
      {
        'business_id': businessId,
        'professional_user_id': professionalId
      }
    );
    return AppointmentCRUDResponse.fromJson(response);
  }

  Future<AppointmentCRUDResponse> finalizarSolicitud(List<Service> services, int professionalId) async {
    var serviceArray = [];

    services.forEach((service) { 
      serviceArray.add(service.id);
    });

    final response = await _helper.post(
      'business_service/pn_pay_service', 
      {
        'professional_user_id': professionalId,
        'services': serviceArray,
        'user_id': UserPreferences.instance.userId
      }
    );
    return AppointmentCRUDResponse.fromJson(response);
  }
}
import 'dart:async';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/models/professional_business.dart';

class ClientApiProvider {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ServiciosPendientesResponse> obtenerBandejaServicios() async {
    final response = await _helper.post(
      'business_service/get_user_services', {}
    );
    return ServiciosPendientesResponse.fromJson(response);
  }
}
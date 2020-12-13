import 'package:service_now/core/helpers/api_base_helper.dart';
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
}
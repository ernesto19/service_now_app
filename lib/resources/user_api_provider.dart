import 'package:service_now/helpers/api_base_helper.dart';
import 'package:service_now/models/user.dart';

class UserApiProvider {
  ApiBaseHelper _helper = ApiBaseHelper();
  
  Future<LoginResponse> login(String email, String password) async {
    final response = await _helper.post(
      'login', 
      {
        'email': email, 
        'password': password
      }
    );
    return LoginResponse.fromJson(response);
  }
}
import 'package:service_now/models/user.dart';
import 'package:service_now/resources/user_api_provider.dart';

class Repository {
  final userApiProvider = UserApiProvider();

  Future<LoginResponse> login(String email, String password) => userApiProvider.login(email, password);
}
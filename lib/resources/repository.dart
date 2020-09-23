import 'package:service_now/models/category.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/resources/service_api_provider.dart';
import 'package:service_now/resources/user_api_provider.dart';

class Repository {
  final userApiProvider = UserApiProvider();
  final serviceApiProvider = ServiceApiProvider();

  Future<LoginResponse> login(String email, String password) => userApiProvider.login(email, password);

  Future<CategoryResponse> getCategories() => serviceApiProvider.getCategories();
}
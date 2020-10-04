import 'package:service_now/features/login/data/models/user_model.dart';

class LoginResponse {
  int error;
  String message;
  UserModel data;

  LoginResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = new UserModel.fromJson(json['data']);
    }
  }
}
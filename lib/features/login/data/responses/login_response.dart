import 'package:service_now/features/login/data/models/user_model.dart';

class LoginResponse {
  int error;
  String message;
  UserModel data;
  var validation;

  LoginResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = UserModel.fromJson(json['data']);
    } else if (error == 2) {
      validation = json['data'];
    }
  }
}

class MembershipResponse {
  int error;
  String message;
  String data;

  MembershipResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = json['data'];
  }
}
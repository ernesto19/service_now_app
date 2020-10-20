import 'package:service_now/features/login/data/models/user_model.dart';

class SignUpResponse {
  int error;
  String message;
  UserModel data;
  var validation;

  SignUpResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = UserModel.fromJson(json['data'][0]);
    } else if (error == 2) {
      validation = json['data'];
    }
  }
}
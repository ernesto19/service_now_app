import 'package:meta/meta.dart';
import 'package:service_now/preferences/user_preferences.dart';

class LoginRequest {
  const LoginRequest({ @required this.email, @required this.password });

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fcm_token': UserPreferences.instance.fcmToken
    };
  }
}
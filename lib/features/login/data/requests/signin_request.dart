import 'package:meta/meta.dart';

class SigninRequest {
  const SigninRequest({ @required this.firstName, @required this.lastName, @required this.email, @required this.password, @required this.confirmPassword });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword
    };
  }
}
import 'package:flutter/material.dart';

abstract class LoginEvent {}

class AuthenticationByPasswordEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;
  final String message;

  AuthenticationByPasswordEvent(this.email, this.password, this.context, this.message);
}

class RegisterByPasswordEvent extends LoginEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final BuildContext context;
  final String message;

  RegisterByPasswordEvent(this.firstName, this.lastName, this.email, this.password, this.confirmPassword, this.context, this.message);
}

class AuthenticationByFacebookEvent extends LoginEvent {}

class AuthenticationByGoogleEvent extends LoginEvent {}
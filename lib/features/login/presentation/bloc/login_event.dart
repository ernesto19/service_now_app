import 'package:flutter/material.dart';

abstract class LoginEvent {}

class AuthenticationByPasswordEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;
  final String message;

  AuthenticationByPasswordEvent(this.email, this.password, this.context, this.message);
}

class AuthenticationByFacebookEvent extends LoginEvent {}

class AuthenticationByGoogleEvent extends LoginEvent {}
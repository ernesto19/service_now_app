import 'package:flutter/material.dart';

abstract class LoginEvent {}

class AuthenticationByPasswordEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  AuthenticationByPasswordEvent(this.email, this.password, this.context);
}

class AuthenticationByFacebookEvent extends LoginEvent {
  final String token;
  final BuildContext context;

  AuthenticationByFacebookEvent(this.token, this.context);
}

class AuthenticationByGoogleEvent extends LoginEvent {}
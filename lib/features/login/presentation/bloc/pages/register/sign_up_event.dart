import 'package:flutter/material.dart';

abstract class SignUpEvent {}

class RegisterByPasswordEvent extends SignUpEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final BuildContext context;
  final String message;

  RegisterByPasswordEvent(this.firstName, this.lastName, this.email, this.password, this.confirmPassword, this.context, this.message);
}
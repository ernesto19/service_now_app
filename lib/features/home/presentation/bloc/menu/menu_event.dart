import 'package:flutter/material.dart';

abstract class MenuEvent {}

class GetPermissionsForUser extends MenuEvent {
  GetPermissionsForUser();
}

class LogOutForUser extends MenuEvent {
  final BuildContext context;

  LogOutForUser(this.context);
}
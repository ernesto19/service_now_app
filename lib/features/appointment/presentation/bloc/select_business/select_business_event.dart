import 'package:flutter/material.dart';

abstract class SelectBusinessEvent { }

class RequestBusinessForUser extends SelectBusinessEvent {
  final int businessId;
  final BuildContext context;

  RequestBusinessForUser(this.businessId, this.context);
}
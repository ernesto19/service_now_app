import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';

abstract class PaymentServicesEvent { }

class PaymentServicesForUser extends PaymentServicesEvent {
  final int userId;
  final List<Service> services;
  final BuildContext context;

  PaymentServicesForUser(this.userId, this.services, this.context);
}
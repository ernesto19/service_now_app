import 'package:meta/meta.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';

class PaymentServicesRequest {
  const PaymentServicesRequest({ @required this.services, @required this.userId });

  final List<Service> services;
  final int userId;

  Map<String, dynamic> toJson() {
    var serviceArray = [];

    services.forEach((service) { 
      serviceArray.add(service.id);
    });

    return {
      'user_id': userId,
      'services': serviceArray
    };
  }
}
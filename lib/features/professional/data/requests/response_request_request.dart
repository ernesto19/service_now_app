import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

class ResponseRequestRequest {
  const ResponseRequestRequest({ @required this.services, @required this.userId });

  final List<ProfessionalService> services;
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
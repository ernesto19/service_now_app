import 'package:meta/meta.dart';

class GetProfessionalServicesRequest {
  const GetProfessionalServicesRequest({ @required this.professionalBusinessId });

  final int professionalBusinessId;

  Map<String, dynamic> toJson() {
    return {
      'professional_id': professionalBusinessId
    };
  }
}
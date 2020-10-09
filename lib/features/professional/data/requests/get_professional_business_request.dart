import 'package:meta/meta.dart';

class GetProfessionalBusinessRequest {
  const GetProfessionalBusinessRequest({ @required this.professionalId });

  final int professionalId;

  Map<String, dynamic> toJson() {
    return {
      'professional_id': professionalId
    };
  }
}
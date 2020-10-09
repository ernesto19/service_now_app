import 'package:service_now/features/professional/data/models/professional_service_model.dart';

class GetProfessionalServicesResponse {
  int error;
  String message;
  List<ProfessionalServiceModel> data = List();

  GetProfessionalServicesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final service = ProfessionalServiceModel.fromJson(item);
        data.add(service);
      }
    }
  }
}
import 'package:service_now/features/professional/data/models/professional_business_model.dart';

class GetProfessionalBusinessResponse {
  int error;
  String message;
  List<ProfessionalBusinessModel> data = List();

  GetProfessionalBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final business = ProfessionalBusinessModel.fromJson(item);
        data.add(business);
      }
    }
  }
}
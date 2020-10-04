import 'package:service_now/features/appointment/data/models/business_model.dart';

class GetBusinessResponse {
  int error;
  String message;
  List<BusinessModel> data = List();

  GetBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final business = BusinessModel.fromJson(item);
        data.add(business);
      }
    }
  }
}
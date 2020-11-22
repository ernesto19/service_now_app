import 'package:service_now/features/appointment/data/models/service_model.dart';

class GetGalleriesResponse {
  int error;
  String message;
  List<ServiceModel> data = List();

  GetGalleriesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final gallery = ServiceModel.fromJson(item);
        data.add(gallery);
      }
    }
  }
}
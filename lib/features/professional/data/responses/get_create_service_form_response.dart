import 'package:service_now/features/professional/data/models/industry_model.dart';

class GetCreateServiceFormResponse {
  int error;
  String message;
  CreateServiceForm data;

  GetCreateServiceFormResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = CreateServiceForm.fromJson(json['data']);
  }
}

class CreateServiceForm {
  List<IndustryModel> industries = List();
  List<CategoryModel> categories = List();
  List<ServiceModel> services = List();

  CreateServiceForm.fromJson(dynamic json) {
    if (json == null) return;

    for (var item in json['industries']) {
      final industry = IndustryModel.fromJson(item);
      industries.add(industry);
    }

    for (var item in json['categories']) {
      final category = CategoryModel.fromJson(item);
      categories.add(category);
    }

    for (var item in json['services']) {
      final service = ServiceModel.fromJson(item);
      services.add(service);
    }
  }
}
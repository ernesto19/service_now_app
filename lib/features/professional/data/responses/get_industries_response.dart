import 'package:service_now/features/professional/data/models/industry_model.dart';

class GetIndustriesResponse {
  int error;
  String message;
  IndustryCategory data;

  GetIndustriesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = IndustryCategory.fromJson(json['data']);
  }
}

class IndustryCategory {
  List<IndustryModel> industries = List();
  List<CategoryModel> categories = List();

  IndustryCategory.fromJson(dynamic json) {
    if (json == null) return;

    for (var item in json['industries']) {
      final industry = IndustryModel.fromJson(item);
      industries.add(industry);
    }

    for (var item in json['categories']) {
      final category = CategoryModel.fromJson(item);
      categories.add(category);
    }
  }
}
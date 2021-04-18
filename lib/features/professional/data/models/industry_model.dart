import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';

class IndustryModel extends Industry {
  IndustryModel({
    @required int id, 
    @required String name
  }) : super(id: id, name: name);

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      id:   json['id']    ?? 0, 
      name: json['name']  ?? ''
    );
  }
}

class CategoryModel extends Category {
  CategoryModel({
    @required int id, 
    @required String name,
    @required int industryId
  }) : super(id: id, name: name, industryId: industryId);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id:   json['id']    ?? 0, 
      name: json['name']  ?? '',
      industryId: json['industry_id'] is int ? json['industry_id'] ?? 0 : int.parse(json['industry_id'] ?? '0'),
    );
  }
}

class ServiceModel extends Service {
  ServiceModel({
    @required int id, 
    @required String name,
    @required int categoryId
  }) : super(id: id, name: name, categoryId: categoryId);

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id:   json['id']    ?? 0, 
      name: json['name']  ?? '',
      categoryId: json['business_categories_id'] ?? 0
    );
  }
}
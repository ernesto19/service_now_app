import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:meta/meta.dart';

class CategoryModel extends Category {
  CategoryModel({
    @required int id,
    @required String name,
    @required String logo,
    @required int favorite
  }) : super(id: id, name: name, logo: logo, favorite: favorite);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'], 
      name: json['name'], 
      logo: json['logo'], 
      favorite: int.parse(json['favorite'].toString())
    );
  }

  Map<String, dynamic> toJson() {
    var json = {
      'id': id,
      'name': name,
      'logo': logo,
      'favorite': favorite
    };

    return json;
  }

  CategoryModel onFavorites() {
    return CategoryModel(
      id: this.id, 
      name: this.name, 
      logo: this.logo, 
      favorite: this.favorite == 1 ? 0 : 1
    );
  }
}

class CategoryResponse {
  int error;
  String message;
  List<CategoryModel> data = List();

  CategoryResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final request = CategoryModel.fromJson(item);
        data.add(request);
      }
    }
  }
}
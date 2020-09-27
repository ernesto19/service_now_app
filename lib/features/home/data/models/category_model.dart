// import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:meta/meta.dart';

class CategoryModel/* extends Category*/ {
  final int id;
  final String name;
  final String logo;
  final bool favorite;
  /*CategoryModel({
    @required int id,
    @required String name,
    @required String logo,
    @required bool favorite
  }) : super(id: id, name: name, logo: logo, favorite: favorite);*/
  CategoryModel({
    this.id,
    this.name,
    this.logo,
    this.favorite = false
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'], 
      name: json['name'], 
      logo: json['logo'], 
      // favorite: json['favorite'] == 1
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'favorite': favorite
    };
  }

  CategoryModel onFavorites() {
    final category = CategoryModel(
      id: this.id, 
      name: this.name, 
      logo: this.logo, 
      favorite: !this.favorite
    );

    print('========= ${category.favorite} =========');

    return category;
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
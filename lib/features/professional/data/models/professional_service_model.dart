import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

class ProfessionalServiceModel extends ProfessionalService {
  ProfessionalServiceModel({
    @required int id, 
    @required String name,
    @required String price,
    @required List<ProfessionalServiceGallery> gallery
  }) : super(id: id, name: name, price: price, gallery: gallery);

  factory ProfessionalServiceModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalServiceModel(
      id:     json['id']    ?? '', 
      name:   json['name']  ?? '',
      price:  json['price']  ?? '',
      gallery: ListProfessionalServiceGallery.fromJson(json).galleries
    );
  }
}

class ListProfessionalServiceGallery {
  List<ProfessionalServiceGallery> galleries;

  ListProfessionalServiceGallery.fromJson(dynamic json) {
    galleries = List();
    for (var item in json['gallery']) {
      final gallery = ProfessionalServiceGallery.fromJson(item);
      galleries.add(gallery);
    }
  }
}
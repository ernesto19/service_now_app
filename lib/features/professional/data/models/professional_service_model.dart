import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

class ProfessionalServiceModel extends ProfessionalService {
  ProfessionalServiceModel({
    @required int id, 
    @required String name,
    @required String price,
    @required List<ProfessionalServiceGallery> gallery,
    @required int serviceId,
    @required int selected
  }) : super(id: id, name: name, price: price, gallery: gallery, serviceId: serviceId, selected: selected);

  factory ProfessionalServiceModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalServiceModel(
      id:     json['id']    ?? 0, 
      name:   json['name']  ?? '',
      price:  json['price']  ?? '',
      gallery: ListProfessionalServiceGallery.fromJson(json).galleries,
      serviceId: json['service_id']  ?? 0,
      selected: 0
    );
  }

  Map<String, dynamic> toJson() {
    var json = {
      'id': id,
      'name': name,
      'price': price,
      'service_id': serviceId,
      'selected': selected
    };

    return json;
  }

  ProfessionalServiceModel onSelected() {
    return ProfessionalServiceModel(
      id: this.id, 
      name: this.name, 
      price: this.price, 
      gallery: [], 
      serviceId: this.serviceId,
      selected: this.selected == 1 ? 0 : 1
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
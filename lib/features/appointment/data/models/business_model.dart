import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:meta/meta.dart';

class BusinessModel extends Business {
  BusinessModel({
    @required int id, 
    @required String name, 
    @required String description, 
    @required String latitude, 
    @required String longitude, 
    @required String rating, 
    @required double distance,
    @required int active,
    @required String address,
    @required String phone,
    @required List<BusinessGallery> gallery
  }) : super(id: id, name: name, description: description, latitude: latitude, longitude: longitude, rating: rating, distance: distance, active: active, address: address, phone: phone, gallery: gallery);

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id:           json['id'], 
      name:         json['name'], 
      description:  json['description'], 
      latitude:     json['lat'].toString(),
      longitude:    json['lng'].toString(),
      rating:       json['rating'],
      distance:     json['distance'],
      active:       json['active'],
      address:      json['address'] ?? '',
      phone:        json['phone'] ?? '',
      gallery:      ListBusinessGallery.fromJson(json).galleries
    );
  }
}

class ListBusinessGallery {
  List<BusinessGallery> galleries;

  ListBusinessGallery.fromJson(dynamic json) {
    galleries = List();
    for (var item in json['gallery']) {
      final businessGallery = BusinessGallery.fromJson(item);
      galleries.add(businessGallery);
    }
  }
}
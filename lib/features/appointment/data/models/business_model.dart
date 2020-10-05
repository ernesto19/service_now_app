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
    @required double distance
  }) : super(id: id, name: name, description: description, latitude: latitude, longitude: longitude, rating: rating, distance: distance);

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id:           json['id'], 
      name:         json['name'], 
      description:  json['description'], 
      latitude:     (json['lat'] as double).toStringAsFixed(2),
      longitude:    (json['lng'] as double).toStringAsFixed(2),
      rating:       json['rating'],
      distance:     json['distance']
    );
  }

  String toString() {
    return '\n$id\n$name\n$description\n';
  }
}
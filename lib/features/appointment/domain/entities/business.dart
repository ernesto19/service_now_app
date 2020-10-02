import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Business extends Equatable {
  final int id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final String rating;
  final double distance;

  Business({
    @required this.id, 
    @required this.name, 
    @required this.description, 
    @required this.latitude, 
    @required this.longitude, 
    @required this.rating, 
    @required this.distance
  });

  @override
  List<Object> get props => [id, name, description, latitude, longitude, rating, distance];
}
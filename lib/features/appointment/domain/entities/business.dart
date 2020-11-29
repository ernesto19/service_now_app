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
  final int active;
  final String address;
  final String phone;
  final List<BusinessGallery> gallery;

  Business({
    @required this.id, 
    @required this.name, 
    @required this.description, 
    @required this.latitude, 
    @required this.longitude, 
    @required this.rating, 
    @required this.distance,
    @required this.active,
    @required this.address,
    @required this.phone,
    @required this.gallery
  });

  @override
  List<Object> get props => [id, name, description, latitude, longitude, rating, distance, address, phone, gallery];
}

class BusinessGallery {
  int id;
  int businessId;
  String url;

  BusinessGallery.fromJson(dynamic json) {
    id          = json['id'];
    businessId  = json['business_id'];
    url         = 'https://archivosprestape.s3.amazonaws.com/' + json['url'];
  }
}
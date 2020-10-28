import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalService extends Equatable {
  final int id;
  final String name;
  final String price;
  final List<ProfessionalServiceGallery> gallery;

  ProfessionalService({
    @required this.id, 
    @required this.name, 
    @required this.price,
    @required this.gallery
  });

  @override
  List<Object> get props => [id, name, price, gallery];
}

class ProfessionalServiceGallery {
  int id;
  String url;

  ProfessionalServiceGallery.fromJson(dynamic json) {
    id  = json['id'];
    url = 'https://archivosprestape.s3.amazonaws.com/' + json['url'];
  }
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalService extends Equatable {
  final int id;
  final String name;
  final String price;
  final List<ProfessionalServiceGallery> gallery;
  final int serviceId;
  final int selected;

  ProfessionalService({
    @required this.id, 
    @required this.name, 
    @required this.price,
    @required this.gallery,
    @required this.serviceId,
    @required this.selected
  });

  ProfessionalService onSelected() {
    return ProfessionalService(
      id: this.id, 
      name: this.name,
      price: this.price,
      gallery: [],
      serviceId: this.serviceId,
      selected: this.selected == 1 ? 0 : 1
    );
  }

  @override
  List<Object> get props => [id, name, price, gallery, serviceId, selected];
}

class ProfessionalServiceGallery {
  int id;
  String url;

  ProfessionalServiceGallery.fromJson(dynamic json) {
    id  = json['id'];
    url = 'https://archivosprestape.s3.amazonaws.com/' + json['url'];
  }
}
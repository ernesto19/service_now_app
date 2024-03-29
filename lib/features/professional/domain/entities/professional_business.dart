import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalBusiness extends Equatable {
  final int id;
  final String name;
  final String description;
  final int categoryId;
  final String categoryName;
  final int industryId;
  final String address;
  final String licenseNumber;
  final String fanpage;
  final String logo;
  final String latitude;
  final String longitude;
  final int active;
  final List<ProfessionalBusinessGallery> gallery;

  ProfessionalBusiness({
    @required this.id, 
    @required this.name, 
    @required this.description, 
    @required this.categoryId,
    @required this.categoryName,
    @required this.industryId,
    @required this.address,
    @required this.licenseNumber,
    @required this.fanpage,
    @required this.logo,
    @required this.latitude,
    @required this.longitude,
    @required this.active,
    @required this.gallery
  });

  ProfessionalBusiness onActive() {
    return ProfessionalBusiness(
      id: this.id, 
      name: this.name, 
      description: this.description,
      categoryId: this.categoryId,
      categoryName: this.categoryName,
      industryId: this.industryId,
      address: this.address,
      licenseNumber: this.licenseNumber,
      fanpage: this.fanpage,
      logo: this.logo, 
      latitude: this.latitude,
      longitude: this.longitude,
      active: this.active == 1 ? 0 : 1,
      gallery: this.gallery
    );
  }

  ProfessionalBusiness onDeleteImage() {
    return ProfessionalBusiness(
      id: this.id, 
      name: this.name, 
      description: this.description,
      categoryId: this.categoryId,
      categoryName: this.categoryName,
      industryId: this.industryId,
      address: this.address,
      licenseNumber: this.licenseNumber,
      fanpage: this.fanpage,
      logo: this.logo, 
      latitude: this.latitude,
      longitude: this.longitude,
      active: this.active == 1 ? 0 : 1,
      gallery: List()
    );
  }

  @override
  List<Object> get props => [id, name, description, categoryId, categoryName, industryId, address, licenseNumber, fanpage, logo, latitude, longitude, active, gallery];
}

class ProfessionalBusinessGallery {
  int id;
  String url;

  ProfessionalBusinessGallery.fromJson(dynamic json) {
    id  = json['id'];
    url = 'https://archivosprestape.s3.amazonaws.com/' + json['url'];
  }
}
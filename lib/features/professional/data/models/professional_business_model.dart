import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';

class ProfessionalBusinessModel extends ProfessionalBusiness {
  ProfessionalBusinessModel({
    @required int id, 
    @required String name, 
    @required String description, 
    @required int categoryId,
    @required String categoryName,
    @required int industryId,
    @required String address,
    @required String licenseNumber,
    @required String fanpage,
    @required String logo,
    @required String latitude,
    @required String longitude,
    @required int active,
    @required List<ProfessionalBusinessGallery> gallery
  }) : super(id: id, name: name, description: description, categoryId: categoryId, categoryName: categoryName, industryId: industryId, address: address, licenseNumber: licenseNumber, fanpage: fanpage, logo: logo, latitude: latitude, longitude: longitude, active: active, gallery: gallery);

  factory ProfessionalBusinessModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalBusinessModel(
      id:           json['id'], 
      name:         json['name']            ?? '', 
      description:  json['description']     ?? '',
      categoryId:   json['category_id']     ?? 0,
      categoryName: json['category_name']   ?? '',
      industryId:   json['industry_id']     ?? 0,
      address:      json['address']         ?? '',
      licenseNumber: json['license']        ?? '',
      fanpage:      json['fanpage']         ?? '',
      logo:         json['logo']            ?? '',
      latitude:     json['lat'].toString()  ?? '',
      longitude:    json['lng'].toString()  ?? '',
      active:       json['active']          ?? 0,
      gallery:      ListProfessionalBusinessGallery.fromJson(json).galleries
    );
  }
}

class ListProfessionalBusinessGallery {
  List<ProfessionalBusinessGallery> galleries;

  ListProfessionalBusinessGallery.fromJson(dynamic json) {
    galleries = List();
    for (var item in json['gallery']) {
      final businessGallery = ProfessionalBusinessGallery.fromJson(item);
      galleries.add(businessGallery);
    }
  }
}
import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';

class ProfessionalBusinessModel extends ProfessionalBusiness {
  ProfessionalBusinessModel({
    @required int id, 
    @required String name, 
    @required String description, 
    @required int categoryId,
    @required String categoryName,
    @required String address,
    @required String licenceNumber,
    @required String fanpage,
    @required String logo,
    @required String latitude,
    @required String longitude
  }) : super(id: id, name: name, description: description, categoryId: categoryId, categoryName: categoryName, address: address, licenceNumber: licenceNumber, fanpage: fanpage, logo: logo, latitude: latitude, longitude: longitude);

  factory ProfessionalBusinessModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalBusinessModel(
      id:           json['id'], 
      name:         json['name']            ?? '', 
      description:  json['description']     ?? '',
      categoryId:   json['category_id']     ?? '',
      categoryName: json['category_name']   ?? '',
      address:      json['address']         ?? '',
      licenceNumber: json['licence_number'] ?? '',
      fanpage:      json['fanpage']         ?? '',
      logo:         json['logo']            ?? '',
      latitude:     json['latitude']        ?? '',
      longitude:    json['longitude']       ?? ''
    );
  }
}
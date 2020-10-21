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
    @required String licenseNumber,
    @required String fanpage,
    @required String logo,
    @required String latitude,
    @required String longitude,
    @required int active
  }) : super(id: id, name: name, description: description, categoryId: categoryId, categoryName: categoryName, address: address, licenseNumber: licenseNumber, fanpage: fanpage, logo: logo, latitude: latitude, longitude: longitude, active: active);

  factory ProfessionalBusinessModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalBusinessModel(
      id:           json['id'], 
      name:         json['name']            ?? '', 
      description:  json['description']     ?? '',
      categoryId:   json['category_id']     ?? '',
      categoryName: json['category_name']   ?? '',
      address:      json['address']         ?? '',
      licenseNumber: json['license']        ?? '',
      fanpage:      json['fanpage']         ?? '',
      logo:         json['logo']            ?? '',
      latitude:     json['lat'].toString()  ?? '',
      longitude:    json['lng'].toString()  ?? '',
      active:       json['active']          ?? 0
    );
  }
}
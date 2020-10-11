import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

class ProfessionalServiceModel extends ProfessionalService{
  ProfessionalServiceModel({
    @required int id, 
    @required String name, 
    @required String description,
    @required int industryId,
    @required String industryName,
    @required int industryTypeId,
    @required String industryTypeName,
    @required List<SubService> subServices
  }) : super(id: id, name: name, description: description, industryId: industryId, industryName: industryName, industryTypeId: industryTypeId, industryTypeName: industryTypeName, subServices: subServices);

  factory ProfessionalServiceModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalServiceModel(
      id:             json['id']              ?? '', 
      name:           json['name']            ?? '', 
      description:    json['description']     ?? '',
      industryId:     json['industry_id']     ?? '',
      industryName:   json['industry_name']   ?? '',
      industryTypeId: json['industry_type_id'] ?? '',
      industryTypeName: json['industry_type_name'],
      subServices:    ListSubServices.fromJson(json).subServices
    );
  }
}

class ListSubServices {
  List<SubService> subServices;

  ListSubServices.fromJson(dynamic json) {
    subServices = List();
    for (var item in json['sub_services']) {
      final subService = SubService.fromJson(item);
      subServices.add(subService);
    }
  }
}
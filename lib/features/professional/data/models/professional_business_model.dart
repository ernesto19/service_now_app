import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';

class ProfessionalBusinessModel extends ProfessionalBusiness {
  ProfessionalBusinessModel({
    @required int id, 
    @required String name, 
    @required String description, 
    @required String address
  }) : super(id: id, name: name, description: description, address: address);

  factory ProfessionalBusinessModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalBusinessModel(
      id:           json['id'], 
      name:         json['name'], 
      description:  json['description'],
      address:      json['address'],
    );
  }
}
import 'package:meta/meta.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

class ProfessionalServiceModel extends ProfessionalService{
  ProfessionalServiceModel({
    @required int id, 
    @required String name, 
    @required String description
  }) : super(id: id, name: name, description: description);

  factory ProfessionalServiceModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalServiceModel(
      id:           json['id'], 
      name:         json['name'], 
      description:  json['description']
    );
  }
}
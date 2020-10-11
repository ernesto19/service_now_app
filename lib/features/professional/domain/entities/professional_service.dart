import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalService extends Equatable {
  final int id;
  final String name;
  final String description;
  final int industryId;
  final String industryName;
  final int industryTypeId;
  final String industryTypeName;
  final List<SubService> subServices;

  ProfessionalService({
    @required this.id, 
    @required this.name, 
    @required this.description,
    @required this.industryId,
    @required this.industryName,
    @required this.industryTypeId,
    @required this.industryTypeName,
    @required this.subServices
  });

  @override
  List<Object> get props => [id, name, description, industryId, industryName, industryTypeId, industryTypeName, subServices];
}

class SubService {
  int id;
  String name;

  SubService.fromJson(dynamic json) {
    id    = json['id'];
    name  = json['name'];
  }
}
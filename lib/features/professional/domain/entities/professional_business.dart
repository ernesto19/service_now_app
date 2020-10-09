import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalBusiness extends Equatable {
  final int id;
  final String name;
  final String description;
  final String address;

  ProfessionalBusiness({
    @required this.id, 
    @required this.name, 
    @required this.description, 
    @required this.address
  });

  @override
  List<Object> get props => [id, name, description, address];
}
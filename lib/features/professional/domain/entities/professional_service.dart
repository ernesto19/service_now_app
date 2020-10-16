import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalService extends Equatable {
  final int id;
  final String name;
  final String price;

  ProfessionalService({
    @required this.id, 
    @required this.name, 
    @required this.price
  });

  @override
  List<Object> get props => [id, name, price];
}
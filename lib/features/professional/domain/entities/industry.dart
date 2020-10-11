import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Industry extends Equatable {
  final int id;
  final String name;

  Industry({
    @required this.id, 
    @required this.name
  });

  @override
  List<Object> get props => [id, name];
}

class Category extends Equatable {
  final int id;
  final String name;
  final int industryId;

  Category({
    @required this.id, 
    @required this.name,
    @required this.industryId
  });

  @override
  List<Object> get props => [id, name, industryId];
}
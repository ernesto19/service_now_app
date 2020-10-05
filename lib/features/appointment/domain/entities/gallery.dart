import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Gallery extends Equatable {
  final int businessServiceId;
  final String name;
  final List<String> photos;

  Gallery({
    @required this.businessServiceId, 
    @required this.name,
    @required this.photos
  });

  @override
  List<Object> get props => [businessServiceId, name, photos];
}
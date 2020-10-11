import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfessionalBusiness extends Equatable {
  final int id;
  final String name;
  final String description;
  final int categoryId;
  final String categoryName;
  final String address;
  final String licenceNumber;
  final String fanpage;
  final String logo;
  final String latitude;
  final String longitude;

  ProfessionalBusiness({
    @required this.id, 
    @required this.name, 
    @required this.description, 
    @required this.categoryId,
    @required this.categoryName,
    @required this.address,
    @required this.licenceNumber,
    @required this.fanpage,
    @required this.logo,
    @required this.latitude,
    @required this.longitude
  });

  @override
  List<Object> get props => [id, name, description, categoryId, categoryName, address, licenceNumber, fanpage, logo, latitude, longitude];
}
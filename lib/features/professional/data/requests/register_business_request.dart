import 'package:multi_image_picker/multi_image_picker.dart';

class RegisterBusinessRequest {
  final int businessId;
  final String name;
  final String description;
  final int industryId;
  final int categoryId;
  final String licenseNumber;
  final String jobOffer;
  final String latitude;
  final String longitude;
  final String address;
  final String fanpage;
  final List<Asset> images;

  RegisterBusinessRequest({ this.businessId, this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage, this.images });
}
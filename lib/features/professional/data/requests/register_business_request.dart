class RegisterBusinessRequest {
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

  RegisterBusinessRequest({ this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage });
}
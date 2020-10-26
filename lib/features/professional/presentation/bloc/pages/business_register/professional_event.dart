import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class ProfessionalEvent { }

class GetBusinessForProfessional extends ProfessionalEvent {
  GetBusinessForProfessional();
}

class GetServicesForProfessional extends ProfessionalEvent {
  final int professionalBusinessId;

  GetServicesForProfessional(this.professionalBusinessId);
}

class GetIndustriesForProfessional extends ProfessionalEvent {

  GetIndustriesForProfessional();
}

class GetCreateServiceFormForProfessional extends ProfessionalEvent {

  GetCreateServiceFormForProfessional();
}

class RegisterBusinessForProfessional extends ProfessionalEvent {
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
  final BuildContext context;

  RegisterBusinessForProfessional(this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage, this.images, this.context);
}

class RegisterServiceForProfessional extends ProfessionalEvent {
  final int businessId;
  final int serviceId;
  final double price;
  final List<Asset> images;
  final BuildContext context;

  RegisterServiceForProfessional(this.businessId, this.serviceId, this.price, this.images, this.context);
}

class OnActiveEvent extends ProfessionalEvent {
  final int id;

  OnActiveEvent(this.id);
}
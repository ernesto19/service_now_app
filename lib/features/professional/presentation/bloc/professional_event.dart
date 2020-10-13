import 'package:flutter/material.dart';

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
  final BuildContext context;

  RegisterBusinessForProfessional(this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage, this.context);
}

class OnActiveEvent extends ProfessionalEvent {
  final int id;

  OnActiveEvent(this.id);
}
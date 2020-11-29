import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

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
  final String phone;
  final List<Asset> images;
  final BuildContext context;

  RegisterBusinessForProfessional(this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage, this.phone, this.images, this.context);
}

class UpdateBusinessForProfessional extends ProfessionalEvent {
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
  final String phone;
  final BuildContext context;

  UpdateBusinessForProfessional(this.businessId, this.name, this.description, this.industryId, this.categoryId, this.licenseNumber, this.jobOffer, this.latitude, this.longitude, this.address, this.fanpage, this.phone, this.context);
}

class RegisterServiceForProfessional extends ProfessionalEvent {
  final int businessId;
  final int serviceId;
  final double price;
  final List<Asset> images;
  final BuildContext context;

  RegisterServiceForProfessional(this.businessId, this.serviceId, this.price, this.images, this.context);
}

class UpdateServiceForProfessional extends ProfessionalEvent {
  final int id;
  final double price;
  final BuildContext context;

  UpdateServiceForProfessional(this.id, this.price, this.context);
}

class OnActiveEvent extends ProfessionalEvent {
  final int id;

  OnActiveEvent(this.id);
}

class OnSelectedServiceEvent extends ProfessionalEvent {
  final int id;

  OnSelectedServiceEvent(this.id);
}

class RequestResponseForBusiness extends ProfessionalEvent {
  final List<ProfessionalService> services;
  final int userId;
  final BuildContext context;

  RequestResponseForBusiness(this.services, this.userId, this.context);
}

class DeleteImageForProfessional extends ProfessionalEvent {
  final int id;
  final int businessId;
  final BuildContext context;

  DeleteImageForProfessional(this.id, this.businessId, this.context);
}
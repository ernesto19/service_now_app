import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

enum ProfessionalStatus { checking, loading, selecting, downloading, ready, error, loadingServices, readyServices }
enum RegisterBusinessFormDataStatus { checking, loading, ready, error, mapMount }
enum RegisterBusinessStatus { checking, registering, registered, error }
enum RegisterServiceFormDataStatus { checking, loading, ready, error }
enum RegisterServiceStatus { checking, registering, registered, error }
enum GalleryStatus { checking, loading, deleting, ready, error }

class ProfessionalState extends Equatable {
  final List<ProfessionalBusiness> business;
  final List<ProfessionalService> services;
  final IndustryCategory formData;
  final RegisterBusinessResponse registerBusinessResponse;
  final ProfessionalStatus status;
  final RegisterBusinessStatus registerBusinessStatus;
  final RegisterBusinessFormDataStatus formStatus;
  final RegisterServiceFormDataStatus serviceFormStatus;
  final CreateServiceForm serviceFormData;
  final RegisterServiceResponse registerServiceResponse;
  final RegisterServiceStatus registerServiceStatus;
  final String errorMessage;
  final GalleryStatus galleryStatus;
  final DeleteImageResponse deleteResponse;

  ProfessionalState({ this.business, this.services, this.status, this.formData, this.registerBusinessResponse, this.registerBusinessStatus, this.formStatus, this.serviceFormStatus, this.serviceFormData, this.registerServiceResponse, this.registerServiceStatus, this.errorMessage, this.galleryStatus, this.deleteResponse });

  static ProfessionalState get initialState => ProfessionalState(
    business: const [],
    services: const [],
    formData: null,
    serviceFormData: null,
    registerBusinessResponse: null,
    registerServiceResponse: null,
    status: ProfessionalStatus.loading,
    formStatus: RegisterBusinessFormDataStatus.checking,
    registerBusinessStatus: RegisterBusinessStatus.checking,
    serviceFormStatus: RegisterServiceFormDataStatus.checking,
    registerServiceStatus: RegisterServiceStatus.checking,
    errorMessage: '',
    galleryStatus: GalleryStatus.checking,
    deleteResponse: null
  );

  ProfessionalState copyWith({ 
    List<ProfessionalBusiness> business,
    List<ProfessionalService> services,
    IndustryCategory formData,
    RegisterBusinessResponse registerBusinessResponse,
    ProfessionalStatus status,
    RegisterBusinessStatus registerBusinessStatus,
    RegisterBusinessFormDataStatus formStatus,
    RegisterServiceFormDataStatus serviceFormStatus,
    CreateServiceForm serviceFormData,
    RegisterServiceResponse registerServiceResponse,
    RegisterServiceStatus registerServiceStatus,
    String errorMessage,
    GalleryStatus galleryStatus,
    DeleteImageResponse deleteResponse
  }) {
    return ProfessionalState(
      business: business ?? this.business,
      services: services ?? this.services,
      formData: formData ?? this.formData,
      registerBusinessResponse: registerBusinessResponse ?? this.registerBusinessResponse,
      status: status ?? this.status,
      registerBusinessStatus: registerBusinessStatus ?? this.registerBusinessStatus,
      formStatus: formStatus ?? this.formStatus,
      serviceFormStatus: serviceFormStatus ?? this.serviceFormStatus,
      serviceFormData: serviceFormData ?? this.serviceFormData,
      registerServiceResponse: registerServiceResponse ?? this.registerServiceResponse,
      registerServiceStatus: registerServiceStatus ?? this.registerServiceStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      galleryStatus: galleryStatus ?? this.galleryStatus,
      deleteResponse: deleteResponse ?? this.deleteResponse
    );
  }

  @override
  List<Object> get props => [business, services, status, formData, registerBusinessResponse, registerBusinessStatus, formStatus, serviceFormData, serviceFormStatus, registerServiceResponse, errorMessage, galleryStatus, deleteResponse];
}
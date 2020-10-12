import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

enum ProfessionalStatus { checking, loading, selecting, downloading, ready, error, loadingServices, readyServices }
enum RegisterBusinessFormDataStatus { checking, loading, ready, error }
enum RegisterBusinessStatus { checking, registering, registered, error }
enum RegisterServiceFormDataStatus { checking, loading, ready, error }

class ProfessionalState extends Equatable {
  final List<ProfessionalBusiness> business;
  final List<ProfessionalService> services;
  final IndustryCategory formData;
  final RegisterBusinessResponse registerBusinessResponse;
  final ProfessionalStatus status;
  final RegisterBusinessStatus registerBusinessStatus;
  final RegisterBusinessFormDataStatus formStatus;

  ProfessionalState({ this.business, this.services, this.status, this.formData, this.registerBusinessResponse, this.registerBusinessStatus, this.formStatus });

  static ProfessionalState get initialState => ProfessionalState(
    business: const [],
    services: const [],
    formData: null,
    registerBusinessResponse: null,
    status: ProfessionalStatus.loading,
    formStatus: RegisterBusinessFormDataStatus.checking,
    registerBusinessStatus: RegisterBusinessStatus.checking
  );

  ProfessionalState copyWith({ 
    List<ProfessionalBusiness> business,
    List<ProfessionalService> services,
    IndustryCategory formData,
    RegisterBusinessResponse registerBusinessResponse,
    ProfessionalStatus status,
    RegisterBusinessStatus registerBusinessStatus,
    RegisterBusinessFormDataStatus formStatus
  }) {
    return ProfessionalState(
      business: business ?? this.business,
      services: services ?? this.services,
      formData: formData ?? this.formData,
      registerBusinessResponse: registerBusinessResponse ?? this.registerBusinessResponse,
      status: status ?? this.status,
      registerBusinessStatus: registerBusinessStatus ?? this.registerBusinessStatus,
      formStatus: formStatus ?? this.formStatus
    );
  }

  @override
  List<Object> get props => [business, services, status, formData, registerBusinessResponse, registerBusinessStatus, formStatus];
}
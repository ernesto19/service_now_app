import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

enum ProfessionalStatus { checking, loading, selecting, downloading, ready, error, loadingServices, readyServices, loadingIndustries, readyIndustries, registeringBusiness, registeredBusiness }

class ProfessionalState extends Equatable {
  final List<ProfessionalBusiness> business;
  final List<ProfessionalService> services;
  final IndustryCategory industries;
  final RegisterBusinessResponse registerBusinessResponse;
  final ProfessionalStatus status;

  ProfessionalState({ this.business, this.services, this.status, this.industries, this.registerBusinessResponse });

  static ProfessionalState get initialState => ProfessionalState(
    business: const [],
    services: const [],
    industries: null,
    registerBusinessResponse: null,
    status: ProfessionalStatus.loading
  );

  ProfessionalState copyWith({ 
    List<ProfessionalBusiness> business,
    List<ProfessionalService> services,
    IndustryCategory industries,
    RegisterBusinessResponse registerBusinessResponse,
    ProfessionalStatus status
  }) {
    return ProfessionalState(
      business: business ?? this.business,
      services: services ?? this.services,
      industries: industries ?? this.industries,
      registerBusinessResponse: registerBusinessResponse ?? this.registerBusinessResponse,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [business, services, status];
}
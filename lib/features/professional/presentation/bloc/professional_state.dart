import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

enum ProfessionalStatus { checking, loading, selecting, downloading, ready, error, loadingServices, readyServices }

class ProfessionalState extends Equatable {
  final List<ProfessionalBusiness> business;
  final List<ProfessionalService> services;
  final ProfessionalStatus status;

  ProfessionalState({ this.business, this.services, this.status });

  static ProfessionalState get initialState => ProfessionalState(
    business: const [],
    services: const [],
    status: ProfessionalStatus.loading
  );

  ProfessionalState copyWith({ 
    List<ProfessionalBusiness> business,
    List<ProfessionalService> services,
    ProfessionalStatus status
  }) {
    return ProfessionalState(
      business: business ?? this.business,
      services: services ?? this.services,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [business, services, status];
}
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';

enum ProfessionalStatus { checking, loading, selecting, downloading, ready, error }

class ProfessionalState extends Equatable {
  final List<ProfessionalBusiness> business;
  final ProfessionalStatus status;

  ProfessionalState({ this.business, this.status });

  static ProfessionalState get initialState => ProfessionalState(
    business: const [],
    status: ProfessionalStatus.loading
  );

  ProfessionalState copyWith({ 
    List<ProfessionalBusiness> business,
    ProfessionalStatus status
  }) {
    return ProfessionalState(
      business: business ?? this.business,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [business, status];
}
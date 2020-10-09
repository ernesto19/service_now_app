import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class GetProfessionalServicesByProfessional implements UseCase<List<ProfessionalService>, GetProfessionalServicesParams> {
  final ProfessionalRepository repository;

  GetProfessionalServicesByProfessional(this.repository);

  @override
  Future<Either<Failure, List<ProfessionalService>>> call(GetProfessionalServicesParams params) async {
    return await repository.getProfessionalServices(params.professionalBusinessId);
  }
}

class GetProfessionalServicesParams extends Equatable {
  final int professionalBusinessId;

  GetProfessionalServicesParams({ @required this.professionalBusinessId });

  @override
  List<Object> get props => [professionalBusinessId];
}
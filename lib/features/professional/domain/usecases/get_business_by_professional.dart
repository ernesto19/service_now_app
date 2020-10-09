import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class GetProfessionalBusinessByProfessional implements UseCase<List<ProfessionalBusiness>, GetProfessionalBusinessParams> {
  final ProfessionalRepository repository;

  GetProfessionalBusinessByProfessional(this.repository);

  @override
  Future<Either<Failure, List<ProfessionalBusiness>>> call(GetProfessionalBusinessParams params) async {
    return await repository.getProfessionalBusiness(params.professionalId);
  }
}

class GetProfessionalBusinessParams extends Equatable {
  final int professionalId;

  GetProfessionalBusinessParams({ @required this.professionalId });

  @override
  List<Object> get props => [professionalId];
}
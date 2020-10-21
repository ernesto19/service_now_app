import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class UpdateBusinessByProfessional implements UseCase<void, UpdateBusinessParams> {
  final ProfessionalRepository repository;

  UpdateBusinessByProfessional(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBusinessParams params) async {
    return await repository.updateBusinessStatus(params.business);
  }
}

class UpdateBusinessParams extends Equatable {
  final ProfessionalBusiness business;

  UpdateBusinessParams({ @required this.business });

  @override
  List<Object> get props => [business];
}
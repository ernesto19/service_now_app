import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class UpdateServiceByProfessional implements UseCase<RegisterServiceResponse, UpdateServiceParams> {
  final ProfessionalRepository repository;

  UpdateServiceByProfessional(this.repository);

  @override
  Future<Either<Failure, RegisterServiceResponse>> call(UpdateServiceParams params) async {
    return await repository.updateService(params.id, params.price);
  }
}

class UpdateServiceParams extends Equatable {
  final int id;
  final double price;

  UpdateServiceParams({ @required this.id, @required this.price });

  @override
  List<Object> get props => [id, price];
}
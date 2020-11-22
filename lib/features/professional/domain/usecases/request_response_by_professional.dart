import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/data/responses/response_request_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class RequestResponseByProfessional implements UseCase<ResponseRequestResponse, ResponseRequestParams> {
  final ProfessionalRepository repository;

  RequestResponseByProfessional(this.repository);

  @override
  Future<Either<Failure, ResponseRequestResponse>> call(ResponseRequestParams params) async {
    return await repository.responseRequest(params.services, params.userId);
  }
}

class ResponseRequestParams extends Equatable {
  final List<ProfessionalService> services;
  final int userId;

  ResponseRequestParams({ @required this.services, @required this.userId });

  @override
  List<Object> get props => [services, userId];
}
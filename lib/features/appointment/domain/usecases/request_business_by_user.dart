import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class RequestBusinessByUser implements UseCase<RequestBusinessResponse, Params> {
  final AppointmentRepository repository;

  RequestBusinessByUser(this.repository);

  @override
  Future<Either<Failure, RequestBusinessResponse>> call(Params params) async {
    return await repository.requestBusiness(params.businessId);
  }

}

class Params extends Equatable {
  final int businessId;

  Params({ @required this.businessId });

  @override
  List<Object> get props => [businessId];
}
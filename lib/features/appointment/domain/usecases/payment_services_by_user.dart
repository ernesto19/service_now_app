import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/data/responses/payment_services_response.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class PaymentServicesByUser implements UseCase<PaymentServicesResponse, Params> {
  final AppointmentRepository repository;

  PaymentServicesByUser(this.repository);

  @override
  Future<Either<Failure, PaymentServicesResponse>> call(Params params) async {
    return await repository.paymentServices(params.userId, params.services);
  }

}

class Params extends Equatable {
  final int userId;
  final List<Service> services;

  Params({ @required this.userId, @required this.services });

  @override
  List<Object> get props => [userId, services];
}
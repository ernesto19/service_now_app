import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class GetBusinessByCategory implements UseCase<List<Business>, GetBusinessParams> {
  final AppointmentRepository repository;

  GetBusinessByCategory(this.repository);

  @override
  Future<Either<Failure, List<Business>>> call(GetBusinessParams params) async {
    return await repository.getBusiness(params.categoryId, params.latitude, params.longitude);
  }
}

class GetBusinessParams extends Equatable {
  final int categoryId;
  final String latitude;
  final String longitude;

  GetBusinessParams({ @required this.categoryId, @required this.latitude, @required this.longitude });

  @override
  List<Object> get props => [categoryId, latitude, longitude];
}
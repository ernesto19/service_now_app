import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<Business>>> getBusiness(int categoryId, String latitude, String longitude);
}
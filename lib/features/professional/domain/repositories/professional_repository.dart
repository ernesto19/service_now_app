import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

abstract class ProfessionalRepository {
  Future<Either<Failure, List<ProfessionalBusiness>>> getProfessionalBusiness(int professionalId);
  Future<Either<Failure, List<ProfessionalService>>> getProfessionalServices(int professionalBusinessId);
}
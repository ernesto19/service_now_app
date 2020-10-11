import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

abstract class ProfessionalRepository {
  Future<Either<Failure, List<ProfessionalBusiness>>> getProfessionalBusiness(int professionalId);
  Future<Either<Failure, List<ProfessionalService>>> getProfessionalServices(int professionalBusinessId);
  Future<Either<Failure, IndustryCategory>> getIndustries();
  Future<Either<Failure, RegisterBusinessResponse>> registerBusiness(String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage);
}
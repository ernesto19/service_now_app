import 'package:dartz/dartz.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/data/responses/response_request_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';

abstract class ProfessionalRepository {
  Future<Either<Failure, List<ProfessionalBusiness>>> getProfessionalBusiness();
  Future<Either<Failure, List<ProfessionalService>>> getProfessionalServices(int professionalBusinessId);
  Future<Either<Failure, IndustryCategory>> getIndustries();
  Future<Either<Failure, RegisterBusinessResponse>> registerBusiness(String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage, String phone, List<Asset> images);
  Future<Either<Failure, RegisterBusinessResponse>> updateBusiness(int businessId, String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage, String phone);
  Future<Either<Failure, CreateServiceForm>> getCreateServiceForm();
  Future<Either<Failure, RegisterServiceResponse>> registerService(int businessId, int serviceId, double price, List<Asset> images);
  Future<Either<Failure, RegisterServiceResponse>> updateService(int id, double price);
  Future<Either<Failure, void>> updateBusinessStatus(ProfessionalBusiness business);
  Future<Either<Failure, ResponseRequestResponse>> responseRequest(List<ProfessionalService> services, int userId);
  Future<Either<Failure, DeleteImageResponse>> deleteImage(int id);
}
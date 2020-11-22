import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/professional/data/datasources/professional_remote_data_source.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';
import 'package:service_now/features/professional/data/requests/register_business_request.dart';
import 'package:service_now/features/professional/data/requests/register_service_request.dart';
import 'package:service_now/features/professional/data/requests/response_request_request.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/data/responses/response_request_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

typedef Future<List<ProfessionalBusiness>> _ProfessionalBusinessType();
typedef Future<List<ProfessionalService>> _ProfessionalServicesType();
typedef Future<IndustryCategory> _IndustriesType();
typedef Future<RegisterBusinessResponse> _RegisterBusinessType();
typedef Future<CreateServiceForm> _CreateServiceFormType();
typedef Future<RegisterServiceResponse> _RegisterServiceType();
typedef Future<ResponseRequestResponse> _ResponseRequestType();
typedef Future<DeleteImageResponse> _DeleteImageType();

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfessionalRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<ProfessionalBusiness>>> getProfessionalBusiness() async {
    return await _getProfessionalBusinessType(() {
      return remoteDataSource.getProfessionalBusiness();
    });
  }

  @override
  Future<Either<Failure, List<ProfessionalService>>> getProfessionalServices(int professionalBusinessId) async {
    return await _getProfessionalServicesType(() {
      var request = GetProfessionalServicesRequest(professionalBusinessId: professionalBusinessId);
      return remoteDataSource.getProfessionalServices(request);
    });
  }

  @override
  Future<Either<Failure, IndustryCategory>> getIndustries() async {
    return await _getIndustriesType(() {
      return remoteDataSource.getIndustries();
    });
  }

  @override
  Future<Either<Failure, RegisterBusinessResponse>> registerBusiness(String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage, List<Asset> images) async {
    return await _registerBusinessType(() {
      var request = RegisterBusinessRequest(name: name, description: description, industryId: industryId, categoryId: categoryId, licenseNumber: licenseNumber, jobOffer: jobOffer, latitude: latitude, longitude: longitude, address: address, fanpage: fanpage, images: images);
      return remoteDataSource.registerBusiness(request);
    });
  }

  @override
  Future<Either<Failure, RegisterBusinessResponse>> updateBusiness(int businessId, String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage) async {
    return await _updateBusinessType(() {
      var request = RegisterBusinessRequest(businessId: businessId, name: name, description: description, industryId: industryId, categoryId: categoryId, licenseNumber: licenseNumber, jobOffer: jobOffer, latitude: latitude, longitude: longitude, address: address, fanpage: fanpage);
      return remoteDataSource.updateBusiness(request);
    });
  }

  @override
  Future<Either<Failure, CreateServiceForm>> getCreateServiceForm() async {
    return await _getCreateServiceFormType(() {
      return remoteDataSource.getCreateServiceForm();
    });
  }

  @override
  Future<Either<Failure, RegisterServiceResponse>> registerService(int businessId, int serviceId, double price, List<Asset> images) async {
    return await _registerServiceType(() {
      var request = RegisterServiceRequest(businessId: businessId, serviceId: serviceId, price: price, images: images);
      return remoteDataSource.registerService(request);
    });
  }

  @override
  Future<Either<Failure, RegisterServiceResponse>> updateService(int id, double price) async {
    return await _updateServiceType(() {
      var request = RegisterServiceRequest(professionalServiceId: id, price: price);
      return remoteDataSource.updateService(request);
    });
  }

  @override
  Future<Either<Failure, void>> updateBusinessStatus(ProfessionalBusiness business) async {
    try {
      var update = await remoteDataSource.updateBusinessStatus(business);
      return Right(update);
    } on LocalException {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, DeleteImageResponse>> deleteImage(int id) async {
    return await _deleteImageType(() {
      return remoteDataSource.deleteImage(id);
    });
  }

  Future<Either<Failure, List<ProfessionalBusiness>>> _getProfessionalBusinessType(_ProfessionalBusinessType getProfessionalBusinessType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBusiness = await getProfessionalBusinessType();
        return Right(remoteBusiness);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<ProfessionalService>>> _getProfessionalServicesType(_ProfessionalServicesType getProfessionalServicesType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBusiness = await getProfessionalServicesType();
        return Right(remoteBusiness);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, IndustryCategory>> _getIndustriesType(_IndustriesType getIndustriesType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteIndustries = await getIndustriesType();
        return Right(remoteIndustries);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RegisterBusinessResponse>> _registerBusinessType(_RegisterBusinessType registerBusinessType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await registerBusinessType();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RegisterBusinessResponse>> _updateBusinessType(_RegisterBusinessType updateBusinessType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await updateBusinessType();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, CreateServiceForm>> _getCreateServiceFormType(_CreateServiceFormType getCreateServiceFormType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCreateForm = await getCreateServiceFormType();
        return Right(remoteCreateForm);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RegisterServiceResponse>> _registerServiceType(_RegisterServiceType registerServiceType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await registerServiceType();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RegisterServiceResponse>> _updateServiceType(_RegisterServiceType updateServiceType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await updateServiceType();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ResponseRequestResponse>> responseRequest(List<ProfessionalService> services, int userId) async {
    return await _responseRequestType(() {
      var request = ResponseRequestRequest(services: services, userId: userId);
      return remoteDataSource.responseRequest(request);
    });
  }

  Future<Either<Failure, ResponseRequestResponse>> _responseRequestType(_ResponseRequestType responseRequestType) async {
    if (await networkInfo.isConnected) {
      try {
        final requestBusiness = await responseRequestType();
        return Right(requestBusiness);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, DeleteImageResponse>> _deleteImageType(_DeleteImageType deleteImageType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await deleteImageType();
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
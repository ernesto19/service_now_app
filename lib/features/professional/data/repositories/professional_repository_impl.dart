import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/professional/data/datasources/professional_remote_data_source.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';
import 'package:service_now/features/professional/data/requests/register_business_request.dart';
import 'package:service_now/features/professional/data/requests/register_service_request.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

typedef Future<List<ProfessionalBusiness>> _ProfessionalBusinessType();
typedef Future<List<ProfessionalService>> _ProfessionalServicesType();
typedef Future<IndustryCategory> _IndustriesType();
typedef Future<RegisterBusinessResponse> _RegisterBusinessType();
typedef Future<CreateServiceForm> _CreateServiceFormType();
typedef Future<RegisterServiceResponse> _RegisterServiceType();

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
  Future<Either<Failure, RegisterBusinessResponse>> registerBusiness(String name, String description, int industryId, int categoryId, String licenseNumber, String jobOffer, String latitude, String longitude, String address, String fanpage) async {
    return await _registerBusinessType(() {
      var request = RegisterBusinessRequest(name: name, description: description, industryId: industryId, categoryId: categoryId, licenseNumber: licenseNumber, jobOffer: jobOffer, latitude: latitude, longitude: longitude, address: address, fanpage: fanpage);
      return remoteDataSource.registerBusiness(request);
    });
  }

  @override
  Future<Either<Failure, CreateServiceForm>> getCreateServiceForm() async {
    return await _getCreateServiceFormType(() {
      return remoteDataSource.getCreateServiceForm();
    });
  }

  @override
  Future<Either<Failure, RegisterServiceResponse>> registerService(int businessId, int serviceId, double price) async {
    return await _registerServiceType(() {
      var request = RegisterServiceRequest(businessId: businessId, serviceId: serviceId, price: price);
      return remoteDataSource.registerService(request);
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
}
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/professional/data/datasources/professional_remote_data_source.dart';
import 'package:service_now/features/professional/data/requests/get_professional_business_request.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/domain/entities/industry.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

typedef Future<List<ProfessionalBusiness>> _ProfessionalBusinessType();
typedef Future<List<ProfessionalService>> _ProfessionalServicesType();
typedef Future<IndustryCategory> _IndustriesType();

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfessionalRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<ProfessionalBusiness>>> getProfessionalBusiness(int professionalId) async {
    return await _getProfessionalBusinessType(() {
      var request = GetProfessionalBusinessRequest(professionalId: professionalId);
      return remoteDataSource.getProfessionalBusiness(request);
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
}
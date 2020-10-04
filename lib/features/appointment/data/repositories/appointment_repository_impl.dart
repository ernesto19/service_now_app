import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:service_now/features/appointment/data/requests/get_business_request.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:meta/meta.dart';

typedef Future<List<Business>> _BusinessType();

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<Business>>> getBusiness(int categoryId, String latitude, String longitude) async {
    return await _getBusinessType(() {
      var request = GetBusinessRequest(categoryId: categoryId, latitude: latitude, longitude: longitude);
      return remoteDataSource.getBusiness(request);
    });
  }

  Future<Either<Failure, List<Business>>> _getBusinessType(_BusinessType getBusinessType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBusiness = await getBusinessType();
        return Right(remoteBusiness);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
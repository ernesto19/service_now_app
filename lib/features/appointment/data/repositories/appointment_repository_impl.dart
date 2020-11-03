import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:service_now/features/appointment/data/requests/get_business_request.dart';
import 'package:service_now/features/appointment/data/requests/get_comments_request.dart';
import 'package:service_now/features/appointment/data/requests/get_galleries_request.dart';
import 'package:service_now/features/appointment/data/requests/request_business_request.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:meta/meta.dart';

typedef Future<List<Business>> _BusinessType();
typedef Future<List<Comment>> _CommentsType();
typedef Future<List<Gallery>> _GalleriesType();
typedef Future<RequestBusinessResponse> _RequestBusinessType();

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

  @override
  Future<Either<Failure, List<Comment>>> getComments(int businessId) async {
    return await _getCommentsType(() {
      var request = GetCommentsRequest(businessId: businessId);
      return remoteDataSource.getComments(request);
    });
  }

  @override
  Future<Either<Failure, List<Gallery>>> getGalleries(int businessId) async {
    return await _getGalleriesType(() {
      var request = GetGalleriesRequest(businessId: businessId);
      return remoteDataSource.getGalleries(request);
    });
  }

  @override
  Future<Either<Failure, RequestBusinessResponse>> requestBusiness(int businessId) async {
    return await _requestBusinessType(() {
      var request = RequestBusinessRequest(businessId: businessId);
      return remoteDataSource.requestBusiness(request);
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

  Future<Either<Failure, List<Comment>>> _getCommentsType(_CommentsType getCommentsType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComments = await getCommentsType();
        return Right(remoteComments);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<Gallery>>> _getGalleriesType(_GalleriesType getGalleriesType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGalleries = await getGalleriesType();
        return Right(remoteGalleries);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RequestBusinessResponse>> _requestBusinessType(_RequestBusinessType requestBusinessType) async {
    if (await networkInfo.isConnected) {
      try {
        final requestBusiness = await requestBusinessType();
        return Right(requestBusiness);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
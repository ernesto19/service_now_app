import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/home/data/datasources/home_local_data_source.dart';
import 'package:service_now/features/home/data/datasources/home_remote_data_source.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';
import 'package:service_now/features/home/domain/entities/message.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/preferences/user_preferences.dart';

typedef Future<List<Category>> _CategoriesType();
typedef Future<LoginResponse> _AcquireMembershipType();
typedef Future<List<Message>> _MessagesType();
typedef Future<Membership> _MembershipType();

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    return await _getCategoriesType(() {
      return remoteDataSource.getCategories();
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> acquireMembership() async {
    return await _acquireMembershipType(() {
      return remoteDataSource.acquireMembership();
    });
  }

  @override
  Future<Either<Failure, void>> updateLocalCategory(Category category) async {
    try {
      var create = await localDataSource.createCategory(category);
      return Right(create);
    } on LocalException {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getPermissions() async {
    try {
      var permissions = await localDataSource.getAllPermissions();
      return Right(permissions);
    } on LocalException {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, int>> logOut() async {
    try {
      await localDataSource.deletePermissions();
      return Right(1);
    } on LocalException {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages() async {
    return await _getMessagesType(() {
      return remoteDataSource.getMessages();
    });
  }

  @override
  Future<Either<Failure, Membership>> getMembership() async {
    return await _getMembershipType(() {
      return remoteDataSource.getMembership();
    });
  }

  Future<Either<Failure, List<Category>>> _getCategoriesType(_CategoriesType getCategoriesType) async {
    if (await networkInfo.isConnected) {
      try {
        if (UserPreferences.instance.firstUseApp == 1) {
          final remoteCategories = await getCategoriesType();
          localDataSource.createCategories(remoteCategories);
          UserPreferences.instance.firstUseApp++;
        }
        
        final localCategories = await localDataSource.getAllCategories();
        return Right(localCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCategories = await localDataSource.getAllCategories();
        return Right(localCategories);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  Future<Either<Failure, LoginResponse>> _acquireMembershipType(_AcquireMembershipType _acquireMembershipType) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await _acquireMembershipType();
        if (response.data != null) {
          if (response.data.rol != null) {
            UserPreferences.instance.rol = response.data.rol.id;

            if (response.data.rol.permissions != null) {
              localDataSource.createPermissions(response.data.rol.permissions);
            }
          }
        }

        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<Message>>> _getMessagesType(_MessagesType getMessagesType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMessages = await getMessagesType();
        return Right(remoteMessages);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, Membership>> _getMembershipType(_MembershipType getMembershipType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMembership = await getMembershipType();
        return Right(remoteMembership);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
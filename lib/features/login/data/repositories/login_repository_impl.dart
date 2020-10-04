import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/login/data/datasources/login_remote_data_source.dart';
import 'package:service_now/features/login/data/requests/login_request.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';
import 'package:meta/meta.dart';

typedef Future<User> _LoginType();

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    return await _loginType(() {
      var request = LoginRequest(email: email, password: password);
      return remoteDataSource.login(request);
    });
  }

  Future<Either<Failure, User>> _loginType(_LoginType loginType) async {
    if (await networkInfo.isConnected) {
      try {
        final login = await loginType();
        return Right(login);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
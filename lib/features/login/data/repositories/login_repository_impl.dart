import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/home/data/datasources/home_local_data_source.dart';
import 'package:service_now/features/login/data/datasources/login_remote_data_source.dart';
import 'package:service_now/features/login/data/requests/login_request.dart';
import 'package:service_now/features/login/data/requests/sign_up_request.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/data/responses/sign_up_response.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:service_now/preferences/user_preferences.dart';

typedef Future<LoginResponse> _LoginType();
typedef Future<SignUpResponse> _SignUpType();

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.localDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, LoginResponse>> logIn(String email, String password) async {
    return await _loginType(() {
      var request = LoginRequest(email: email, password: password);
      return remoteDataSource.logIn(request);
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> logInByFacebook(String token) async {
    return await _loginType(() {
      return remoteDataSource.logInByFacebook(token);
    });
  }

  @override
  Future<Either<Failure, SignUpResponse>> signUp(String firstName, String lastName, String email, String password, String confirmPassword) async {
    return await _signUpType(() {
      var request = SignUpRequest(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword);
      return remoteDataSource.signUp(request);
    });
  }

  Future<Either<Failure, LoginResponse>> _loginType(_LoginType loginType) async {
    if (await networkInfo.isConnected) {
      try {
        final login = await loginType();
        if (login.data != null) {
          if (login.data.rol != null) {
            UserPreferences.instance.rol = login.data.rol.id;

            if (login.data.rol.permissions != null) {
              localDataSource.createPermissions(login.data.rol.permissions);
            }
          }
        }

        return Right(login);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, SignUpResponse>> _signUpType(_SignUpType signinType) async {
    if (await networkInfo.isConnected) {
      try {
        final login = await signinType();
        return Right(login);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
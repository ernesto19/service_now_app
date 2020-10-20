import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';

class AuthenticationByFacebook implements UseCase<LoginResponse, LoginFBParams> {
  final LoginRepository repository;

  AuthenticationByFacebook(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginFBParams params) async {
    return await repository.logInByFacebook(params.token);
  }
}

class LoginFBParams extends Equatable {
  final String token;

  LoginFBParams({ @required this.token });

  @override
  List<Object> get props => [token];
}
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';

class Registration implements UseCase<User, RegistrationParams> {
  final LoginRepository repository;

  Registration(this.repository);

  @override
  Future<Either<Failure, User>> call(RegistrationParams params) async {
    return await repository.signin(params.firstName, params.lastName, params.email, params.password, params.confirmPassword);
  }
}

class RegistrationParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  RegistrationParams({ @required this.firstName, @required this.lastName, @required this.email, @required this.password, @required this.confirmPassword });

  @override
  List<Object> get props => [email, password];
}
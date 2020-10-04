import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';

class Authentication implements UseCase<User, Params> {
  final LoginRepository repository;

  Authentication(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.login(params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params({ @required this.email, @required this.password });

  @override
  List<Object> get props => [email, password];
}
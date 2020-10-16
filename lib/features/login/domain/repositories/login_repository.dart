import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signin(String firstName, String lastName, String email, String password, String confirmPassword);
}
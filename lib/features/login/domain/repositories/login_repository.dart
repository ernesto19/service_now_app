import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/login/data/responses/sign_up_response.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponse>> logIn(String email, String password);
  Future<Either<Failure, LoginResponse>> logInByFacebook(String token);
  Future<Either<Failure, SignUpResponse>> signUp(String firstName, String lastName, String email, String password, String confirmPassword);
}
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, void>> updateLocalCategory(Category category);
  Future<Either<Failure, LoginResponse>> acquireMembership();
  Future<Either<Failure, List<Permission>>> getPermissions();
}
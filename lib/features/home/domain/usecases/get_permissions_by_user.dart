import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

class GetPermissionsByUser implements UseCase<List<Permission>, NoParams> {
  final HomeRepository repository;

  GetPermissionsByUser(this.repository);

  @override
  Future<Either<Failure, List<Permission>>> call(NoParams params) async {
    return await repository.getPermissions();
  }
}
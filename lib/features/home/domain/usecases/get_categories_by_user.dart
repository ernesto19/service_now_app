import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';

class GetCategoriesByUser implements UseCase<List<Category>, NoParams> {
  final HomeRepository repository;

  GetCategoriesByUser(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
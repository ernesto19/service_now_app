import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/repositories/category_repository.dart';

// class GetCategoriesByUser implements UseCase<List<Category>, Params> {
class GetCategoriesByUser implements UseCase<List<CategoryModel>, Params> {
  final CategoryRepository repository;

  GetCategoriesByUser(this.repository);

  @override
  // Future<Either<Failure, List<Category>>> call(Params params) async {
  Future<Either<Failure, List<CategoryModel>>> call(Params params) async {
    return await repository.getCategories(params.token);
  }
}

class Params extends Equatable {
  final String token;

  Params({ @required this.token });

  @override
  List<Object> get props => [token];
}
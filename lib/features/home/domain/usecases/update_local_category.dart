import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/repositories/category_repository.dart';

class UpdateLocalCategory implements UseCase<void, UpdateParams> {
  final CategoryRepository repository;

  UpdateLocalCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateParams params) async {
    return await repository.updateLocalCategory(params.category);
  }
}

class UpdateParams extends Equatable {
  final Category category;

  UpdateParams({ @required this.category });

  @override
  List<Object> get props => [category];
}
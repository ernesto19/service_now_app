import 'package:service_now/core/network/network_info.dart';
import 'package:service_now/features/home/data/datasources/category_local_data_source.dart';
import 'package:service_now/features/home/data/datasources/category_remote_data_source.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/home/domain/repositories/category_repository.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';

// typedef Future<List<Category>> _CategoriesType();
typedef Future<List<CategoryModel>> _CategoriesType();

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.localDataSource
  });

  @override
  // Future<Either<Failure, List<Category>>> getCategories(String token) async {
  Future<Either<Failure, List<CategoryModel>>> getCategories(String token) async {
    return await _getCategoriesType(() {
      return remoteDataSource.getCategories(token);
    });
  }

  // Future<Either<Failure, List<Category>>> _getCategoriesType(_CategoriesType getCategoriesType) async {
  Future<Either<Failure, List<CategoryModel>>> _getCategoriesType(_CategoriesType getCategoriesType) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await getCategoriesType();
        // localDataSource.cacheCategories(remoteCategories);
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCategories = await localDataSource.getAllCategories();
        return Right(localCategories);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
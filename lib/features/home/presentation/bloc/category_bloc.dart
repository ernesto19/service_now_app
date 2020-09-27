import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/domain/usecases/get_categories_by_user.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesByUser getCategoriesByUser;

  CategoryBloc({
    @required GetCategoriesByUser categories
  }) : assert(categories != null),
       getCategoriesByUser = categories{
       add(GetCategoriesForUser('adasd'));
  }

  @override
  CategoryState get initialState => CategoryState.inititalState;

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is GetCategoriesForUser) {
      final failureOrCategories = await getCategoriesByUser(Params(token: event.token));

      yield* _eitherLoadedOrErrorState(failureOrCategories);
    } else if (event is OnFavoritesEvent) {
      yield* this._mapOnFavorites(event);
    }
  }

  Stream<CategoryState> _mapOnFavorites(OnFavoritesEvent event) async* {
    final int id = event.id;
    final List<Category> tmp = List<Category>.from(this.state.categories);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onFavorites();
      yield this.state.copyWith(status: CategoryStatus.ready, categories: tmp);
    }
  }

  Stream<CategoryState> _eitherLoadedOrErrorState(
    Either<Failure, List<Category>> failureOrCategories
  ) async * {
    yield failureOrCategories.fold(
      (failure) {
        return this.state.copyWith(status: CategoryStatus.error, categories: []);
      },
      (categories) {
        return this.state.copyWith(status: CategoryStatus.ready, categories: categories);
      }
    );
  }

  static CategoryBloc of(BuildContext context) {
    return BlocProvider.of<CategoryBloc>(context);
  }
}
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/category.dart';
import 'package:service_now/features/home/domain/usecases/get_categories_by_user.dart';
import 'package:service_now/features/home/domain/usecases/update_local_category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCategoriesByUser getCategoriesByUser;
  final UpdateLocalCategory updateLocalCategory;

  HomeBloc({
    @required GetCategoriesByUser categories,
    @required UpdateLocalCategory updateCategory,
  }) : assert(categories != null),
       getCategoriesByUser = categories,
       updateLocalCategory = updateCategory {
       add(GetCategoriesForUser());
  }

  @override
  HomeState get initialState => HomeState.inititalState;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetCategoriesForUser) {
      final failureOrCategories = await getCategoriesByUser(NoParams());

      yield* _eitherLoadedOrErrorState(failureOrCategories);
    } else if (event is OnFavoritesEvent) {
      yield* this._mapOnFavorites(event);
    }
  }

  Stream<HomeState> _mapOnFavorites(OnFavoritesEvent event) async* {
    final int id = event.id;
    final List<Category> tmp = List<Category>.from(this.state.categories);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onFavorites();
      updateLocalCategory(UpdateParams(category: tmp[index]));
      yield this.state.copyWith(status: HomeStatus.ready, categories: tmp);
    }
  }

  Stream<HomeState> _eitherLoadedOrErrorState(
    Either<Failure, List<Category>> failureOrCategories
  ) async * {
    yield failureOrCategories.fold(
      (failure) {
        return this.state.copyWith(status: HomeStatus.error, categories: []);
      },
      (categories) {
        return this.state.copyWith(status: HomeStatus.ready, categories: categories);
      }
    );
  }

  static HomeBloc of(BuildContext context) {
    return BlocProvider.of<HomeBloc>(context);
  }
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:service_now/features/home/domain/entities/category.dart';

enum CategoryStatus { checking, loading, selecting, downloading, ready, error }

class CategoryState extends Equatable {
  // final List<Category> categories;
  final List<CategoryModel> categories;
  final CategoryStatus status;

  CategoryState({ @required this.categories, @required this.status });

  static CategoryState get inititalState => CategoryState(
    status: CategoryStatus.checking,
    categories: const []
  );

  CategoryState copyWith({
    // List<Category> categories,
    List<CategoryModel> categories,
    CategoryStatus status,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [categories, status];

}
// @immutable
// abstract class CategoryState extends Equatable {
//   final List<Category> categories;

//   CategoryState(this.categories);

//   @override
//   List<Object> get props => [categories];
// }

// class Empty extends CategoryState {
//   Empty(List<Category> categories) : super(categories);
// }

// class Loading extends CategoryState {
//   Loading(List<Category> categories) : super(categories);
// }

// class Loaded extends CategoryState {
//   // Loaded(List<Category> categories) : super(categories);

//   final List<Category> categories;

//   Loaded({ @required this.categories }) : super(null);

//   @override
//   List<Object> get props => [categories];
// }

// class Error extends CategoryState {
//   final String message;

//   Error({ @required this.message }) : super(null);

//   @override
//   List<Object> get props => [message];
// }
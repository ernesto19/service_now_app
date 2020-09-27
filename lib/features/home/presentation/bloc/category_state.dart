import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/entities/category.dart';

enum CategoryStatus { checking, loading, selecting, downloading, ready, error }

class CategoryState extends Equatable {
  final List<Category> categories;
  final CategoryStatus status;

  CategoryState({ @required this.categories, @required this.status });

  static CategoryState get inititalState => CategoryState(
    status: CategoryStatus.checking,
    categories: const []
  );

  CategoryState copyWith({
    List<Category> categories,
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
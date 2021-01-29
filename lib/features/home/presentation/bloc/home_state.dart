import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/entities/category.dart';

enum HomeStatus { checking, loading, selecting, downloading, ready, error, unauthenticated }

class HomeState extends Equatable {
  final List<Category> categories;
  final HomeStatus status;

  HomeState({ @required this.categories, @required this.status });

  static HomeState get inititalState => HomeState(
    status: HomeStatus.checking,
    categories: const []
  );

  HomeState copyWith({
    List<Category> categories,
    HomeStatus status,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [categories, status];

}
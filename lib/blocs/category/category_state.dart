import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/models/category.dart';

enum CategoryStatus {
  checking,
  loading,
  selecting,
  downloading,
  ready,
  error
}

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<Category> services;

  CategoryState({ @required this.status, @required this.services });

  static CategoryState get initialState => CategoryState(
    status: CategoryStatus.checking,
    services: const []
  );

  copyWith({ CategoryStatus status, List<Category> services }) {
    return CategoryState(
      status: status ?? this.status,
      services: services ?? this.services
    );
  }

  @override
  List<Object> get props => [
    status
  ];
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// @immutable
abstract class CategoryEvent {
  // @override
  // List<Object> get props => [];
}

class GetCategoriesForUser extends CategoryEvent {
  final String token;

  GetCategoriesForUser(this.token);

  // @override
  // List<Object> get props => [token];
}

class OnFavoritesEvent extends CategoryEvent {
  final int id;

  OnFavoritesEvent(this.id);

  // @override
  // List<Object> get props => [id];
}
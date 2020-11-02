abstract class HomeEvent {}

class GetCategoriesForUser extends HomeEvent {
  GetCategoriesForUser();
}

class OnFavoritesEvent extends HomeEvent {
  final int id;

  OnFavoritesEvent(this.id);
}
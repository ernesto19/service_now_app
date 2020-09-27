abstract class CategoryEvent {}

class GetCategoriesForUser extends CategoryEvent {
  final String token;

  GetCategoriesForUser(this.token);
}

class OnFavoritesEvent extends CategoryEvent {
  final int id;

  OnFavoritesEvent(this.id);
}
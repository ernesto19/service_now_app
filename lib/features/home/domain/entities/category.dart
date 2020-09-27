import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String logo;
  final int favorite;

  Category({
    @required this.id,
    @required this.name,
    @required this.logo,
    @required this.favorite
  });

  Category onFavorites() {
    return Category(
      id: this.id, 
      name: this.name, 
      logo: this.logo, 
      favorite: this.favorite == 1 ? 0 : 1
    );
  }

  @override
  List<Object> get props => [id, name, logo, favorite];
}
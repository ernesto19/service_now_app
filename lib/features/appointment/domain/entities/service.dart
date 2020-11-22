// import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Service/* extends Equatable*/ {
  final int id;
  final String name;
  final String price;
  final List<String> photos;
  int selected;

  Service({
    @required this.id, 
    @required this.name,
    @required this.price,
    @required this.photos,
    @required this.selected
  });

  Service onSelected() {
    return Service(
      id: this.id, 
      name: this.name,
      price: this.price,
      photos: [],
      selected: this.selected == 1 ? 0 : 1
    );
  }

  /*@override
  List<Object> get props => [id, name, price, photos, selected];*/
}
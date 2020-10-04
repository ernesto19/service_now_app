import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  User({
    @required this.id, 
    @required this.firstName, 
    @required this.lastName, 
    @required this.email, 
    @required this.token
  });

  @override
  List<Object> get props => [id, firstName, lastName, email, token];
}
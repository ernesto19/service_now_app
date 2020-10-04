import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:meta/meta.dart';

class UserModel extends User {
  UserModel({
    @required int id,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String token,
  }) : super(id: id, firstName: firstName, lastName: lastName, email: email, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:         json['id'], 
      firstName:  json['first_name'], 
      lastName:   json['last_name'],
      email:      json['email'],
      token:      json['token']
    );
  }

  String toString() {
    return '\n$id\n$firstName\n$lastName\n';
  }
}
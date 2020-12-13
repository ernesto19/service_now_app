import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;
  final int profileId;
  final Rol rol;

  User({
    @required this.id, 
    @required this.firstName, 
    @required this.lastName, 
    @required this.email, 
    @required this.token,
    @required this.profileId,
    @required this.rol
  });

  @override
  List<Object> get props => [id, firstName, lastName, email, token, profileId, rol];
}

class Rol extends Equatable {
  final int id;
  final String name;
  final List<Permission> permissions;

  Rol({
    @required this.id, 
    @required this.name,
    @required this.permissions
  });
  
  @override
  List<Object> get props => [id, name, permissions];
}

class Permission extends Equatable {
  final int id;
  final String name;
  final String icon;
  final String translateName;

  Permission({
    @required this.id, 
    @required this.name,
    @required this.icon,
    @required this.translateName
  });
  
  @override
  List<Object> get props => [id, name, icon, translateName];
}
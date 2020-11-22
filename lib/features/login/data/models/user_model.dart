import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:meta/meta.dart';

class UserModel extends User {
  UserModel({
    @required int id,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String token,
    @required RolModel rol
  }) : super(id: id, firstName: firstName, lastName: lastName, email: email, token: token, rol: rol);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:         json['id']          ?? '', 
      firstName:  json['first_name']  ?? '', 
      lastName:   json['last_name']   ?? '',
      email:      json['email']       ?? '',
      token:      json['token']       ?? '',
      rol:        json['roles'] == null ? null : RolModel.fromJson(json['roles'][0])
    );
  }
}

class RolModel extends Rol {
  RolModel({
    @required int id,
    @required String name,
    @required List<PermissionModel> permissions
  }) : super(id: id, name: name, permissions: permissions);

  factory RolModel.fromJson(Map<String, dynamic> json) {
    return RolModel(
      id:   json['id']    ?? '', 
      name: json['name']  ?? '',
      permissions: ListPermissions.fromJson(json).permissions
    );
  }
}

class PermissionModel extends Permission {
  PermissionModel({
    @required int id,
    @required String name,
    @required String icon,
    @required String translateName
  }) : super(id: id, name: name, icon: icon, translateName: translateName);

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id:   json['id']    ?? '', 
      name: json['name']  ?? '',
      icon: json['icon']  ?? '',
      translateName: json['translate_name']  ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'translate_name': translateName
    };
  }
}

class ListPermissions {
  List<PermissionModel> permissions = List();

  ListPermissions.fromJson(dynamic json) {
    for (var item in json['permissions']) {
      final permission = PermissionModel.fromJson(item);
      permissions.add(permission);
    }
  }
}
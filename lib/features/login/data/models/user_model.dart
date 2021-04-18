import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:meta/meta.dart';

class UserModel extends User {
  UserModel({
    @required int id,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String token,
    @required int profileId,
    @required List<PermissionModel> permissions,
    @required RolModel rol
  }) : super(id: id, firstName: firstName, lastName: lastName, email: email, token: token, profileId: profileId, rol: rol, permissions: permissions);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:         json['id']          ?? '', 
      firstName:  json['first_name']  ?? '', 
      lastName:   json['last_name']   ?? '',
      email:      json['email']       ?? '',
      token:      json['token']       ?? '',
      profileId:  json['profile_id']  ?? 0,
      rol:        json['roles'] == null ? null : RolModel.fromJson(json['roles'][0]),
      permissions: json['user_permissions'] == null ? null : ListPermissions.fromJson(json).permissions
    );
  }
}

class RolModel extends Rol {
  RolModel({
    @required int id,
    @required String name,
    // @required List<PermissionModel> permissions
  }) : super(id: id, name: name/*, permissions: permissions*/);

  factory RolModel.fromJson(Map<String, dynamic> json) {
    return RolModel(
      id:   json['id']    ?? '', 
      name: json['name']  ?? '',
      // permissions: ListPermissions.fromJson(json).permissions
    );
  }
}

class PermissionModel extends Permission {
  PermissionModel({
    @required int id,
    @required String name,
    @required String icon,
    @required String translateName,
    @required int order
  }) : super(id: id, name: name, icon: icon, translateName: translateName, order: order);

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id:   json['id']    ?? '', 
      name: json['name']  ?? '',
      icon: json['icon']  ?? '',
      translateName: json['translate_name']  ?? '',
      order: json['order'] == null ? 0 : json['order'] is int ? json['order'] : int.parse(json['order'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'translate_name': translateName,
      'order': order
    };
  }
}

class ListPermissions {
  List<PermissionModel> permissions = List();

  ListPermissions.fromJson(dynamic json) {
    for (var item in json['user_permissions']) {
      final permission = PermissionModel.fromJson(item);
      permissions.add(permission);
    }
  }
}
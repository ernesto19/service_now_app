import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  // final PermissionHandler _permissionHandler = PermissionHandler();

  // Future<bool> hasStoragePermission() async {
  //   return hasPermission(PermissionGroup.storage);
  // }

  // Future<bool> hasPermission(PermissionGroup permission) async {
  //   var permissionStatus = await _permissionHandler.checkPermissionStatus(permission);
  //   return permissionStatus == PermissionStatus.granted;
  // }

  // Future<bool> _requestPermission(PermissionGroup permission) async {
  //   var result = await _permissionHandler.requestPermissions([permission]);
  //   if (result[permission] == PermissionStatus.granted) {
  //     return true;
  //   }

  //   return false;
  // }

  // Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
  //   var granted = await _requestPermission(PermissionGroup.storage);
  //   if (!granted) {
  //     onPermissionDenied();
  //   }
  //   return granted;
  // }
}
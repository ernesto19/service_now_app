import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  Future<String> facebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == 200) {
        return result.accessToken.token;
      } else if (result.status == 403) {
        return '403';
      } else {
        return '500';
      }
    } catch(e) {
      return '500';
    }
  }
}
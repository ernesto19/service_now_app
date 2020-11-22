import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  Future<String> facebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == 200) {
        print(result.accessToken.token);
        return result.accessToken.token;
      } else if (result.status == 403) {
        print('======Error 403 -> ${result.toJson().toString()} =======');
        return '403';
      } else {
        print('===== Error 500 ======');
        return '500';
      }
    } catch(e) {
      print('====== ${e.toString()} =======');
      return '500';
    }
  }
}
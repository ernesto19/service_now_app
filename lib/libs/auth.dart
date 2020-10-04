import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> facebook() async {
    // final user = User();
    // try {
    //   final LoginResult result = await FacebookAuth.instance.login();
    //   if (result.status == 200) {
    //     print('Login exitoso');
    //     final userData = await FacebookAuth.instance.getUserData();
    //     print(userData);
        
    //     user.firstName = userData['name'];
    //     // print(user.name);

    //     return user;
    //   } else if (result.status == 403) {
    //     print('Login cancelado por el usuario');
    //   } else {
    //     print('Fallo el login');
    //   }
    // } catch(e) {
    //   print(e);
    // }
  }

  Future<User> google() async {
    // final user = User();
    // try {
    //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    //   final GoogleSignInAuthentication authentication = await googleUser.authentication;

    //   final AuthCredential credential = GoogleAuthProvider.getCredential(
    //     idToken: authentication.idToken, 
    //     accessToken: authentication.accessToken
    //   );
      
    //   user.firstName = googleUser.displayName;
    //   user.email = googleUser.email;

    //   return user;
    // } catch (e) {
    //   print(e);
    // }
  }
}
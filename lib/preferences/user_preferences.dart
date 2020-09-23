
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  UserPreferences._internal();

  static UserPreferences instance = UserPreferences._internal();

  // factory UserPreferences() {
  //   return _instancia;
  // }

  SharedPreferences _preferences;

  initPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  get language {
    return _preferences.getString('language' ?? '');
  }

  set language(String value) {
    _preferences.setString('language', value);
  }

  get userId {
    return _preferences.getInt('userId' ?? '');
  }

  set userId(int value) {
    _preferences.setInt('userId', value);
  }
  
  get token {
    return _preferences.getString('token' ?? '');
  }

  set token(String value) {
    _preferences.setString('token', value);
  }

  get firstName {
    return _preferences.getString('firstName' ?? '');
  }

  set firstName(String value) {
    _preferences.setString('firstName', value);
  }

  get lastName {
    return _preferences.getString('lastName' ?? '');
  }

  set lastName(String value) {
    _preferences.setString('lastName', value);
  }

  get email {
    return _preferences.getString('email' ?? '');
  }

  set email(String value) {
    _preferences.setString('email', value);
  }
}
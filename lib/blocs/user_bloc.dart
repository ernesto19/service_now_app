import 'package:service_now/models/user.dart';
import 'package:service_now/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class UserBloc {
  final _repository = Repository();
  // final _loginResponse = PublishSubject<User>();

  // Observable<User> get loginResponse => _loginResponse.stream;

  Future<LoginResponse> login(String email, String password) async {
    LoginResponse response = await _repository.login(email, password);
    return response;
    // _loginResponse.sink.add(response);
  }

  // dispose() {
  //   _loginResponse.close();
  // }
}

final bloc = UserBloc();
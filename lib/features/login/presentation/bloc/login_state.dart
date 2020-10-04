import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

enum LoginStatus { checking, authenticating, logIn, error }

class LoginState extends Equatable {
  final User user;
  final LoginStatus status;

  LoginState({this.user, this.status});

  static LoginState get initialState => LoginState(
    user: null,
    status: LoginStatus.checking
  );

  LoginState copyWith({
    User user,
    LoginStatus status
  }) {
    return LoginState(
      user: user ?? this.user,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [user, status];
}
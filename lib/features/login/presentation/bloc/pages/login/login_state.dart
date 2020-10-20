import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

enum LoginStatus { checking, authenticating, logIn, error }
enum RegisterStatus { checking, registering, signIn, error }

class LoginState extends Equatable {
  final User user;
  final LoginStatus status;
  final RegisterStatus registerStatus;
  final String errorMessage;

  LoginState({ this.user, this.status, this.registerStatus, this.errorMessage });

  static LoginState get initialState => LoginState(
    user: null,
    status: LoginStatus.checking,
    registerStatus: RegisterStatus.checking,
    errorMessage: ''
  );

  LoginState copyWith({
    User user,
    LoginStatus status,
    RegisterStatus registerStatus,
    String errorMessage
  }) {
    return LoginState(
      user: user ?? this.user,
      status: status ?? this.status,
      registerStatus: registerStatus ?? this.registerStatus,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object> get props => [user, status, registerStatus, errorMessage];
}
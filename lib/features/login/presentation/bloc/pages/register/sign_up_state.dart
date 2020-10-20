import 'package:equatable/equatable.dart';
import 'package:service_now/features/login/domain/entities/user.dart';

enum SignUpStatus { checking, registering, signIn, error }

class SignUpState extends Equatable {
  final User user;
  final SignUpStatus status;
  final String errorMessage;

  SignUpState({ this.user, this.status, this.errorMessage });

  static SignUpState get initialState => SignUpState(
    user: null,
    status: SignUpStatus.checking,
    errorMessage: ''
  );

  SignUpState copyWith({
    User user,
    SignUpStatus status,
    String errorMessage
  }) {
    return SignUpState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object> get props => [user, SignUpStatus, errorMessage];
}
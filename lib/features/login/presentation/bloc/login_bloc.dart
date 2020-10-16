import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/domain/usecases/authentication.dart';
import 'package:service_now/features/login/domain/usecases/registration.dart';
import 'package:service_now/features/login/presentation/bloc/bloc.dart';
import 'package:service_now/features/login/presentation/bloc/login_event.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authentication authentication;
  final Registration registration;

  LoginBloc({
    @required Authentication login,
    @required Registration signin,
  }) : assert(login != null, signin != null),
       authentication = login,
       registration = signin;

  @override
  LoginState get initialState => LoginState.initialState;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AuthenticationByPasswordEvent) {
      yield* _loginByPassword(event);
    } if (event is RegisterByPasswordEvent) {
      yield* _registerByPassword(event);
    } else if (event is AuthenticationByFacebookEvent) {

    } else if (event is AuthenticationByGoogleEvent) {

    }
  }

  Stream<LoginState> _loginByPassword(AuthenticationByPasswordEvent event) async* {
    showDialog(
      context: event.context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(allTranslations.traslate('authenticating_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(status: LoginStatus.authenticating, user: null);

    final failureOrUser = await authentication(Params(email: event.email, password: event.password));
    yield* _eitherLoadedOrErrorState(failureOrUser);

    if (this.state.status == LoginStatus.logIn) {
      UserPreferences.instance.userId   = state.user.id;
      UserPreferences.instance.email    = state.user.email;
      UserPreferences.instance.firstName = state.user.firstName;
      UserPreferences.instance.lastName = state.user.lastName;
      UserPreferences.instance.token    = state.user.token;
      Navigator.pushNamed(event.context, HomePage.routeName, arguments: state.user);
    }
  }

  Stream<LoginState> _eitherLoadedOrErrorState(
    Either<Failure, User> failureOrUser
  ) async * {
    yield failureOrUser.fold(
      (failure) {
        return this.state.copyWith(status: LoginStatus.error, user: null);
      },
      (user) {
        return this.state.copyWith(status: LoginStatus.logIn, user: user);
      }
    );
  }

  Stream<LoginState> _registerByPassword(RegisterByPasswordEvent event) async* {
    showDialog(
      context: event.context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(allTranslations.traslate('registering_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(registerStatus: RegisterStatus.registering, user: null);

    final failureOrUser = await registration(RegistrationParams(firstName: event.firstName, lastName: event.lastName, email: event.email, password: event.password, confirmPassword: event.confirmPassword));
    yield* _eitherLoadedRegisterOrErrorState(failureOrUser);

    if (this.state.registerStatus == RegisterStatus.signIn) {
      Navigator.pushNamed(event.context, LoginPage.routeName, arguments: state.user);
    }
  }

  Stream<LoginState> _eitherLoadedRegisterOrErrorState(
    Either<Failure, User> failureOrUser
  ) async * {
    yield failureOrUser.fold(
      (failure) {
        return this.state.copyWith(registerStatus: RegisterStatus.error, user: null);
      },
      (user) {
        return this.state.copyWith(registerStatus: RegisterStatus.signIn, user: user);
      }
    );
  }

  static LoginBloc of(BuildContext context) {
    return BlocProvider.of<LoginBloc>(context);
  }
}
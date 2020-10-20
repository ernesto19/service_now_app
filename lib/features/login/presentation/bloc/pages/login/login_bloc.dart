import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/domain/usecases/authentication.dart';
import 'package:service_now/features/login/domain/usecases/authentication_by_facebook.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/bloc.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/login_event.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authentication authentication;
  final AuthenticationByFacebook authenticationByFacebook;

  LoginBloc({
    @required Authentication login,
    @required AuthenticationByFacebook loginFB
  }) : assert(login != null, loginFB != null),
       authentication = login,
       authenticationByFacebook = loginFB;

  @override
  LoginState get initialState => LoginState.initialState;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AuthenticationByPasswordEvent) {
      yield* _loginByPassword(event);
    } else if (event is AuthenticationByFacebookEvent) {
      yield* _loginByFacebook(event);
    } else if (event is AuthenticationByGoogleEvent) {

    }
  }

  Stream<LoginState> _loginByPassword(AuthenticationByPasswordEvent event) async* {
    this._showProgressDialog(event.context);

    yield this.state.copyWith(status: LoginStatus.authenticating, user: null);

    final failureOrUser = await authentication(Params(email: event.email, password: event.password));
    yield* _eitherLogInOrErrorState(failureOrUser);

    if (this.state.status == LoginStatus.logIn) {
      this._storeDataUser(state.user);
      Navigator.pushNamed(event.context, HomePage.routeName, arguments: state.user);
    } else if (this.state.status == LoginStatus.error) {
      Navigator.pop(event.context);
      this._showDialog('Importante', this.state.errorMessage, event.context);
    }
  }

  Stream<LoginState> _eitherLogInOrErrorState(
    Either<Failure, LoginResponse> failureOrUser
  ) async * {
    yield failureOrUser.fold(
      (failure) {
        return this.state.copyWith(status: LoginStatus.error, user: null);
      },
      (response) {
        if (response.error == 0) {
          return this.state.copyWith(status: LoginStatus.logIn, user: response.data);
        } else if (response.error == 2) {
          String email = response.validation[0]['email'] != null ? response.validation[0]['email'][0] + '\n' : '';
          String password = response.validation[0]['password'] != null ? response.validation[0]['password'][0] : '';
          String message = email + password;
          return this.state.copyWith(status: LoginStatus.error, errorMessage: message);
        } else {
          return this.state.copyWith(status: LoginStatus.error, errorMessage: response.message);
        }
      }
    );
  }

  Stream<LoginState> _loginByFacebook(AuthenticationByFacebookEvent event) async* {
    if (event.token == '500') {
      this._showDialog('Importante', 'Ocurrió un error inesperado. Vuelva a intentar más tarde.', event.context);
    } else if(event.token == '403') {
      this._showDialog('Importante', 'La autenticación vía Facebook fue cancelada.', event.context);
    } else {
      this._showProgressDialog(event.context);

      yield this.state.copyWith(status: LoginStatus.authenticating, user: null);

      final failureOrUser = await authenticationByFacebook(LoginFBParams(token: event.token));
      yield* _eitherLogInOrErrorState(failureOrUser);

      if (this.state.status == LoginStatus.logIn) {
        this._storeDataUser(state.user);
        Navigator.pushNamed(event.context, HomePage.routeName, arguments: state.user);
      } else if (this.state.status == LoginStatus.error) {
        Navigator.pop(event.context);
        this._showDialog('Importante', this.state.errorMessage, event.context);
      }
    }
  }

  void _storeDataUser(User user) {
    UserPreferences.instance.userId   = user.id;
    UserPreferences.instance.email    = user.email;
    UserPreferences.instance.firstName = user.firstName;
    UserPreferences.instance.lastName = user.lastName;
    UserPreferences.instance.token    = user.token;
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
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
  }

  void _showDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.0),),
          actions: <Widget>[
            FlatButton(
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );
  }

  static LoginBloc of(BuildContext context) {
    return BlocProvider.of<LoginBloc>(context);
  }
}
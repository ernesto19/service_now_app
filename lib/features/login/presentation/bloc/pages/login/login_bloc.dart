import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';
import 'package:service_now/features/login/domain/usecases/authentication.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/bloc.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/login_event.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authentication authentication;

  LoginBloc({
    @required Authentication login,
  }) : assert(login != null),
       authentication = login;

  @override
  LoginState get initialState => LoginState.initialState;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AuthenticationByPasswordEvent) {
      yield* _loginByPassword(event);
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
    } else if (this.state.status == LoginStatus.error) {
      Navigator.pop(event.context);
      this._showDialog('Importante', this.state.errorMessage, event.context);
    }
  }

  Stream<LoginState> _eitherLoadedOrErrorState(
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
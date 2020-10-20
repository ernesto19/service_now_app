import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/login/data/responses/sign_up_response.dart';
import 'package:service_now/features/login/domain/usecases/registration.dart';
import 'package:service_now/features/login/presentation/bloc/pages/sign_up/sign_up_event.dart';
import 'package:service_now/features/login/presentation/bloc/pages/sign_up/sign_up_state.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/utils/all_translations.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final Registration registration;

  SignUpBloc({
    @required Registration signin,
  }) : assert(signin != null),
       registration = signin;

  @override
  SignUpState get initialState => SignUpState.initialState;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is RegisterByPasswordEvent) {
      yield* _registerByPassword(event);
    }
  }

  Stream<SignUpState> _registerByPassword(RegisterByPasswordEvent event) async* {
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

    yield this.state.copyWith(status: SignUpStatus.registering, user: null);

    final failureOrUser = await registration(RegistrationParams(firstName: event.firstName, lastName: event.lastName, email: event.email, password: event.password, confirmPassword: event.confirmPassword));
    yield* _eitherLoadedRegisterOrErrorState(failureOrUser);

    if (this.state.status == SignUpStatus.signIn) {
      Navigator.pushNamed(event.context, LoginPage.routeName, arguments: state.user);
    } else if (this.state.status == SignUpStatus.error) {
      Navigator.pop(event.context);
      this._showDialog('Importante', this.state.errorMessage, event.context);
    }
  }

  Stream<SignUpState> _eitherLoadedRegisterOrErrorState(
    Either<Failure, SignUpResponse> failureOrUser
  ) async * {
    yield failureOrUser.fold(
      (failure) {
        return this.state.copyWith(status: SignUpStatus.error, user: null);
      },
      (response) {
        if (response.error == 0) {
          return this.state.copyWith(status: SignUpStatus.signIn, user: response.data);
        } else if (response.error == 2) {
          String firstName = response.validation[0]['first_name'] != null ? response.validation[0]['first_name'][0] + '\n' : '';
          String lastName = response.validation[0]['last_name'] != null ? response.validation[0]['last_name'][0] + '\n' : '';
          String email = response.validation[0]['email'] != null ? response.validation[0]['email'][0] + '\n' : '';
          String password = response.validation[0]['password'] != null ? response.validation[0]['password'][0] : '';
          String message = firstName + lastName + email + password;
          return this.state.copyWith(status: SignUpStatus.error, errorMessage: message);
        } else {
          return this.state.copyWith(status: SignUpStatus.error, errorMessage: response.message);
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

  static SignUpBloc of(BuildContext context) {
    return BlocProvider.of<SignUpBloc>(context);
  }
}
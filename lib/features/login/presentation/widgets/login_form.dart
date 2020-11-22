import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/bloc.dart';
import 'package:service_now/features/login/presentation/pages/sign_up_page.dart';
import 'package:service_now/libs/auth.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/circle_button.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import '../../../../injection_container.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<LoginBloc> buildBody(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = LoginBloc.of(context);

          return SafeArea(
            top: false,
            child: Container(
              width: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InputText(
                    controller: _emailController,
                    iconPath: 'assets/icons/mail.svg', 
                    placeholder: allTranslations.traslate('email'),
                    obscureText: false
                  ),
                  SizedBox(height: responsive.ip(2)),
                  InputText(
                    controller: _passwordController,
                    iconPath: 'assets/icons/key.svg', 
                    placeholder: allTranslations.traslate('password'),
                    obscureText: _obscureTextPassword,
                    suffix: _crearVisibilityPassword()
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        allTranslations.traslate('recover_password'),
                        style: TextStyle(
                          fontFamily: 'sans'
                        )
                      ), 
                      onPressed: () { }
                    )
                  ),
                  SizedBox(height: responsive.ip(2)),
                  RoundedButton(
                    label: allTranslations.traslate('log_in'),
                    width: responsive.wp(50),
                    onPressed: () {
                      String email      = _emailController.text;
                      String password   = _passwordController.text;
                      bloc.add(AuthenticationByPasswordEvent(email, password, context));
                    }
                  ),
                  SizedBox(height: responsive.ip(3)),
                  Text(allTranslations.traslate('or_continue')),
                  SizedBox(height: responsive.ip(1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleButton(
                        iconPath: 'assets/icons/facebook.svg',
                        backgroundColor: Color(0xff448AFF),
                        size: 55,
                        onPressed: () async {
                          String token = await Auth.instance.facebook();
                          bloc.add(AuthenticationByFacebookEvent(token, context));
                        }
                      ),
                      // SizedBox(width: 20),
                      // CircleButton(
                      //   iconPath: 'assets/icons/google.svg',
                      //   backgroundColor: Color(0xffFF1744),
                      //   size: 55,
                      //   onPressed: () async {
                      //     // User user = await Auth.instance.google();
                      //   }
                      // )
                    ]
                  ),
                  SizedBox(height: responsive.ip(3)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(allTranslations.traslate('not_have_account')),
                      CupertinoButton(
                        child: Text(
                          allTranslations.traslate('create_account'),
                          style: TextStyle(
                            fontFamily: 'sans'
                          ),
                        ), 
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpPage.routeName);
                        }
                      )
                    ]
                  )
                ]
              )
            )
          );
        }
      )
    );
  }

  Widget _crearVisibilityPassword() {
    return IconButton(
      icon: _obscureTextPassword ? Icon(Icons.visibility_off, color: Color(0xffcccccc)) : Icon(Icons.visibility, color: Color(0xffcccccc)),
      onPressed: () {
        setState(() {
          _obscureTextPassword = !_obscureTextPassword;
        });
      },
    );
  }
}
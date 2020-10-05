import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/login/domain/entities/user.dart';
import 'package:service_now/features/login/presentation/bloc/bloc.dart';
import 'package:service_now/libs/auth.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/circle_button.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import '../../../../injection_container.dart';

class LoginForm extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
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
                    obscureText: true
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
                      bloc.add(AuthenticationByPasswordEvent(_emailController.text, _passwordController.text, context, 'Autenticando ...'));
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
                          User user = await Auth.instance.facebook();
                        }
                      ),
                      SizedBox(width: 20),
                      CircleButton(
                        iconPath: 'assets/icons/google.svg',
                        backgroundColor: Color(0xffFF1744),
                        size: 55,
                        onPressed: () async {
                          User user = await Auth.instance.google();
                        }
                      )
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
                            fontFamily: 'sans',
                            fontWeight: FontWeight.w600
                          ),
                        ), 
                        onPressed: () {}
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
}
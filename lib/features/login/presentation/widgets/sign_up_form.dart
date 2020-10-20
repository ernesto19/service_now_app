import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/login/presentation/bloc/pages/sign_up/bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import '../../../../injection_container.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<SignUpBloc> buildBody(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return BlocProvider(
      create: (_) => sl<SignUpBloc>(),
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = SignUpBloc.of(context);

          return SafeArea(
            top: false,
            child: Container(
              width: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InputText(
                    controller: _firstNameController,
                    iconPath: 'assets/icons/name.svg', 
                    placeholder: allTranslations.traslate('first_name'),
                    obscureText: false
                  ),
                  SizedBox(height: responsive.ip(2)),
                  InputText(
                    controller: _lastNameController,
                    iconPath: 'assets/icons/name.svg', 
                    placeholder: allTranslations.traslate('last_name'),
                    obscureText: false
                  ),
                  SizedBox(height: responsive.ip(2)),
                  InputText(
                    controller: _emailController,
                    iconPath: 'assets/icons/mail.svg', 
                    placeholder: allTranslations.traslate('email'),
                    obscureText: false
                  ),
                  SizedBox(height: responsive.ip(1)),
                  InputText(
                    controller: _passwordController,
                    iconPath: 'assets/icons/key.svg', 
                    placeholder: allTranslations.traslate('password'),
                    obscureText: _obscureTextPassword,
                    suffix: _crearVisibilityPassword()
                  ),
                  SizedBox(height: responsive.ip(5)),
                  RoundedButton(
                    label: allTranslations.traslate('create_account'),
                    width: responsive.wp(50),
                    onPressed: () {
                      String firstName  = _firstNameController.text;
                      String lastName   = _lastNameController.text;
                      String email      = _emailController.text;
                      String password   = _passwordController.text;
                      bloc.add(RegisterByPasswordEvent(firstName, lastName, email, password, password, context));
                    }
                  ),
                  SizedBox(height: responsive.ip(3)),
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
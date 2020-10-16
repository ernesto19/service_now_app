import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/login/presentation/bloc/bloc.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:service_now/widgets/input_text.dart';
import 'package:service_now/widgets/rounded_button.dart';

import '../../../../injection_container.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextPasswordConfirm = true;

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
                  SizedBox(height: responsive.ip(1)),
                  InputText(
                    controller: _passwordConfirmController,
                    iconPath: 'assets/icons/key.svg', 
                    placeholder: allTranslations.traslate('confirm_password'),
                    obscureText: _obscureTextPasswordConfirm,
                    suffix: _crearVisibilityPasswordConfirm()
                  ),
                  SizedBox(height: responsive.ip(5)),
                  RoundedButton(
                    label: allTranslations.traslate('create_account'),
                    width: responsive.wp(50),
                    onPressed: () {
                      bloc.add(RegisterByPasswordEvent(_firstNameController.text, _lastNameController.text, _emailController.text, _passwordController.text, _passwordConfirmController.text, context, 'Registrando ...'));
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
      icon: _obscureTextPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
      onPressed: () {
        setState(() {
          _obscureTextPassword = !_obscureTextPassword;
        });
      },
    );
  }

  Widget _crearVisibilityPasswordConfirm() {
    return IconButton(
      icon: _obscureTextPasswordConfirm ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
      onPressed: () {
        setState(() {
          _obscureTextPasswordConfirm = !_obscureTextPasswordConfirm;
        });
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/select_business/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/colors.dart';

class BusinessSelectPage extends StatefulWidget {
  final Business business;

  const BusinessSelectPage({ @required this.business });

  @override
  _BusinessSelectPageState createState() => _BusinessSelectPageState();
}

class _BusinessSelectPageState extends State<BusinessSelectPage> {
  ButtonState stateOnlyText = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SelectBusinessBloc>(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: BlocBuilder<SelectBusinessBloc, SelectBusinessState>(
          builder: (context, state) {
            // ignore: close_sinks
            final bloc = SelectBusinessBloc.of(context);

            return Center(
              child: ProgressButton.icon(
                iconedButtons: {
                  ButtonState.idle:
                    IconedButton(
                      text: "Solicitar",
                      icon: Icon(Icons.send, color: Colors.white, size: 20),
                      color: secondaryDarkColor
                    ),
                  ButtonState.loading:
                    IconedButton(
                      text: "Confirmando cita",
                      color: secondaryDarkColor
                    ),
                  ButtonState.fail:
                    IconedButton(
                      text: "Confirmación fallida",
                      icon: Icon(Icons.cancel, color: Colors.white, size: 20),
                      color: Colors.red.shade300
                    ),
                  ButtonState.success:
                    IconedButton(
                      text: "Confirmación exitosa",
                      icon: Icon(Icons.check_circle, color: Colors.white, size: 20),
                      color: Colors.green.shade400
                    )
                }, 
                onPressed: () => onPressedCustomButton(bloc),
                state: stateOnlyText,
                height: 50.0,
                minWidth: double.infinity,
                maxWidth: double.infinity,
                textStyle: TextStyle(fontSize: 17, color: Colors.white),
              )
            );
          }
        )
      )
    );
  }

  void onPressedCustomButton(SelectBusinessBloc bloc) {
    bloc.add(RequestBusinessForUser(widget.business.id));

    setState(() {
      switch (stateOnlyText) {
        case ButtonState.idle:
          stateOnlyText = ButtonState.loading;
          break;
        case ButtonState.loading:
          stateOnlyText = ButtonState.fail;
          break;
        case ButtonState.success:
          stateOnlyText = ButtonState.idle;
          break;
        case ButtonState.fail:
          stateOnlyText = ButtonState.success;
          break;
      }
    });
  }
}
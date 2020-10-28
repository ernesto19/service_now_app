import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/business_picker.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';

import 'professional_business_register_page.dart';

class ProfessionalBusinessPage extends StatefulWidget {
  static final routeName = 'professional_business_page';

  @override
  _ProfessionalBusinessPageState createState() => _ProfessionalBusinessPageState();
}

class _ProfessionalBusinessPageState extends State<ProfessionalBusinessPage> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessRegisterPage(business: null)))
      )
    );
  }

  BlocProvider<ProfessionalBloc>  buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfessionalBloc>(),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: CustomScrollView(
                slivers: [
                  Header(
                    title: allTranslations.traslate('my_business_title'),
                    titleSize: 22,
                    onTap: () => Navigator.pop(context)
                  ),
                  BlocBuilder<ProfessionalBloc, ProfessionalState>(
                    builder: (context, state) {
                      String text = '';

                      if (state.status == ProfessionalStatus.ready) {
                        return BusinessPicker();
                      } else if (state.status == ProfessionalStatus.error) {
                        text = 'Error';
                      } else {
                        text = allTranslations.traslate('loading_message');
                      }

                      return SliverFillRemaining(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            ),
                            Text(text)
                          ]
                        )
                      );
                    }
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}
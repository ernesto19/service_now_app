import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/features/professional/presentation/widgets/business_picker.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';

class ProfessionalBusinessPage extends StatefulWidget {
  static final routeName = 'professional_business_page';

  @override
  _ProfessionalBusinessPageState createState() => _ProfessionalBusinessPageState();
}

class _ProfessionalBusinessPageState extends State<ProfessionalBusinessPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: secondaryDarkColor,
        onPressed: () {}
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
                      } else if (state.status == ProfessionalStatus.checking) {
                        text = allTranslations.traslate('loading_message');
                      } else {
                        text = 'Error';
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
}
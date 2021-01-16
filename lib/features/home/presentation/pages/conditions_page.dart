import 'package:flutter/material.dart';
import 'package:service_now/blocs/user_bloc.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class ConditionsPage extends StatelessWidget {
  static final routeName = 'conditions_page';

  @override
  Widget build(BuildContext context) {
    bloc.fetchConditions();

    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('condiciones'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder(
          stream: bloc.allConditions,
          builder: (context, AsyncSnapshot<ConditionsResponse> snapshot) {
            if (snapshot.hasData) {
              ConditionsResponse response = snapshot.data;

              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Condition condition = response.data[index];

                        return Column(
                          children: [
                            Text(condition.order.toString() + '. ' + condition.content),
                            SizedBox(height: 10)
                          ]
                        );
                      },
                      childCount: response.data.length
                    )
                  )
                ],
              );

              
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Center(
              child: CircularProgressIndicator()
            );
          }
        ),
      )
    );
  }
}
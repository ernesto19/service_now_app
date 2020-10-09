import 'package:flutter/material.dart';
import 'package:service_now/features/professional/presentation/widgets/header.dart';

class ProfessionalBusinessPage extends StatefulWidget {

  @override
  _ProfessionalBusinessPageState createState() => _ProfessionalBusinessPageState();
}

class _ProfessionalBusinessPageState extends State<ProfessionalBusinessPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: CustomScrollView(
              slivers: [
                Header(
                  title: 'Mis negocios',
                  titleSize: 22
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    color: Colors.redAccent
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}
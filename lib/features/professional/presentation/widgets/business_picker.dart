import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_detail_page.dart';

class BusinessPicker extends StatefulWidget {

  const BusinessPicker();

  @override
  _BusinessPickerState createState() => _BusinessPickerState();
}

class _BusinessPickerState extends State<BusinessPicker> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalBloc, ProfessionalState> (builder: (context, state) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            ProfessionalBusiness business = state.business[index];

            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(business.name)
                            ),
                            ShaderMask(
                              child: CupertinoSwitch(
                                activeColor: Colors.greenAccent[100],
                                value: toggleValue,
                                onChanged: (v) => setState(() => toggleValue = v),
                              ),
                              shaderCallback: (r) {
                                return LinearGradient(
                                  colors: toggleValue
                                      ? [ Colors.greenAccent[100], Colors.greenAccent[100]]
                                      : [ Colors.redAccent[100], Colors.redAccent[100]],
                                ).createShader(r);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // child: Stack(
                  //   fit: StackFit.expand,
                  //   children: <Widget>[
                  //     Image.network(
                  //       lista[index].logo,
                  //       fit: BoxFit.fill
                  //     ),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [ Colors.white12, Colors.black87 ],
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter
                  //         )
                  //       )
                  //     ),
                  //     Positioned(
                  //       bottom: 0,
                  //       right: 0,
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //         child: Text(
                  //           lista[index].name,
                  //           style: TextStyle(
                  //             inherit: true,
                  //             fontSize: 25,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //             fontFamily: 'raleway',
                  //             shadows: [
                  //               Shadow(
                  //                 offset: Offset(-1.5, -1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(1.5, -1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(1.5, 1.5),
                  //                 color: Colors.black
                  //               ),
                  //               Shadow(
                  //                 offset: Offset(-1.5, 1.5),
                  //                 color: Colors.black
                  //               )
                  //             ]
                  //           )
                  //         ),
                  //       ),
                  //     )
                  //   ]
                  // )
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(2, 2)
                    )
                  ]
                )
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalBusinessDetailPage(business: business)))
            );
          },
          childCount: state.business.length
        ),
      );
    });
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/bloc.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_detail_page.dart';

class BusinessPicker extends StatefulWidget {

  const BusinessPicker();

  @override
  _BusinessPickerState createState() => _BusinessPickerState();
}

class _BusinessPickerState extends State<BusinessPicker> {
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(business.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                            ),
                            ShaderMask(
                              child: CupertinoSwitch(
                                activeColor: Colors.greenAccent[100],
                                value: business.active == 1,
                                onChanged: (value) => setState(() => business.active = value ? 1 : 0)
                              ),
                              shaderCallback: (r) {
                                return LinearGradient(
                                  colors: business.active == 1
                                      ? [ Colors.greenAccent[100], Colors.greenAccent[100]]
                                      : [ Colors.redAccent[100], Colors.redAccent[100]],
                                ).createShader(r);
                              }
                            )
                          ]
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.web, size: 20),
                            SizedBox(width: 10),
                            Text(business.categoryName.toUpperCase(), style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.pin_drop, size: 20),
                            SizedBox(width: 10),
                            Text(business.address, style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.stars, size: 20),
                            SizedBox(width: 10),
                            Text(business.licenseNumber, style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 5)
                      ]
                    )
                  ),
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
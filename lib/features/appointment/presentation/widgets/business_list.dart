import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/presentation/pages/business_detail_page.dart';

import 'custom_rating_bar.dart';

class BusinessList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState> (builder: (_, state) {
      List<Business> businessList = state.business;

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            Business business = businessList[index];
            return Column(
              children: [
                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(business.name, style: TextStyle(fontSize: 17)),
                              SizedBox(height: 2),
                              CustomRatingBar(business: business),
                              SizedBox(height: 2),
                              Text('${business.distance.toStringAsFixed(2)} km'),
                              SizedBox(height: 10)
                            ]
                          )
                        ),
                        Container(
                          height: 170.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: business.gallery.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 200,
                                width: 200,
                                child: Image.network(
                                  business.gallery[index].url, 
                                  fit: BoxFit.cover
                                )
                              );
                            }
                          )
                        )
                      ]
                    )
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessDetailPage(business: business)))
                ),
                SizedBox(height: 10)
              ]
            );
          },
          childCount: businessList.length
        )
      );
    });
  }
}
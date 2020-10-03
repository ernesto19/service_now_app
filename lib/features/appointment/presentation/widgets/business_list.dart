import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/presentation/pages/business_detail_page.dart';

import 'custom_rating_bar.dart';

class BusinessList extends StatelessWidget {

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
    'https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350'
  ];

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
                            itemCount: imgList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 200,
                                width: 200,
                                child: Image.network(
                                  imgList[index], 
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
import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/features/appointment/presentation/widgets/business_list.dart';
import 'package:service_now/injection_container.dart';

class BusinessPhotosPage extends StatelessWidget {
  final Business business;

  const BusinessPhotosPage({ @required this.business });

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      'https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350'
    ];

    return BlocProvider(
      create: (_) => sl<AppointmentBloc>(),
      child: Container(
        padding: EdgeInsets.all(10),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                // ignore: close_sinks
                final bloc = AppointmentBloc.of(context);
                bloc.add(GetGalleriesForUser(business.id));

                if (state.status == BusinessStatus.readyGallery) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Servicio $index'),
                              SizedBox(height: 10),
                              Container(
                                height: 200.0,
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
                        );
                      },
                      childCount: 4
                    )
                  );
                } else {
                  return SliverFillRemaining(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    )
                  );
                }
              }
            )
            /*
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Servicio $index'),
                        SizedBox(height: 10),
                        Container(
                          height: 200.0,
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
                  );
                },
                childCount: 4
              )
            )
            */
          ]
        )
      )
    );
    /*
    return Container(
      padding: EdgeInsets.all(10),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Servicio $index'),
                      SizedBox(height: 10),
                      Container(
                        height: 200.0,
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
                );
              },
              childCount: 4
            )
          )
        ]
      )
    );
    */
  }
}
import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/all_translations.dart';

class BusinessPhotosPage extends StatelessWidget {
  final Business business;

  const BusinessPhotosPage({ @required this.business });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentBloc>(),
      child: Container(
        padding: EdgeInsets.all(10),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            // ignore: close_sinks
            final bloc = AppointmentBloc.of(context);
            bloc.add(GetGalleriesForUser(business.id));

            if (state.status == BusinessStatus.readyGallery) {
              List<Service> services = state.services;

              if (services.length > 0) {
                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Service service = services[index];

                          return Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.name),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    service.discount.isEmpty ? Text('\$${service.price} USD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)) : Text('\$${service.price} USD', style: TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough)),
                                    SizedBox(width: 5),
                                    service.discount.isEmpty ? Container() : Container(
                                      child: Row(
                                        children: [
                                          Text('\$${service.finalPrice} USD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                          SizedBox(width: 5),
                                          Container(
                                            color: Colors.green,
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                            child: Text('-' + service.discount, style: TextStyle(fontSize: 10, color: Colors.white)),
                                          )
                                        ]
                                      )
                                    )
                                  ]
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 200.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: service.photos.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 200,
                                        width: 200,
                                        child: FadeInImage(
                                          image: NetworkImage(service.photos[index] ?? ''),
                                          placeholder: AssetImage('assets/images/loader.gif'),
                                          fadeInDuration: Duration(milliseconds: 200),
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
                        childCount: services.length
                      )
                    )
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                      SizedBox(height: 10),
                      Text(allTranslations.traslate('no_hay_informacion')),
                    ],
                  ),
                );
              }
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }
        )
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';

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
              List<Gallery> galleries = state.galleries;

              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Gallery gallery = galleries[index];

                        return Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(gallery.name),
                              SizedBox(height: 10),
                              Container(
                                height: 200.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: gallery.photos.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 200,
                                      width: 200,
                                      child: Image.network(
                                        gallery.photos[index], 
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
                      childCount: galleries.length
                    )
                  )
                ],
              );
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
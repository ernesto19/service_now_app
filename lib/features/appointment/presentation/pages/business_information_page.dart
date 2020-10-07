import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/presentation/bloc/bloc.dart';
import 'package:service_now/injection_container.dart';

class BusinessInformationPage extends StatelessWidget {
  final Business business;

  const BusinessInformationPage({ @required this.business });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentBloc>(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(business.name, style: TextStyle(fontSize: 19))
                      ),
                      // RawMaterialButton(
                      //   elevation: 2.0,
                      //   fillColor: secondaryColor,
                      //   child: Icon(
                      //     Icons.favorite_border,
                      //     size: 20,
                      //     color: Colors.white
                      //   ),
                      //   shape: CircleBorder(),
                      //   onPressed: () {},
                      // )
                    ]
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(business.rating),
                      SizedBox(width: 10),
                      RatingBar(
                        initialRating: double.parse(business.rating),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: null
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('${business.distance.toStringAsFixed(2)} km'),
                  SizedBox(height: 20),
                  Text(
                    business.description
                  )
                ]
              )
            )
          ),
          BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              // ignore: close_sinks
              final bloc = AppointmentBloc.of(context);
              bloc.add(GetCommentsForUser(business.id));

              if (state.status == BusinessStatus.readyComments) {
                List<Comment> comments = state.comments;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      Comment comment = comments[index];

                      return _buildComment(comment);
                    },
                    childCount: comments.length
                  ),
                );
              }

              return SliverFillRemaining(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                )
              );
            }
          )
        ]
      )
    );
  }

  Widget _buildComment(Comment comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar(
                  initialRating: double.parse(comment.rating),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber
                  ),
                  ignoreGestures: true,
                  onRatingUpdate: null
                ),
                Text(
                  comment.comment,
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
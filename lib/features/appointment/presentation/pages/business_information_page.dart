import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';

class BusinessInformationPage extends StatelessWidget {
  final Business business;

  const BusinessInformationPage({ @required this.business });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildComment();
            },
            childCount: 10
          ),
        )
      ]
    );
  }

  Widget _buildComment() {
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
                  initialRating: 3.5,
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
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
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
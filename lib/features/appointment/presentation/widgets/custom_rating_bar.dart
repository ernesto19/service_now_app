import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({ @required this.business });

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(business.rating),
        SizedBox(width: 2),
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
      ]
    );
  }
}
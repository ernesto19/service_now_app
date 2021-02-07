import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:service_now/utils/colors.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, rating, distance, buttonText;
  final Function onPressed;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.rating,
    @required this.distance,
    @required this.buttonText,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                distance,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5),
              RatingBar.builder(
                initialRating: double.parse(rating),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber
                ),
                ignoreGestures: true,
                onRatingUpdate: null
              ),
              SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  color: secondaryDarkColor,
                  onPressed: onPressed,
                  child: Text(buttonText, style: TextStyle(color: Colors.white))
                )
              )
            ]
          )
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: Consts.avatarRadius,
            child: Icon(Icons.business, size: 35, color: Colors.white),
          ),
        )
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16;
  static const double avatarRadius = 40;
}
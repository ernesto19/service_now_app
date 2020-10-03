import 'package:meta/meta.dart';

class GetBusinessRequest {
  const GetBusinessRequest({ @required this.categoryId, @required this.latitude, @required this.longitude });

  final int categoryId;
  final String latitude;
  final String longitude;

  Map<String, dynamic> toJson() {
    return {
      'categories': [
        categoryId
      ],
      'lat': latitude,
      'long': longitude
    };
  }
}
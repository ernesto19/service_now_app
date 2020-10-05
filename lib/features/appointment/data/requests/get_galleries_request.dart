import 'package:meta/meta.dart';

class GetGalleriesRequest {
  const GetGalleriesRequest({ @required this.businessId });

  final int businessId;

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId
    };
  }
}
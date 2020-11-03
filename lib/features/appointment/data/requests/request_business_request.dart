import 'package:meta/meta.dart';

class RequestBusinessRequest {
  const RequestBusinessRequest({ @required this.businessId });

  final int businessId;

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId
    };
  }
}
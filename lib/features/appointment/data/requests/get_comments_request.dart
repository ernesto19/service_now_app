import 'package:meta/meta.dart';

class GetCommentsRequest {
  const GetCommentsRequest({ @required this.businessId });

  final int businessId;

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId
    };
  }
}
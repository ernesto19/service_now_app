import 'package:meta/meta.dart';

class GetMessagesRequest {
  const GetMessagesRequest({ @required this.userId, @required this.businessId });

  final int userId;
  final int businessId;

  Map<String, dynamic> toJson() {
    return {
      'request_type': [
        'pnRequestService'
      ],
      'user_id': userId,
      'business_id': businessId
    };
  }
}
import 'package:service_now/features/home/data/models/membership_model.dart';

class GetMembershipResponse {
  int error;
  String message;
  MembershipModel data;

  GetMembershipResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = MembershipModel.fromJson(json['data']);
  }
}
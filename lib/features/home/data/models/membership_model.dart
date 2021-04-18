import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';

class MembershipModel extends Membership {
  MembershipModel({
    @required int id,
    @required String acquisitionDate,
    @required String expiration,
    @required int active
  }) : super(id: id, acquisitionDate: acquisitionDate, expiration: expiration, active: active);

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    var format = new DateFormat('dd/MM/yyyy h:mm a');

    return MembershipModel(
      id: json['id'], 
      acquisitionDate: json['acquisition_date'] != null ? format.format(DateTime.parse(json['acquisition_date'])) : '-',
      expiration: json['expiration'] != null ? format.format(DateTime.parse(json['expiration'])) : '-',
      active: json['active'] is int ? json['active'] : int.parse(json['active'])
    );
  }
}
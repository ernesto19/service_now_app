import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Membership extends Equatable {
  final int id;
  final String acquisitionDate;
  final String expiration;
  final int active;

  Membership({
    @required this.id,
    @required this.acquisitionDate,
    @required this.expiration,
    @required this.active
  });

  @override
  List<Object> get props => [id, acquisitionDate, expiration, active];
}
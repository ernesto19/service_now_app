import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';

enum MembershipStatus { checking, loading, selecting, downloading, ready, error }

class MembershipState extends Equatable {
  final MembershipStatus status;
  final Membership membership;

  MembershipState({ @required this.status, @required this.membership });

  static MembershipState get inititalState => MembershipState(
    status: MembershipStatus.checking,
    membership: null
  );

  MembershipState copyWith({
    MembershipStatus status,
    Membership membership
  }) {
    return MembershipState(
      status: status ?? this.status,
      membership: membership ?? this.membership
    );
  }

  @override
  List<Object> get props => [status, membership];
}
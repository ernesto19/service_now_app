import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum MembershipStatus { checking, loading, selecting, downloading, ready, error }

class MembershipState extends Equatable {
  final MembershipStatus status;

  MembershipState({ @required this.status });

  static MembershipState get inititalState => MembershipState(
    status: MembershipStatus.checking
  );

  MembershipState copyWith({
    MembershipStatus status,
  }) {
    return MembershipState(
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [status];

}
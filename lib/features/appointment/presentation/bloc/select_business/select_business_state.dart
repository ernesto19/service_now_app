import 'package:equatable/equatable.dart';

enum SelectBusinessStatus { checking, loading, selecting, downloading, ready, error }

class SelectBusinessState extends Equatable {
  final SelectBusinessStatus status;

  SelectBusinessState({ this.status });

  static SelectBusinessState get initialState => SelectBusinessState(
    status: SelectBusinessStatus.loading
  );

  SelectBusinessState copyWith({
    SelectBusinessStatus status
  }) {
    return SelectBusinessState(
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [status];
}
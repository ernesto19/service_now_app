import 'package:equatable/equatable.dart';

enum PaymentServicesStatus { checking, paying, ready, error }

class PaymentServicesState extends Equatable {
  final PaymentServicesStatus status;

  PaymentServicesState({ this.status });

  static PaymentServicesState get initialState => PaymentServicesState(
    status: PaymentServicesStatus.checking
  );

  PaymentServicesState copyWith({
    PaymentServicesStatus status
  }) {
    return PaymentServicesState(
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [status];
}
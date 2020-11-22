import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/data/responses/payment_services_response.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/appointment/domain/usecases/payment_services_by_user.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'payment_services_event.dart';
import 'payment_services_state.dart';

class PaymentServicesBloc extends Bloc<PaymentServicesEvent, PaymentServicesState> {
  final PaymentServicesByUser paymentServicesByUser;

  PaymentServicesBloc({
    @required PaymentServicesByUser paymentServices
  }) : assert(paymentServices != null),
       paymentServicesByUser = paymentServices;

  @override
  PaymentServicesState get initialState => PaymentServicesState.initialState;

  @override
  Stream<PaymentServicesState> mapEventToState(PaymentServicesEvent event) async* {
    if (event is PaymentServicesForUser) {
      final failureOrRequest = await paymentServicesByUser(Params(userId: event.userId, services: event.services));
      yield* _eitherRequestBusinessOrErrorState(failureOrRequest);
      Navigator.pushNamedAndRemoveUntil(event.context, HomePage.routeName, (Route<dynamic> route) => false);
    }
  }

  Stream<PaymentServicesState> _eitherRequestBusinessOrErrorState(
    Either<Failure, PaymentServicesResponse> failureOrPayment
  ) async * {
    yield failureOrPayment.fold(
      (failure) {
        return this.state.copyWith(status: PaymentServicesStatus.error);
      },
      (response) {
        return this.state.copyWith(status: PaymentServicesStatus.ready);
      }
    );
  }

  static PaymentServicesBloc of(BuildContext context) {
    return BlocProvider.of<PaymentServicesBloc>(context);
  }
}
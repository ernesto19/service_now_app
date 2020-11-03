import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/features/appointment/domain/usecases/request_business_by_user.dart';
import 'select_business_event.dart';
import 'select_business_state.dart';

class SelectBusinessBloc extends Bloc<SelectBusinessEvent, SelectBusinessState> {
  final RequestBusinessByUser requestBusinessByUser;

  SelectBusinessBloc({
    @required RequestBusinessByUser requestBusiness
  }) : assert(requestBusiness != null),
       requestBusinessByUser = requestBusiness;

  @override
  SelectBusinessState get initialState => SelectBusinessState.initialState;

  @override
  Stream<SelectBusinessState> mapEventToState(SelectBusinessEvent event) async* {
    if (event is RequestBusinessForUser) {
      print('======= SOLICITANDO SERVICIO ======');
      final failureOrRequest = await requestBusinessByUser(Params(businessId: event.businessId));
      yield* _eitherRequestBusinessOrErrorState(failureOrRequest);
    }
  }

  Stream<SelectBusinessState> _eitherRequestBusinessOrErrorState(
    Either<Failure, RequestBusinessResponse> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: SelectBusinessStatus.error);
      },
      (response) {
        return this.state.copyWith(status: SelectBusinessStatus.ready);
      }
    );
  }

  static SelectBusinessBloc of(BuildContext context) {
    return BlocProvider.of<SelectBusinessBloc>(context);
  }
}
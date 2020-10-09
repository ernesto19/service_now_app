import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/usecases/get_business_by_professional.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_event.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_state.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionalBusinessByProfessional getBusinessByProfessional;

  ProfessionalBloc({
    @required GetProfessionalBusinessByProfessional business,
  }) : assert(business != null),
       getBusinessByProfessional = business {
    add(GetBusinessForProfessional(1));
  }

  @override
  ProfessionalState get initialState => ProfessionalState.initialState;

  @override
  Stream<ProfessionalState> mapEventToState(ProfessionalEvent event) async* {
    if (event is GetBusinessForProfessional) {
      final failureOrBusiness = await getBusinessByProfessional(GetProfessionalBusinessParams(professionalId: event.professionalId));
      yield* _eitherLoadedBusinessOrErrorState(failureOrBusiness);
    }
  }

  Stream<ProfessionalState> _eitherLoadedBusinessOrErrorState(
    Either<Failure, List<ProfessionalBusiness>> failureOrBusiness
  ) async * {
    yield failureOrBusiness.fold(
      (failure) {
        return this.state.copyWith(status: ProfessionalStatus.error, business: []);
      },
      (business) {
        return this.state.copyWith(status: ProfessionalStatus.ready, business: business);
      }
    );
  }

  static ProfessionalBloc of(BuildContext context) {
    return BlocProvider.of<ProfessionalBloc>(context);
  }
}
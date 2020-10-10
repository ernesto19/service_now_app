import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/usecases/get_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/get_services_by_professional.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_event.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_state.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionalBusinessByProfessional getBusinessByProfessional;
  final GetProfessionalServicesByProfessional getServicesByProfessional;

  ProfessionalBloc({
    @required GetProfessionalBusinessByProfessional business,
    @required GetProfessionalServicesByProfessional services,
  }) : assert(business != null, services != null),
       getBusinessByProfessional = business,
       getServicesByProfessional = services {
    add(GetBusinessForProfessional(1));
  }

  @override
  ProfessionalState get initialState => ProfessionalState.initialState;

  @override
  Stream<ProfessionalState> mapEventToState(ProfessionalEvent event) async* {
    if (event is GetBusinessForProfessional) {
      final failureOrBusiness = await getBusinessByProfessional(GetProfessionalBusinessParams(professionalId: event.professionalId));
      yield* _eitherLoadedBusinessOrErrorState(failureOrBusiness);
    } else if (event is GetServicesForProfessional) {
      this.state.copyWith(status: ProfessionalStatus.loadingServices, services: []);
      final failureOrServices = await getServicesByProfessional(GetProfessionalServicesParams(professionalBusinessId: event.professionalBusinessId));
      yield* _eitherLoadedServicesOrErrorState(failureOrServices);
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

  Stream<ProfessionalState> _eitherLoadedServicesOrErrorState(
    Either<Failure, List<ProfessionalService>> failureOrServices
  ) async * {
    yield failureOrServices.fold(
      (failure) {
        return this.state.copyWith(status: ProfessionalStatus.error, services: []);
      },
      (services) {
        return this.state.copyWith(status: ProfessionalStatus.readyServices, services: services);
      }
    );
  }

  static ProfessionalBloc of(BuildContext context) {
    return BlocProvider.of<ProfessionalBloc>(context);
  }
}
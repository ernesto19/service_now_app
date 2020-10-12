import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/usecases/get_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/get_industries.dart';
import 'package:service_now/features/professional/domain/usecases/get_services_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/register_business_by_professional.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_event.dart';
import 'package:service_now/features/professional/presentation/bloc/professional_state.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_page.dart';
import 'package:service_now/utils/all_translations.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionalBusinessByProfessional getBusinessByProfessional;
  final GetProfessionalServicesByProfessional getServicesByProfessional;
  final GetIndustries getIndustries;
  final RegisterBusinessByProfessional registerBusinessByProfessional;

  ProfessionalBloc({
    @required GetProfessionalBusinessByProfessional business,
    @required GetProfessionalServicesByProfessional services,
    @required GetIndustries industries,
    @required RegisterBusinessByProfessional registerBusiness
  }) : assert(business != null, services != null),
       getBusinessByProfessional = business,
       getServicesByProfessional = services,
       getIndustries = industries,
       registerBusinessByProfessional = registerBusiness {
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
    } else if (event is GetIndustriesForProfessional) {
      if (this.state.formStatus != RegisterBusinessFormDataStatus.ready) {
        this.state.copyWith(formStatus: RegisterBusinessFormDataStatus.loading, formData: null);
        final failureOrIndustries = await getIndustries(NoParams());
        yield* _eitherLoadedIndustriesOrErrorState(failureOrIndustries);
      }
      
    } else if (event is RegisterBusinessForProfessional) {
      yield* this._registerBusiness(event);
    } else if (event is OnActiveEvent) {
      yield* this._mapOnFavorites(event);
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

  Stream<ProfessionalState> _eitherLoadedIndustriesOrErrorState(
    Either<Failure, IndustryCategory> failureOrIndustries
  ) async * {
    yield failureOrIndustries.fold(
      (failure) {
        return this.state.copyWith(formStatus: RegisterBusinessFormDataStatus.error, formData: null);
      },
      (industriesAndCategories) {
        return this.state.copyWith(formStatus: RegisterBusinessFormDataStatus.ready, formData: industriesAndCategories);
      }
    );
  }

  Stream<ProfessionalState> _registerBusiness(RegisterBusinessForProfessional event) async* {
    showDialog(
      context: event.context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(allTranslations.traslate('register_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.registering);

    final failureOrSuccess = await registerBusinessByProfessional(RegisterBusinessParams(name: event.name, description: event.description, industryId: event.industryId, categoryId: event.categoryId, licenseNumber: event.licenseNumber, jobOffer: event.jobOffer, latitude: event.latitude, longitude: event.longitude, address: event.address, fanpage: event.fanpage));
    yield* _eitherBusinessRegisterOrErrorState(failureOrSuccess);

    if (this.state.registerBusinessStatus == RegisterBusinessStatus.registered) {
      Navigator.pushNamed(event.context, ProfessionalBusinessPage.routeName);
    }
  }

  Stream<ProfessionalState> _eitherBusinessRegisterOrErrorState(
    Either<Failure, RegisterBusinessResponse> failureOrSuccessRegister
  ) async * {
    yield failureOrSuccessRegister.fold(
      (failure) {
        return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.error, registerBusinessResponse: null);
      },
      (response) {
        return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.registered, registerBusinessResponse: response);
      }
    );
  }

  Stream<ProfessionalState> _mapOnFavorites(OnActiveEvent event) async* {
    final int id = event.id;
    final List<ProfessionalBusiness> tmp = List<ProfessionalBusiness>.from(this.state.business);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onActive();
      yield this.state.copyWith(status: ProfessionalStatus.ready, business: tmp);
    }
  }

  static ProfessionalBloc of(BuildContext context) {
    return BlocProvider.of<ProfessionalBloc>(context);
  }
}
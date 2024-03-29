import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/data/responses/response_request_response.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/features/professional/domain/usecases/delete_image_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/get_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/get_create_service_form.dart';
import 'package:service_now/features/professional/domain/usecases/get_industries.dart';
import 'package:service_now/features/professional/domain/usecases/get_services_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/register_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/register_service_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/request_response_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/update_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/update_business_status_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/update_service_by_professional.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/professional_event.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/professional_state.dart';
import 'package:service_now/features/professional/presentation/widgets/animation_fab.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/widgets/success_page.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionalBusinessByProfessional getBusinessByProfessional;
  final GetProfessionalServicesByProfessional getServicesByProfessional;
  final GetIndustries getIndustries;
  final RegisterBusinessByProfessional registerBusinessByProfessional;
  final UpdateBusinessByProfessional updateBusinessByProfessional;
  final GetCreateServiceForm getCreateServiceForm;
  final RegisterServiceByProfessional registerServiceByProfessional;
  final UpdateServiceByProfessional updateServiceByProfessional;
  final UpdateBusinessStatusByProfessional updateBusinessStatus;
  final RequestResponseByProfessional responseRequestByProfessional;
  final DeleteImageByProfessional deleteImageByProfessional;

  ProfessionalBloc({
    @required GetProfessionalBusinessByProfessional business,
    @required GetProfessionalServicesByProfessional services,
    @required GetIndustries industries,
    @required RegisterBusinessByProfessional registerBusiness,
    @required UpdateBusinessByProfessional updateBusiness,
    @required GetCreateServiceForm createServiceForm,
    @required RegisterServiceByProfessional registerService,
    @required UpdateServiceByProfessional updateService,
    @required UpdateBusinessStatusByProfessional updateBusinessStatus,
    @required RequestResponseByProfessional responseRequest,
    @required DeleteImageByProfessional deleteImage
  }) : assert(business != null, services != null),
       getBusinessByProfessional = business,
       getServicesByProfessional = services,
       getIndustries = industries,
       registerBusinessByProfessional = registerBusiness,
       updateBusinessByProfessional = updateBusiness,
       getCreateServiceForm = createServiceForm,
       registerServiceByProfessional = registerService,
       updateServiceByProfessional = updateService,
       updateBusinessStatus = updateBusinessStatus, 
       responseRequestByProfessional = responseRequest,
       deleteImageByProfessional = deleteImage {
    add(GetBusinessForProfessional());
  }

  @override
  ProfessionalState get initialState => ProfessionalState.initialState;

  @override
  Stream<ProfessionalState> mapEventToState(ProfessionalEvent event) async* {
    if (event is GetBusinessForProfessional) {
      final failureOrBusiness = await getBusinessByProfessional(NoParams());
      yield* _eitherLoadedBusinessOrErrorState(failureOrBusiness);
    } else if (event is GetServicesForProfessional) {
      if (this.state.status != ProfessionalStatus.readyServices) {
        this.state.copyWith(status: ProfessionalStatus.loadingServices, services: []);
        final failureOrServices = await getServicesByProfessional(GetProfessionalServicesParams(professionalBusinessId: event.professionalBusinessId));
        yield* _eitherLoadedServicesOrErrorState(failureOrServices);
      }
    } else if (event is GetIndustriesForProfessional) {
      if (this.state.formStatus != RegisterBusinessFormDataStatus.ready) {
        this.state.copyWith(formStatus: RegisterBusinessFormDataStatus.loading, formData: null);
        final failureOrIndustries = await getIndustries(NoParams());
        yield* _eitherLoadedIndustriesOrErrorState(failureOrIndustries);
      }
    } else if (event is RegisterBusinessForProfessional) {
      yield* this._registerBusiness(event);
    } else if (event is UpdateBusinessForProfessional) {
      yield* this._updateBusiness(event);
    } else if (event is GetCreateServiceFormForProfessional) {
      if (this.state.serviceFormStatus != RegisterServiceFormDataStatus.ready) {
        this.state.copyWith(serviceFormStatus: RegisterServiceFormDataStatus.loading, formData: null);
        final failureOrFormData = await getCreateServiceForm(NoParams());
        yield* _eitherLoadedCreateServiceFormOrErrorState(failureOrFormData);
      }
    } else if (event is RegisterServiceForProfessional) {
      yield* this._registerService(event);
    } else if (event is UpdateServiceForProfessional) {
      yield* this._updateService(event);
    } else if (event is OnActiveEvent) {
      yield* this._mapOnActive(event);
    } else if (event is OnSelectedServiceEvent) {
      yield* this._mapOnSelectedService(event);
    } else if (event is RequestResponseForBusiness) {
      final failureOrResponse = await responseRequestByProfessional(ResponseRequestParams(services: event.services, userId: event.userId));
      yield* _eitherResponseRequestOrErrorState(failureOrResponse);
      Navigator.pushNamedAndRemoveUntil(event.context, HomePage.routeName, (Route<dynamic> route) => false);
    } else if (event is DeleteImageForProfessional) {
      yield* this._deleteImage(event);
    }
  }

  Stream<ProfessionalState> _eitherResponseRequestOrErrorState(
    Either<Failure, ResponseRequestResponse> failureOrSuccess
  ) async * {
    yield failureOrSuccess.fold(
      (failure) {
        return this.state.copyWith(status: ProfessionalStatus.error);
      },
      (response) {
        return this.state.copyWith(status: ProfessionalStatus.ready);
      }
    );
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

    final failureOrSuccess = await registerBusinessByProfessional(RegisterBusinessParams(name: event.name, description: event.description, industryId: event.industryId, categoryId: event.categoryId, licenseNumber: event.licenseNumber, jobOffer: event.jobOffer, latitude: event.latitude, longitude: event.longitude, address: event.address, fanpage: event.fanpage, phone: event.phone, images: event.images));
    yield* _eitherBusinessRegisterOrErrorState(failureOrSuccess);

    if (this.state.registerBusinessStatus == RegisterBusinessStatus.registered) {
      Navigator.of(event.context).pop();
      Navigator.of(event.context).push(FadeRouteBuilder(page: SuccessPage(message: 'El negocio ${event.name} fue registrado exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
    } else if (this.state.registerBusinessStatus == RegisterBusinessStatus.error) {
      Navigator.pop(event.context);
      this._showDialog('Importante', this.state.errorMessage, event.context);
    }
  }

  Stream<ProfessionalState> _updateBusiness(UpdateBusinessForProfessional event) async* {
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
                  child: Text(allTranslations.traslate('updating_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.registering);

    final failureOrSuccess = await updateBusinessByProfessional(UpdateBusinessParams(businessId: event.businessId, name: event.name, description: event.description, industryId: event.industryId, categoryId: event.categoryId, licenseNumber: event.licenseNumber, jobOffer: event.jobOffer, latitude: event.latitude, longitude: event.longitude, address: event.address, fanpage: event.fanpage, phone: event.phone));
    yield* _eitherBusinessRegisterOrErrorState(failureOrSuccess);

    if (this.state.registerBusinessStatus == RegisterBusinessStatus.registered) {
      Navigator.of(event.context).pop();
      Navigator.of(event.context).push(FadeRouteBuilder(page: SuccessPage(message: 'El negocio ${event.name} fue actualizado exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
    } else if (this.state.registerBusinessStatus == RegisterBusinessStatus.error) {
      Navigator.pop(event.context);
      this._showDialog('Importante', this.state.errorMessage, event.context);
    }
  }

  Stream<ProfessionalState> _eitherBusinessRegisterOrErrorState(
    Either<Failure, RegisterBusinessResponse> failureOrSuccessRegister
  ) async * {
    yield failureOrSuccessRegister.fold(
      (failure) {
        return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.error);
      },
      (response) {
        if (response.error == 0) {
          return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.registered, registerBusinessResponse: response);
        } else if (response.error == 2) {
          String description = response.validation[0]['description'] != null ? response.validation[0]['description'][0] + '\n' : '';
          String address = response.validation[0]['address'] != null ? response.validation[0]['address'][0] : '';
          String message = description + address;
          return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.error, errorMessage: message);
        } else {
          return this.state.copyWith(registerBusinessStatus: RegisterBusinessStatus.error, errorMessage: response.message);
        }
      }
    );
  }

  Stream<ProfessionalState> _eitherLoadedCreateServiceFormOrErrorState(
    Either<Failure, CreateServiceForm> failureOrCreateServiceForm
  ) async * {
    yield failureOrCreateServiceForm.fold(
      (failure) {
        return this.state.copyWith(serviceFormStatus: RegisterServiceFormDataStatus.error, serviceFormData: null);
      },
      (formData) {
        return this.state.copyWith(serviceFormStatus: RegisterServiceFormDataStatus.ready, serviceFormData: formData);
      }
    );
  }

  Stream<ProfessionalState> _registerService(RegisterServiceForProfessional event) async* {
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

    yield this.state.copyWith(registerServiceStatus: RegisterServiceStatus.registering);

    final failureOrSuccess = await registerServiceByProfessional(RegisterServiceParams(businessId: event.businessId, serviceId: event.serviceId, price: event.price, images: event.images));
    yield* _eitherServiceRegisterOrErrorState(failureOrSuccess);

    if (this.state.registerServiceStatus == RegisterServiceStatus.registered) {
      Navigator.of(event.context).pop();
      Navigator.of(event.context).push(FadeRouteBuilder(page: SuccessPage(message: 'El servicio fue registrado exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
    }
  }

  Stream<ProfessionalState> _updateService(UpdateServiceForProfessional event) async* {
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
                  child: Text(allTranslations.traslate('updating_message'), style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(registerServiceStatus: RegisterServiceStatus.registering);

    final failureOrSuccess = await updateServiceByProfessional(UpdateServiceParams(id: event.id, price: event.price));
    yield* _eitherServiceRegisterOrErrorState(failureOrSuccess);

    if (this.state.registerServiceStatus == RegisterServiceStatus.registered) {
      Navigator.of(event.context).pop();
      Navigator.of(event.context).push(FadeRouteBuilder(page: SuccessPage(message: 'El servicio fue actualizado exitosamente.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
    }
  }

  Stream<ProfessionalState> _eitherServiceRegisterOrErrorState(
    Either<Failure, RegisterServiceResponse> failureOrSuccessRegister
  ) async * {
    yield failureOrSuccessRegister.fold(
      (failure) {
        return this.state.copyWith(registerServiceStatus: RegisterServiceStatus.error, registerServiceResponse: null);
      },
      (response) {
        return this.state.copyWith(registerServiceStatus: RegisterServiceStatus.registered, registerServiceResponse: response);
      }
    );
  }

  Stream<ProfessionalState> _mapOnActive(OnActiveEvent event) async* {
    final int id = event.id;
    final List<ProfessionalBusiness> tmp = List<ProfessionalBusiness>.from(this.state.business);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onActive();
      updateBusinessStatus(UpdateBusinessStatusParams(business: tmp[index]));
      yield this.state.copyWith(status: ProfessionalStatus.ready, business: tmp);
    }
  }

  Stream<ProfessionalState> _mapOnSelectedService(OnSelectedServiceEvent event) async* {
    final int id = event.id;
    final List<ProfessionalService> tmp = List<ProfessionalService>.from(this.state.services);
    final int index = tmp.indexWhere((element) => element.id == id);
    if (index != -1) {
      tmp[index] = tmp[index].onSelected();
      yield this.state.copyWith(status: ProfessionalStatus.readyServices, services: tmp);
    }
  }

  Stream<ProfessionalState> _deleteImage(DeleteImageForProfessional event) async* {
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
                  child: Text('Eliminando ...', style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(galleryStatus: GalleryStatus.deleting);

    final failureOrSuccess = await deleteImageByProfessional(DeleteParams(id: event.id));
    yield* _eitherDeleteImageOrErrorState(failureOrSuccess, event);

    if (this.state.galleryStatus == GalleryStatus.ready) {
      Navigator.pop(event.context);
      this._showDialog('Eliminación exitosa', this.state.deleteResponse.message, event.context);
    }
  }

  Stream<ProfessionalState> _eitherDeleteImageOrErrorState(
    Either<Failure, DeleteImageResponse> failureOrSuccessDelete, DeleteImageForProfessional event
  ) async * {
    yield failureOrSuccessDelete.fold(
      (failure) {
        return this.state.copyWith(galleryStatus: GalleryStatus.error, deleteResponse: null);
      },
      (response) {
        // List<ProfessionalBusiness> businessTemp = List<ProfessionalBusiness>.from(this.state.business);
        // final int index = businessTemp.indexWhere((element) => element.id == event.businessId);
        // if (index != -1) {
        //   businessTemp[index] = businessTemp[index].onDeleteImage();
        // }

        return this.state.copyWith(galleryStatus: GalleryStatus.ready, deleteResponse: response/*, status: ProfessionalStatus.ready, business: businessTemp*/);
      }
    );
  }

  void _showDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.0),),
          actions: <Widget>[
            FlatButton(
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );
  }

  static ProfessionalBloc of(BuildContext context) {
    return BlocProvider.of<ProfessionalBloc>(context);
  }
}
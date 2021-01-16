import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/features/professional/domain/entities/professional_service.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/models/promotion.dart';
import 'package:service_now/resources/repository.dart';

class ProfessionalUserBloc {
  final _repository = Repository();
  final _professionalBusinessFetcher = PublishSubject<ProfessionalBusinessResponse>();
  final _professionalBusinessGalleryFetcher = PublishSubject<GalleryResponse>();
  final _professionalServiceGalleryFetcher = PublishSubject<GalleryResponse>();
  final _businessImageDelete = PublishSubject<ProfessionalCRUDResponse>();
  final _serviceImageDelete = PublishSubject<ProfessionalCRUDResponse>();
  final _businessStatusUpdate = PublishSubject<void>();
  final _businessProfessionalStatusUpdate = PublishSubject<void>();
  final _promotionRegister = PublishSubject<ProfessionalCRUDResponse>();
  final _promotionsFetcher = PublishSubject<PromotionResponse>();
  final _promotionStatusUpdate = PublishSubject<void>();
  final _solicitudesFetcher = PublishSubject<RequestResponse>();
  final _aprobarSolicitud = PublishSubject<void>();
  final _denegarSolicitud = PublishSubject<void>();
  final _respuestaSolicitud = PublishSubject<ProfessionalCRUDResponse>();
  final _serviciosPendientesFetcher = PublishSubject<ServiciosPendientesResponse>();
  final _iniciarServicio = PublishSubject<void>();
  final _terminarServicio = PublishSubject<void>();
  final _agregarImagenNegocio = PublishSubject<ProfessionalCRUDResponse>();
  final _agregarImagenServicio = PublishSubject<ProfessionalCRUDResponse>();

  Observable<ProfessionalBusinessResponse> get allProfessionalBusiness => _professionalBusinessFetcher.stream;
  Observable<GalleryResponse> get allProfessionalBusinessGallery => _professionalBusinessGalleryFetcher.stream;
  Observable<GalleryResponse> get allProfessionalServiceGallery => _professionalServiceGalleryFetcher.stream;
  Observable<ProfessionalCRUDResponse> get businessImageDeleteResponse => _businessImageDelete.stream;
  Observable<ProfessionalCRUDResponse> get serviceImageDeleteResponse => _serviceImageDelete.stream;
  Observable<void> get businessStatusUpdateResponse => _businessStatusUpdate.stream;
  Observable<void> get businessProfessionalStatusUpdateResponse => _businessProfessionalStatusUpdate.stream;
  Observable<ProfessionalCRUDResponse> get promotionRegisterResponse => _promotionRegister.stream;
  Observable<PromotionResponse> get allPromotions => _promotionsFetcher.stream;
  Observable<void> get promotionStatusUpdateResponse => _promotionStatusUpdate.stream;
  Observable<RequestResponse> get solicitudes => _solicitudesFetcher.stream;
  Observable<void> get aprobarSolicitudResponse => _aprobarSolicitud.stream;
  Observable<void> get denegarSolicitudResponse => _denegarSolicitud.stream;
  Observable<ProfessionalCRUDResponse> get respuestaSolicitudResponse => _respuestaSolicitud.stream;
  Observable<ServiciosPendientesResponse> get allServiciosPendientes => _serviciosPendientesFetcher.stream;
  Observable<void> get iniciarServicioResponse => _iniciarServicio.stream;
  Observable<void> get terminarServicioResponse => _terminarServicio.stream;
  Observable<ProfessionalCRUDResponse> get agregarImagenNegocioResponse => _agregarImagenNegocio.stream;
  Observable<ProfessionalCRUDResponse> get agregarImagenServicioResponse => _agregarImagenServicio.stream;

  Future fetchProfessionalBusiness() async {
    ProfessionalBusinessResponse response = await _repository.fetchProfessionalBusiness();
    _professionalBusinessFetcher.sink.add(response);
  }

  Future fetchProfessionalBusinessGallery(int id) async {
    GalleryResponse response = await _repository.fetchProfessionalBusinessGallery(id);
    _professionalBusinessGalleryFetcher.sink.add(response);
  }

  Future fetchProfessionalServiceGallery(int id) async {
    GalleryResponse response = await _repository.fetchProfessionalServiceGallery(id);
    _professionalServiceGalleryFetcher.sink.add(response);
  }

  Future deleteBusinessImage(int id) async {
    ProfessionalCRUDResponse response = await _repository.deleteBusinessImage(id);
    _businessImageDelete.sink.add(response);
  }

  Future deleteServiceImage(int id) async {
    ProfessionalCRUDResponse response = await _repository.deleteServiceImage(id);
    _serviceImageDelete.sink.add(response);
  }

  Future updateBusinessStatus(int id) async {
    _businessStatusUpdate.add(await _repository.updateBusinessStatus(id));
  }

  Future updateBusinessProfessionalStatus(int id, int estado) async {
    _businessProfessionalStatusUpdate.add(await _repository.updateBusinessProfessionalStatus(id, estado));
  }

  Future registerPromotion(String name, String description, var amount, String type, int businessId) async {
    ProfessionalCRUDResponse response = await _repository.registerPromotion(name, description, amount, type, businessId);
    _promotionRegister.sink.add(response);
  }

  Future fetchPromotions(int id) async {
    PromotionResponse response = await _repository.fetchPromotions(id);
    _promotionsFetcher.sink.add(response);
  }

  Future updatePromotionStatus(int id, int status) async {
    _promotionStatusUpdate.add(await _repository.updatePromotionStatus(id, status));
  }

  Future obtenerBandejaSolicitudes(int businessId) async {
    RequestResponse response = await _repository.obtenerBandejaSolicitudes(businessId);
    _solicitudesFetcher.sink.add(response);
  }

  Future aprobarSolicitud(int id) async {
    _aprobarSolicitud.add(await _repository.aprobarSolicitud(id));
  }

  Future denegarSolicitud(int id) async {
    _denegarSolicitud.add(await _repository.denegarSolicitud(id));
  }

  Future responderSolicitudServicio(List<ProfessionalService> services, int userId) async {
    ProfessionalCRUDResponse response = await _repository.responderSolicitudServicio(services, userId);
    _respuestaSolicitud.sink.add(response);
  }

  Future obtenerBandejaServiciosPendientes() async {
    ServiciosPendientesResponse response = await _repository.obtenerBandejaServiciosPendientes();
    _serviciosPendientesFetcher.sink.add(response);
  }

  Future iniciarServicio(int id) async {
    _iniciarServicio.add(await _repository.iniciarServicio(id));
  }

  Future terminarServicio(int id) async {
    _terminarServicio.add(await _repository.terminarServicio(id));
  }

  Future agregarImagenesNegocio(int id, List<Asset> images) async {
    ProfessionalCRUDResponse response = await _repository.agregarImagenesNegocio(id, images);
    _agregarImagenNegocio.sink.add(response);
  }

  Future agregarImagenesServicio(int id, List<Asset> images) async {
    ProfessionalCRUDResponse response = await _repository.agregarImagenesServicio(id, images);
    _agregarImagenServicio.sink.add(response);
  }

  dispose() {
    _professionalBusinessFetcher.close();
    _professionalBusinessGalleryFetcher.close();
    _professionalServiceGalleryFetcher.close();
    _businessImageDelete.close();
    _serviceImageDelete.close();
    _businessStatusUpdate.close();
    _businessProfessionalStatusUpdate.close();
    _promotionRegister.close();
    _promotionsFetcher.close();
    _promotionStatusUpdate.close();
    _solicitudesFetcher.close();
    _aprobarSolicitud.close();
    _denegarSolicitud.close();
    _respuestaSolicitud.close();
    _serviciosPendientesFetcher.close();
    _iniciarServicio.close();
    _terminarServicio.close();
    _agregarImagenNegocio.close();
    _agregarImagenServicio.close();
  }
}

final bloc = ProfessionalUserBloc();
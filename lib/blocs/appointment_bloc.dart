import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/resources/repository.dart';

class AppointmentServicesBloc {
  final _repository = Repository();
  final _solicitudColaboracion = PublishSubject<AppointmentCRUDResponse>();
  final _profesionalesFetcher = PublishSubject<ProfessionalResponse>();
  final _profesionalFetcher = PublishSubject<ProfessionalDetailResponse>();
  final _solicitudServicio = PublishSubject<AppointmentCRUDResponse>();
  final _finalizarServicio = PublishSubject<AppointmentCRUDResponse>();
  final _enviarCalificacion = PublishSubject<AppointmentCRUDResponse>();

  Observable<AppointmentCRUDResponse> get solicitudColaboracionResponse => _solicitudColaboracion.stream;
  Observable<ProfessionalResponse> get profesionales => _profesionalesFetcher.stream;
  Observable<ProfessionalDetailResponse> get profesional => _profesionalFetcher.stream;
  Observable<AppointmentCRUDResponse> get solicitudServicioResponse => _solicitudServicio.stream;
  Observable<AppointmentCRUDResponse> get finalizarServicioResponse => _finalizarServicio.stream;
  Observable<AppointmentCRUDResponse> get enviarCalificacionResponse => _enviarCalificacion.stream;

  Future solicitarColaboracion(int businessId) async {
    AppointmentCRUDResponse response = await _repository.solicitarColaboracion(businessId);
    _solicitudColaboracion.sink.add(response);
  }

  Future obtenerProfesionalesPorNegocio(int businessId) async {
    ProfessionalResponse response = await _repository.obtenerProfesionalesPorNegocio(businessId);
    _profesionalesFetcher.sink.add(response);
  }

  Future obtenerPerfilProfesional(int id) async {
    ProfessionalDetailResponse response = await _repository.obtenerPerfilProfesional(id);
    _profesionalFetcher.sink.add(response);
  }

  Future solicitarServicio(int businessId, int professionalId) async {
    AppointmentCRUDResponse response = await _repository.solicitarServicio(businessId, professionalId);
    _solicitudServicio.sink.add(response);
  }

  Future finalizarSolicitud(List<Service> services, int professionalId) async {
    AppointmentCRUDResponse response = await _repository.finalizarSolicitud(services, professionalId);
    _finalizarServicio.sink.add(response);
  }

  Future enviarCalificacion(int id, String comentario, double calificacion) async {
    AppointmentCRUDResponse response = await _repository.enviarCalificacion(id, comentario, calificacion);
    _enviarCalificacion.sink.add(response);
  }

  dispose() {
    _solicitudColaboracion.close();
    _profesionalesFetcher.close();
    _profesionalFetcher.close();
    _solicitudServicio.close();
    _finalizarServicio.close();
    _enviarCalificacion.close();
  }
}

final bloc = AppointmentServicesBloc();
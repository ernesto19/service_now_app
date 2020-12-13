import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/models/appointment.dart';
import 'package:service_now/resources/repository.dart';

class AppointmentServicesBloc {
  final _repository = Repository();
  final _solicitudColaboracion = PublishSubject<AppointmentCRUDResponse>();

  Observable<AppointmentCRUDResponse> get solicitudColaboracionResponse => _solicitudColaboracion.stream;

  Future solicitarColaboracion(int businessId) async {
    AppointmentCRUDResponse response = await _repository.solicitarColaboracion(businessId);
    _solicitudColaboracion.sink.add(response);
  }

  dispose() {
    _solicitudColaboracion.close();
  }
}

final bloc = AppointmentServicesBloc();
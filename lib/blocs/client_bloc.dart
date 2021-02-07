import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:service_now/models/professional_business.dart';
import 'package:service_now/resources/repository.dart';

class ClientBloc {
  final _repository = Repository();
  final _serviciosFetcher = PublishSubject<ServiciosPendientesResponse>();

  Observable<ServiciosPendientesResponse> get allServicios => _serviciosFetcher.stream;

  Future obtenerBandejaServicios() async {
    ServiciosPendientesResponse response = await _repository.obtenerBandejaServicios();
    _serviciosFetcher.sink.add(response);
  }

  dispose() {
    _serviciosFetcher.close();
  }
}

final bloc = ClientBloc();
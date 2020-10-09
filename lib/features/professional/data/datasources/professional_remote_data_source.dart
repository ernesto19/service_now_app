import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/features/professional/data/models/professional_business_model.dart';
import 'package:service_now/features/professional/data/models/professional_service_model.dart';
import 'package:service_now/features/professional/data/requests/get_professional_business_request.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';

abstract class ProfessionalRemoteDataSource {
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request);
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request);
}

class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final http.Client client;

  ProfessionalRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request) => _getProfessionalBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business/nearest_business');

  @override
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request) => _getProfessionalServicesFromUrl(request, '');

  Future<List<ProfessionalBusinessModel>> _getProfessionalBusinessFromUrl(GetProfessionalBusinessRequest request, String url) async {
    List<ProfessionalBusinessModel> listaBusiness = List();
    listaBusiness.add(ProfessionalBusinessModel(id: 1, name: 'Negocio 1', description: 'descripcion', address: ''));
    listaBusiness.add(ProfessionalBusinessModel(id: 2, name: 'Negocio 2', description: 'descripcion', address: ''));

    return listaBusiness;
  }

  Future<List<ProfessionalServiceModel>> _getProfessionalServicesFromUrl(GetProfessionalServicesRequest request, String url) async {
    List<ProfessionalServiceModel> listaServices = List();
    listaServices.add(ProfessionalServiceModel(id: 1, name: 'Servicio 1', description: 'descripcion'));
    listaServices.add(ProfessionalServiceModel(id: 2, name: 'Servicio 2', description: 'descripcion'));
    listaServices.add(ProfessionalServiceModel(id: 1, name: 'Servicio 3', description: 'descripcion'));
    listaServices.add(ProfessionalServiceModel(id: 2, name: 'Servicio 4', description: 'descripcion'));

    return listaServices;
  }
}
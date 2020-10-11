import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:service_now/core/error/exceptions.dart';
import 'package:service_now/features/professional/data/models/professional_business_model.dart';
import 'package:service_now/features/professional/data/models/professional_service_model.dart';
import 'package:service_now/features/professional/data/requests/get_professional_business_request.dart';
import 'package:service_now/features/professional/data/requests/get_professional_services_request.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/preferences/user_preferences.dart';

abstract class ProfessionalRemoteDataSource {
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request);
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request);
  Future<IndustryCategory> getIndustries();
  Future<RegisterBusinessResponse> registerBusiness();
}

class ProfessionalRemoteDataSourceImpl implements ProfessionalRemoteDataSource {
  final http.Client client;

  ProfessionalRemoteDataSourceImpl({ @required this.client });

  @override
  Future<List<ProfessionalBusinessModel>> getProfessionalBusiness(GetProfessionalBusinessRequest request) => _getProfessionalBusinessFromUrl(request, 'https://test.konxulto.com/service_now/public/api/business/nearest_business');

  @override
  Future<List<ProfessionalServiceModel>> getProfessionalServices(GetProfessionalServicesRequest request) => _getProfessionalServicesFromUrl(request, '');

  @override
  Future<IndustryCategory> getIndustries() => _getIndustriesFromUrl('https://test.konxulto.com/service_now/public/api/business/industries_categories');

  @override
  Future<RegisterBusinessResponse> registerBusiness() {
    // TODO: implement registerBusiness
    throw UnimplementedError();
  }

  Future<List<ProfessionalBusinessModel>> _getProfessionalBusinessFromUrl(GetProfessionalBusinessRequest request, String url) async {
    List<ProfessionalBusinessModel> listaBusiness = List();
    listaBusiness.add(ProfessionalBusinessModel(id: 1, name: 'Negocio 1', description: 'descripcion', categoryId: 1, categoryName: 'Barbershop', address: 'Av. Derby 256', licenseNumber: '987654321', fanpage: '', logo: '', latitude: '', longitude: '', active: 1));
    listaBusiness.add(ProfessionalBusinessModel(id: 2, name: 'Negocio 2', description: 'descripcion', categoryId: 1, categoryName: 'Salón de belleza', address: 'Av. Derby 256', licenseNumber: '123456789', fanpage: '', logo: '', latitude: '', longitude: '', active: 0));

    return listaBusiness;
  }

  Future<List<ProfessionalServiceModel>> _getProfessionalServicesFromUrl(GetProfessionalServicesRequest request, String url) async {
    List<ProfessionalServiceModel> listaServices = List();
    listaServices.add(ProfessionalServiceModel(id: 1, name: 'Servicio 1', description: 'descripcion', industryId: 1, industryName: '', industryTypeId: 1, industryTypeName: '', subServices: []));
    listaServices.add(ProfessionalServiceModel(id: 2, name: 'Servicio 2', description: 'descripcion', industryId: 1, industryName: '', industryTypeId: 1, industryTypeName: '', subServices: []));
    listaServices.add(ProfessionalServiceModel(id: 1, name: 'Servicio 3', description: 'descripcion', industryId: 1, industryName: '', industryTypeId: 1, industryTypeName: '', subServices: []));
    listaServices.add(ProfessionalServiceModel(id: 2, name: 'Servicio 4', description: 'descripcion', industryId: 1, industryName: '', industryTypeId: 1, industryTypeName: '', subServices: []));

    return listaServices;
  }

  Future<IndustryCategory> _getIndustriesFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer ${UserPreferences.instance.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final body = GetIndustriesResponse.fromJson(json.decode(response.body));
      return body.data;
    } else {
      throw ServerException();
    }
  }

  Future<RegisterBusinessResponse> _registerBusinessFromUrl(File logo, String url) async {
    // final url = Uri.parse('${ApiBaseHelper().baseUrl}loan_file_update?id=${model.id.toString()}&user_id=${model.userId.toString()}&comments=${model.comments ?? ''}&fee=${model.quotas.toString()}&amount=${model.amount.toString()}&loan_reasons=${model.reasonId.toString()}&loan_discount_period=${model.discountPeriod}&equivalent_loan_reasons=${model.equivalentId.toString()}&cambio_imagen=$cambioImagen');
    final url = Uri.parse('uri');

    var mimeType;
    final imageUploadRequest = http.MultipartRequest('POST', url);

    if (logo != null ) {
      mimeType = mime(logo.path).split('/');
      final file = await http.MultipartFile.fromPath('attachment', logo.path, contentType: MediaType(mimeType[0], mimeType[1]));
      imageUploadRequest.files.add(file);
    }

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    return RegisterBusinessResponse.fromJson(json.decode(resp.body));
  }
}
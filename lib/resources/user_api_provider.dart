import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/core/helpers/api_base_helper.dart';
import 'package:service_now/models/user.dart';
import 'package:service_now/preferences/user_preferences.dart';

class UserApiProvider {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProfileResponse> fetchProfile(int id) async {
    final response = await _helper.get('professional/profile/get?user_id=$id');
    return ProfileResponse.fromJson(response);
  }

  Future<UserCRUDResponse> registerProfessionalProfile(String phone, String resume, String facebook, String linkedin) async {
    final response = await _helper.post(
      'professional/profile/create', 
      {
        'phone': phone,
        'resume': resume,
        'facebook_page': facebook,
        'linkedin': linkedin
      }
    );
    return UserCRUDResponse.fromJson(response);
  }

  Future<UserCRUDResponse> registerProfessionalAptitude(String title, String description, int professionalId, List<Asset> images) async {
    final uri = Uri.parse('https://test.konxulto.com/service_now_desa/public/api/professional/aptitude/create' 
      + '?'
      + 'title=$title&'
      + 'description=$description&'
      + 'professional_profile_id=$professionalId');

    Map<String, String> headers = {
      'Authorization': 'Bearer ${UserPreferences.instance.token}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final multipartRequest = http.MultipartRequest('POST', uri);
    multipartRequest.headers.addAll(headers);

    if (images != null ) {
      for (int i = 0; i < images.length; i++) {
        Asset asset = images[i];
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        final multipartFile = http.MultipartFile.fromBytes(
          'files[]',
          imageData,
          filename: 'name.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipartRequest.files.add(multipartFile);
      }
    }

    final streamResponse = await multipartRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    return UserCRUDResponse.fromJson(json.decode(resp.body));
  }

  Future<AptitudeResponse> fetchAptitudes(int id) async {
    final response = await _helper.get('professional/aptitude/get?professional_profile_id=$id');
    return AptitudeResponse.fromJson(response);
  }

  Future<ConditionsResponse> fetchConditions() async {
    final response = await _helper.get('business/get_terms');
    return ConditionsResponse.fromJson(response);
  }
}
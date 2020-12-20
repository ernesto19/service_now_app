class AppointmentCRUDResponse {
  int error;
  String message;

  AppointmentCRUDResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}

class ProfessionalNegocio {
  int id;
  int userId;
  int profileId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String resume;
  String facebook;
  String linkedin;
  String status;
  List<AptitudProfesional> aptitudes = List();

  ProfessionalNegocio.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id        = json['id'] ?? 0;
    userId    = json['user_id'];
    profileId = json['profile_id'] ?? 0;
    firstName = json['first_name']  ?? '';
    lastName  = json['last_name']   ?? '';
    email     = json['email']  ?? '';
    phone     = json['phone']  ?? '';
    resume    = json['resume']  ?? '';
    facebook  = json['facebook_page']  ?? '';
    linkedin  = json['linkedin']  ?? '';
    status    = json['status']  ?? '';

    if (json['aptitudes'] != null) {
      for (var item in json['aptitudes']) {
        final galeria = AptitudProfesional.fromJson(item);
        aptitudes.add(galeria);
      }
    }
  }
}

class AptitudProfesional {
  int id;
  String title;
  String description;
  List<AptitudGaleria> galeria = List();

  AptitudProfesional.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id          = json['id'];
    title       = json['title']       ?? '';
    description = json['description'] ?? '';

    for (var item in json['gallery']) {
      final image = AptitudGaleria.fromJson(item);
      galeria.add(image);
    }
  }
}

class AptitudGaleria {
  int id;
  String url;

  AptitudGaleria.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id  = json['id'];
    url = json['url'] != null ? 'https://archivosprestape.s3.amazonaws.com/' + json['url'] : '';
  }
}

class ProfessionalResponse {
  int error;
  String message;
  List<ProfessionalNegocio> data = List();

  ProfessionalResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final professional = ProfessionalNegocio.fromJson(item);
        data.add(professional);
      }
    }
  }
}

class ProfessionalDetailResponse {
  int error;
  String message;
  ProfessionalNegocio data;

  ProfessionalDetailResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = ProfessionalNegocio.fromJson(json['data']);
  }
}
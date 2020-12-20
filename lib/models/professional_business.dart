class ProfessionalBusiness {
  int id;
  String name;
  String description;
  int categoryId;
  String categoryName;
  int industryId;
  String address;
  String licenseNumber;
  String fanpage;
  String phone;
  String logo;
  String latitude;
  String longitude;
  int active;
  int professionalActive;
  int owner;
  List<Picture> gallery = List();

  ProfessionalBusiness({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.categoryName,
    this.industryId,
    this.address,
    this.licenseNumber,
    this.fanpage,
    this.phone,
    this.longitude,
    this.latitude,
    this.active,
    this.professionalActive,
    this.owner
  });

  ProfessionalBusiness.fromJson(Map<String, dynamic> json) {
    id            = json['id'];
    name          = json['name']            ?? '';
    description   = json['description']     ?? '';
    categoryId    = json['category_id']     ?? 0;
    categoryName  = json['category_name']   ?? '';
    industryId    = json['industry_id']     ?? 0;
    address       = json['address']         ?? '';
    licenseNumber = json['license']         ?? '';
    fanpage       = json['fanpage']         ?? '';
    logo          = json['logo']            ?? '';
    phone         = json['phone']           ?? '';
    latitude      = json['lat'].toString()  ?? '';
    longitude     = json['lng'].toString()  ?? '';
    active        = json['active']          ?? 0;
    professionalActive = json['professional_active'] ?? 0;
    owner         = json['owner']           ?? 0;

    for (var item in json['gallery']) {
      final image = Picture.fromJson(item);
      gallery.add(image);
    }
  }
}

class Picture {
  int id;
  String url;

  Picture.fromJson(dynamic json) {
    id  = json['id'];
    url = 'https://archivosprestape.s3.amazonaws.com/' + json['url'];
  }
}

class ProfessionalBusinessResponse {
  int error;
  String message;
  List<ProfessionalBusiness> data = List();

  ProfessionalBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final business = ProfessionalBusiness.fromJson(item);
        data.add(business);
      }
    }
  }
}

class GalleryResponse {
  int error;
  String message;
  List<Picture> data = List();

  GalleryResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final image = Picture.fromJson(item);
        data.add(image);
      }
    }
  }
}

class ProfessionalCRUDResponse {
  int error;
  String message;

  ProfessionalCRUDResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}

class Request {
  int id;
  int userId;
  String firstName;
  String lastName;
  String email;

  Request.fromJson(dynamic json) {
    id        = json['request_id'];
    userId    = json['professional_user_id'];
    firstName = json['first_name'] ?? '';
    lastName  = json['last_name'] ?? '';
    email     = json['email'] ?? '';
  }
}

class RequestResponse {
  int error;
  String message;
  List<Request> data = List();

  RequestResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final request = Request.fromJson(item);
        data.add(request);
      }
    }
  }
}

class ServicioPendiente {
  int id;
  String firstName;
  String lastName;
  String businessName;
  String servicesName;
  String total;
  int status;

  ServicioPendiente({
    this.id,
    this.firstName,
    this.lastName,
    this.businessName,
    this.servicesName,
    this.total,
    this.status
  });

  ServicioPendiente.fromJson(dynamic json) {
    id        = json['request_id'];
    firstName = json['first_name']  ?? '';
    lastName  = json['last_name']   ?? '';
    businessName = json['business_name'] ?? '';
    servicesName = json['services_name'] ?? '';
    total     = json['total']       ?? '';
    status    = json['status']      ?? 0;
  }
}

class ServiciosPendientesResponse {
  int error;
  String message;
  List<ServicioPendiente> data = List();

  ServiciosPendientesResponse({
    this.error,
    this.message,
    this.data
  });

  ServiciosPendientesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final servicio = ServicioPendiente.fromJson(item);
        data.add(servicio);
      }
    }
  }
}
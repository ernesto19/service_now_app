class UserCRUDResponse {
  int error;
  String message;
  UserProfile data;
  var validation;

  UserCRUDResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = UserProfile.fromJson(json['data']);
    } else if (error == 2) {
      validation = json['data'];
    }
  }
}

class UserProfile {
  int id;
  String resume;
  String facebookPage;
  String linkedin;
  String phone;
  int userId;

  UserProfile.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id            = json['id'];
    resume        = json['resume']        ?? '';
    facebookPage  = json['facebook_page'] ?? '';
    linkedin      = json['linkedin']      ?? '';
    phone         = json['phone']         ?? '';
    userId        = json['user_id']       ?? 0;
  }
}

class ProfileResponse {
  int error;
  String message;
  UserProfile data;

  ProfileResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      data = json['data'] != null ? UserProfile.fromJson(json['data']) : null;
    }
  }
}

class Aptitude {
  int id;
  String title;
  String description;
  List<Gallery> gallery = List();

  Aptitude.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id          = json['id'];
    title       = json['title']       ?? '';
    description = json['description'] ?? '';

    for (var item in json['gallery']) {
      final image = Gallery.fromJson(item);
      gallery.add(image);
    }
  }
}

class Gallery {
  int id;
  String url;

  Gallery.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id  = json['id'];
    url = json['url'] != null ? 'https://archivosprestape.s3.amazonaws.com/' + json['url'] : '';
  }
}

class AptitudeResponse {
  int error;
  String message;
  List<Aptitude> data = List();

  AptitudeResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final aptitude = Aptitude.fromJson(item);
        data.add(aptitude);
      }
    }
  }
}

class Condition {
  int id;
  String content;
  int order;

  Condition.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    id      = json['id'];
    content = json['text']       ?? '';
    order   = json['item_order'] ?? 0;
  }
}

class ConditionsResponse {
  int error;
  String message;
  List<Condition> data = List();

  ConditionsResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final condition = Condition.fromJson(item);
        data.add(condition);
      }
    }
  }
}
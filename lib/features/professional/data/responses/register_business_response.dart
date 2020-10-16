class RegisterBusinessResponse {
  int error;
  String message;
  var data;

  RegisterBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
    data    = json['data'];
  }
}
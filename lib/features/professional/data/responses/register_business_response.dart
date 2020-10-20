class RegisterBusinessResponse {
  int error;
  String message;
  var validation;

  RegisterBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error       = json['error'];
    message     = json['message'];
    validation  = json['data'];
  }
}
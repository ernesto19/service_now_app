class RegisterBusinessResponse {
  int error;
  String message;

  RegisterBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
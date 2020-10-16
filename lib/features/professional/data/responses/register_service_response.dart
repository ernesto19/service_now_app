class RegisterServiceResponse {
  int error;
  String message;

  RegisterServiceResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
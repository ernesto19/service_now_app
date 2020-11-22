class ResponseRequestResponse {
  int error;
  String message;

  ResponseRequestResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
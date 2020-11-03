class RequestBusinessResponse {
  int error;
  String message;

  RequestBusinessResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
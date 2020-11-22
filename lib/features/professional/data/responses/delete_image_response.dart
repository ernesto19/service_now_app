class DeleteImageResponse {
  int error;
  String message;

  DeleteImageResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
class AppointmentCRUDResponse {
  int error;
  String message;

  AppointmentCRUDResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
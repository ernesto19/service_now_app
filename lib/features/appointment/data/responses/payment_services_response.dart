class PaymentServicesResponse {
  int error;
  String message;

  PaymentServicesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];
  }
}
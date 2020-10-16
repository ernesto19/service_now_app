import 'package:meta/meta.dart';

class RegisterServiceRequest {
  const RegisterServiceRequest({ @required this.businessId, @required this.serviceId, @required this.price });

  final int businessId;
  final int serviceId;
  final double price;

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId,
      'service': [
        {
          'id': serviceId,
          'price': price
        }
      ]
    };
  }
}
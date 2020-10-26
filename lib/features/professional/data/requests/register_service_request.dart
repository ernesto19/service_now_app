import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class RegisterServiceRequest {
  const RegisterServiceRequest({ @required this.businessId, @required this.serviceId, @required this.price, @required this.images });

  final int businessId;
  final int serviceId;
  final double price;
  final List<Asset> images;

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
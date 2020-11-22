import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class RegisterServiceRequest {
  const RegisterServiceRequest({ this.professionalServiceId, this.businessId, this.serviceId, @required this.price, this.images });

  final int professionalServiceId;
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

  Map<String, dynamic> toJsonUpdate() {
    return {
      'id': professionalServiceId,
      'price': price
    };
  }
}
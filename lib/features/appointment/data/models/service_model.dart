import 'package:meta/meta.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    @required int id,
    @required String name,
    @required String price,
    @required List<String> photos,
    @required String discount,
    @required String discountAmount,
    @required String finalPrice,
    @required int selected
  }) : super(id: id, name: name, price: price, photos: photos, discount: discount, discountAmount: discountAmount, finalPrice: finalPrice, selected: selected);

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id:       json['business_service_id'], 
      name:     json['name'],
      price:    json['price'] ?? '',
      photos:   ListGallery.fromJson(json).photos,
      discount: json['discount'] ?? '',
      discountAmount: json['discount_ammount'] != null ? json['discount_ammount'].toString() : '',
      finalPrice: json['total'] != null ? json['total'].toString() : '',
      selected: 0
    );
  }
}

class ListGallery {
  List<String> photos;

  ListGallery.fromJson(dynamic json) {
    photos = List();
    for (var item in json['gallery']) {
      final comment = 'https://archivosprestape.s3.amazonaws.com/' + item.toString();
      photos.add(comment);
    }
  }
}
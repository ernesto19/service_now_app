import 'package:meta/meta.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';

class GalleryModel extends Gallery {
  GalleryModel({
    @required int businessServiceId,
    @required String name,
    @required List<String> photos
  }) : super(businessServiceId: businessServiceId, name: name, photos: photos);

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      businessServiceId:  json['business_service_id'], 
      name:               json['name'],
      photos:             json['gallery']
    );
  }
}
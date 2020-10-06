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
      photos:             ListGallery.fromJson(json).photos
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
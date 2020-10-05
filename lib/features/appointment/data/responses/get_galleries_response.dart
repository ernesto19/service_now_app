import 'package:service_now/features/appointment/data/models/gallery_model.dart';

class GetGalleriesResponse {
  int error;
  String message;
  List<GalleryModel> data = List();

  GetGalleriesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final gallery = GalleryModel.fromJson(item);
        data.add(gallery);
      }
    }
  }
}
import 'package:flutter/material.dart';

abstract class GalleryEvent { }

class DeleteImageForProfessional extends GalleryEvent {
  final int id;
  final BuildContext context;

  DeleteImageForProfessional(this.id, this.context);
}
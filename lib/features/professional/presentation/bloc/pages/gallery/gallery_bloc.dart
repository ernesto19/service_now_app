import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/domain/usecases/delete_image_by_professional.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final DeleteImageByProfessional deleteImageByProfessional;

  GalleryBloc({
    @required DeleteImageByProfessional deleteImage
  }) : assert(deleteImage != null),
       deleteImageByProfessional = deleteImage;

  @override
  GalleryState get initialState => GalleryState.initialState;

  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is DeleteImageForProfessional) {
      yield* this._deleteImage(event);
    }
  }

  Stream<GalleryState> _deleteImage(DeleteImageForProfessional event) async* {
    showDialog(
      context: event.context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Eliminando ...', style: TextStyle(fontSize: 15.0)),
                )
              ],
            ),
          ),
        );
      }
    );

    yield this.state.copyWith(status: GalleryStatus.deleting);

    final failureOrSuccess = await deleteImageByProfessional(DeleteParams(id: event.id));
    yield* _eitherDeleteImageOrErrorState(failureOrSuccess);

    if (this.state.status == GalleryStatus.ready) {
      Navigator.pop(event.context);
      this._showDialog('Eliminación exitosa', this.state.deleteResponse.message, event.context);
    }
  }

  Stream<GalleryState> _eitherDeleteImageOrErrorState(
    Either<Failure, DeleteImageResponse> failureOrSuccessDelete
  ) async * {
    yield failureOrSuccessDelete.fold(
      (failure) {
        return this.state.copyWith(status: GalleryStatus.error, deleteResponse: null);
      },
      (response) {
        return this.state.copyWith(status: GalleryStatus.ready, deleteResponse: response);
      }
    );
  }

  void _showDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
          content: Text(message, style: TextStyle(fontSize: 16.0),),
          actions: <Widget>[
            FlatButton(
              child: Text('ACEPTAR', style: TextStyle(fontSize: 14.0)),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );
  }

  static GalleryBloc of(BuildContext context) {
    return BlocProvider.of<GalleryBloc>(context);
  }
}
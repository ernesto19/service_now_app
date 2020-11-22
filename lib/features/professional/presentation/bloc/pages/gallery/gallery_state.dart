import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';

enum GalleryStatus { checking, loading, deleting, ready, error }

class GalleryState extends Equatable {
  final GalleryStatus status;
  final DeleteImageResponse deleteResponse;

  GalleryState({ this.status, this.deleteResponse });

  static GalleryState get initialState => GalleryState(
    status: GalleryStatus.checking,
    deleteResponse: null
  );

  GalleryState copyWith({
    GalleryStatus status,
    DeleteImageResponse deleteResponse
  }) {
    return GalleryState(
      status: status ?? this.status,
      deleteResponse: deleteResponse ?? this.deleteResponse
    );
  }

  @override
  List<Object> get props => [status, deleteResponse];
}
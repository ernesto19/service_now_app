import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';

enum BusinessStatus { checking, loading, mapMount, selecting, downloading, ready, error, loadingGallery, readyGallery, readyComments }

class AppointmentState extends Equatable {
  final LatLng myLocation;
  final List<Business> business;
  final List<Gallery> galleries;
  final List<Comment> comments;
  final Map<MarkerId, Marker> markers;
  final BusinessStatus status;

  AppointmentState({ this.myLocation, this.business, this.galleries, this.comments, this.markers, this.status });

  static AppointmentState get initialState => AppointmentState(
    myLocation: null,
    business: const [],
    galleries: const[],
    comments: const[],
    markers: Map(),
    status: BusinessStatus.loading
  );

  AppointmentState copyWith({ 
    LatLng myLocation, 
    List<Business> business,
    List<Gallery> galleries,
    List<Comment> comments,
    Map<MarkerId, Marker> markers,
    BusinessStatus status
  }) {
    return AppointmentState(
      myLocation: myLocation ?? this.myLocation,
      business: business ?? this.business,
      galleries: galleries ?? this.galleries,
      comments: comments ?? this.comments,
      markers: markers ?? this.markers,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [myLocation, business, galleries, comments, markers, status];
}
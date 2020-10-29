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
  final Map<String, Business> history;
  final Business trade;

  AppointmentState({ this.myLocation, this.business, this.galleries, this.comments, this.markers, this.status, this.history, this.trade });

  static AppointmentState get initialState => AppointmentState(
    myLocation: null,
    business: const [],
    galleries: const[],
    comments: const[],
    markers: Map(),
    status: BusinessStatus.loading,
    history: Map(),
    trade: null
  );

  AppointmentState copyWith({ 
    LatLng myLocation, 
    List<Business> business,
    List<Gallery> galleries,
    List<Comment> comments,
    Map<MarkerId, Marker> markers,
    Map<String, Business> history,
    BusinessStatus status,
    Business trade
  }) {
    return AppointmentState(
      myLocation: myLocation ?? this.myLocation,
      business: business ?? this.business,
      galleries: galleries ?? this.galleries,
      comments: comments ?? this.comments,
      markers: markers ?? this.markers,
      history: history ?? this.history,
      status: status ?? this.status,
      trade: trade ?? this.trade
    );
  }

  @override
  List<Object> get props => [myLocation, business, galleries, comments, markers, history, status, trade];
}
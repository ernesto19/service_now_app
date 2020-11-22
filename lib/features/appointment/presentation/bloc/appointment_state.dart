import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/service.dart';

enum BusinessStatus { checking, loading, mapMount, selecting, downloading, ready, error, loadingGallery, readyGallery, readyComments, readyServices }
enum SelectBusinessStatus { checking, loading, selecting, ready, error }

class AppointmentState extends Equatable {
  final LatLng myLocation;
  final List<Business> business;
  final List<Service> services;
  final List<Comment> comments;
  final Map<MarkerId, Marker> markers;
  final BusinessStatus status;
  final Map<String, Business> history;
  final Business trade;
  final SelectBusinessStatus selectBusinessStatus;

  AppointmentState({ this.myLocation, this.business, this.services, this.comments, this.markers, this.status, this.history, this.trade, this.selectBusinessStatus });

  static AppointmentState get initialState => AppointmentState(
    myLocation: null,
    business: const [],
    services: const[],
    comments: const[],
    markers: Map(),
    status: BusinessStatus.loading,
    history: Map(),
    trade: null,
    selectBusinessStatus: SelectBusinessStatus.loading
  );

  AppointmentState copyWith({ 
    LatLng myLocation, 
    List<Business> business,
    List<Service> services,
    List<Comment> comments,
    Map<MarkerId, Marker> markers,
    Map<String, Business> history,
    BusinessStatus status,
    Business trade,
    SelectBusinessStatus selectBusinessStatus
  }) {
    return AppointmentState(
      myLocation: myLocation ?? this.myLocation,
      business: business ?? this.business,
      services: services ?? this.services,
      comments: comments ?? this.comments,
      markers: markers ?? this.markers,
      history: history ?? this.history,
      status: status ?? this.status,
      trade: trade ?? this.trade,
      selectBusinessStatus: selectBusinessStatus ?? this.selectBusinessStatus
    );
  }

  @override
  List<Object> get props => [myLocation, business, services, comments, markers, history, status, trade, selectBusinessStatus];
}
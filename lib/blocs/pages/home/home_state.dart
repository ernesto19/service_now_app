import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/models/place.dart';

class HomeState extends Equatable {
  final LatLng myLocation;
  final bool loading;
  final Map<MarkerId, Marker> markers;
  final Map<String, Place> history;

  HomeState({ this.myLocation, this.loading = true, this.markers, this.history });

  HomeState copyWith({
    LatLng myLocation,
    bool loading,
    Map<MarkerId, Marker> markers,
    Map<String, Place> history
  }) {
    return HomeState(
      myLocation: myLocation ?? this.myLocation,
      loading: loading ?? this.loading,
      markers: markers ?? this.markers,
      history: history ?? this.history
    );
  }

  static HomeState get initialState => new HomeState(
    myLocation: null,
    loading: true,
    markers: Map(),
    history: Map()
  );

  @override
  List<Object> get props => [myLocation, loading, markers, history];
}
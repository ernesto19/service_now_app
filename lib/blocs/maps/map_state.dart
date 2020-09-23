import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class MapState extends Equatable {
  final LatLng myLocation;
  final bool loading;

  MapState({ this.myLocation, this.loading = true });

  MapState copyWith({ LatLng myLocation, bool loading }) {
    return MapState(
      myLocation: myLocation ?? this.myLocation,
      loading: loading ?? this.loading
    );
  }

  @override
  List<Object> get props => [myLocation, loading];
}
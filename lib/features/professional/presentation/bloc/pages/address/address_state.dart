import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_now/models/place.dart';

class AddressState extends Equatable {
  final LatLng myLocation;
  final bool loading;
  final Map<MarkerId, Marker> markers;
  final Map<String, Place> history;
  final Place place;

  AddressState({ this.myLocation, this.loading = true, this.markers, this.history, this.place });

  AddressState copyWith({
    LatLng myLocation,
    bool loading,
    Map<MarkerId, Marker> markers,
    Map<String, Place> history,
    Place place
  }) {
    return AddressState(
      myLocation: myLocation ?? this.myLocation,
      loading: loading ?? this.loading,
      markers: markers ?? this.markers,
      history: history ?? this.history,
      place: place ?? this.place
    );
  }

  static AddressState get initialState => new AddressState(
    myLocation: null,
    loading: true,
    markers: Map(),
    history: Map(),
    place: null
  );

  @override
  List<Object> get props => [myLocation, loading, markers, history, place];
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class PolylinePoints {
  NetworkUtil util = NetworkUtil();

  Future<PolylineResult> getRouteBetweenCoordinates(
      String googleApiKey, PointLatLng origin, PointLatLng destination,
      {TravelMode travelMode = TravelMode.driving,
      List<PolylineWayPoint> wayPoints = const [],
      bool avoidHighways = false,
      bool avoidTolls = false,
      bool avoidFerries = true,
      bool optimizeWaypoints = false}) async {
    return await util.getRouteBetweenCoordinates(
        googleApiKey,
        origin,
        destination,
        travelMode,
        wayPoints,
        avoidHighways,
        avoidTolls,
        avoidFerries,
        optimizeWaypoints);
  }

  List<PointLatLng> decodePolyline(String encodedString) {
    return util.decodeEncodedPolyline(encodedString);
  }
}

class PointLatLng {
  const PointLatLng(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        this.latitude = latitude,
        this.longitude = longitude;

  final double latitude;
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}

class Distance {
  String text;
  var value;

  Distance({
    this.text,
    this.value
  });
}

class Duration {
  String text;
  var value;

  Duration({
    this.text,
    this.value
  });
}

class PolylineResult {
  String status;
  List<PointLatLng> points;
  Distance distance;
  Duration duration;
  String errorMessage;

  PolylineResult({this.status, this.points = const [], this.distance, this.duration, this.errorMessage = ""});
}

class NetworkUtil {
  static const String STATUS_OK = "ok";

  Future<PolylineResult> getRouteBetweenCoordinates(
      String googleApiKey,
      PointLatLng origin,
      PointLatLng destination,
      TravelMode travelMode,
      List<PolylineWayPoint> wayPoints,
      bool avoidHighways,
      bool avoidTolls,
      bool avoidFerries,
      bool optimizeWaypoints) async {
    String mode = travelMode.toString().replaceAll('TravelMode.', '');
    PolylineResult result = PolylineResult();
    var params = {
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      "mode": mode,
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      "key": googleApiKey
    };
    if (wayPoints.isNotEmpty) {
      List wayPointsArray = [];
      wayPoints.forEach((point) => wayPointsArray.add(point.location));
      String wayPointsString = wayPointsArray.join('|');
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    }
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);

    String url = uri.toString();

    var response = await http.get(url);
    if (response?.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      result.status = parsedJson["status"];
      if (parsedJson["status"]?.toLowerCase() == STATUS_OK && parsedJson["routes"] != null && parsedJson["routes"].isNotEmpty) {
        result.points = decodeEncodedPolyline(
          parsedJson["routes"][0]["overview_polyline"]["points"]
        );
        result.distance = Distance(text: parsedJson["routes"][0]["legs"][0]["distance"]["text"] ?? '', value: parsedJson["routes"][0]["legs"][0]["distance"]["value"] ?? 0);
        result.duration = Duration(text: parsedJson["routes"][0]["legs"][0]["duration"]["text"] ?? '', value: parsedJson["routes"][0]["legs"][0]["duration"]["value"] ?? 0);
      } else {
        result.errorMessage = parsedJson["error_message"];
      }
    }
    return result;
  }

  List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p = PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }

    return poly;
  }
}

class PolylineWayPoint {
  String location;
  bool stopOver;

  PolylineWayPoint({@required this.location, this.stopOver = true});

  @override
  String toString() {
    if (stopOver) {
      return location;
    } else {
      return "via:$location";
    }
  }
}


enum TravelMode { driving, bicycling, transit, walking }
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';

class PusherClient {
  PusherClient._internal();

  static PusherClient _instance = PusherClient._internal();
  static PusherClient get instance => _instance;

  connect() {
    PusherOptions options = PusherOptions(
      host: 'servicenow.konxulto.com',
      port: 6001,
      encrypted: false,
    );
    FlutterPusher pusher = FlutterPusher('local', options, enableLogging: true);

    Echo echo = new Echo({
      'broadcaster': 'pusher',
      'key': 'local',
      'cluster': 'mt1',
      'forceTLS': false,
      'wsHost': 'servicenow.konxulto.com',
      'wsPort': 6001,
      'disableStatus': true,
      'client': pusher,
    });

    echo.channel('coordenadas').listen('Coordinates', (e) {
      print(e);
    });

    // echo.socket.on('connect', (_) => print('connect'));
    // echo.socket.on('disconnect', (_) => print('disconnect'));
  }
}
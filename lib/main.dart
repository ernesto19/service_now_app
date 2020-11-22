import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:service_now/core/db/db.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/utils/all_translations.dart';
import 'features/appointment/presentation/pages/client_request.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/professional/presentation/pages/professional_request.dart';
import 'preferences/user_preferences.dart';
import 'routes/routes.dart';
import 'injection_container.dart' as di;

void main() async {
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.init();
  await di.init();
  await UserPreferences.instance.initPreferences();
  await allTranslations.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  final _firebaseMessaging = FirebaseMessaging();
  final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  @override
  void initState() {
    super.initState();

    registerNotification();
    configLocalNotification();

    allTranslations.onLocaleChangedCallback = _onLocaleChanged;

    if (UserPreferences.instance.firstUseApp == null || UserPreferences.instance.firstUseApp == 0) {
      UserPreferences.instance.firstUseApp = 1;
    }
  }

  _onLocaleChanged() async {
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Service Now',
      supportedLocales: allTranslations.supportedLocales(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans'
      ),
      initialRoute: UserPreferences.instance.token == null || UserPreferences.instance.token == '' ? LoginPage.routeName : HomePage.routeName,
      routes: getApplicationRoutes()
    );
  }

  void registerNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('======== $message ========');
        _showNotification(message);
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        print('======== $message ========');
        if (message['data']['screen'] != 'no-screen') {
          navigatorKey.currentState.pushNamed(message['data']['screen']);
        }
      },
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        print('======== $message ========');
        if (message['data']['screen'] != 'no-screen') {
          navigatorKey.currentState.pushNamed(message['data']['screen']);
        }
      }
    );

    _firebaseMessaging.getToken().then((token) {
      print('===== FCM TOKEN: $token ====');
      UserPreferences.instance.fcmToken = token;
    });
  }

  void configLocalNotification() {
    initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  void _showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'pe.com.service_now': 'pe.com.service_now',
      'Service Now',
      'Aplicacion Service Now',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: message['notification']['title'].toString()
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, 
      message['notification']['title'].toString(), 
      message['notification']['body'].toString(), 
      platformChannelSpecifics,
      payload: message['data']['datos'].toString()
      // payload: message['data']['services'].toString()
    );
  }

  Future onSelectNotification(String message) async {
    Map<String, dynamic> messageJson = json.decode(message);

    if (messageJson['tipo'] == 'pnRequestService') {
      navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => ProfessionalRequest(notification: message)));
    } else if (messageJson['tipo'] == 'pnResponseService') {
      navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => ClientRequest(notification: message)));
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(body)
      )
    );
  }
}
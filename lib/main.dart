import 'package:flutter/material.dart';
import 'package:service_now/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes/routes.dart';

void main() async {
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Now',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans'
      ),
      home: LoginPage(),
      routes: getApplicationRoutes()
    );
  }
}
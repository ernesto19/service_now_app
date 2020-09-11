import 'package:flutter/material.dart';
import 'package:service_now/models/user.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context).settings.arguments;
      if (args != null) {
        setState(() {
          user = args;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Bienvenido ${user != null ? user.name : ''}'),
        )
      ),
    );
  }
}
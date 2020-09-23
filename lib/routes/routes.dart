import 'package:flutter/material.dart';
import 'package:service_now/pages/home/home_page.dart';
import 'package:service_now/pages/login/login_page.dart';
import 'package:service_now/pages/menu/settings_services_page.dart';
import 'package:service_now/pages/service/search_service.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    LoginPage.routeName   : (context) => LoginPage(),
    HomePage.routeName    : (context) => HomePage(),
    SearchService.routeName : (context) => SearchService(),
    SettingsCategories.routeName : (context) => SettingsCategories()
  };
}
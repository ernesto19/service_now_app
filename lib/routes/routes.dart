import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/presentation/pages/search_business_page.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    LoginPage.routeName   : (context) => LoginPage(),
    HomePage.routeName    : (context) => HomePage(),
    SettingsCategories.routeName : (context) => SettingsCategories(),
    SearchBusinessPage.routeName : (context) => SearchBusinessPage()
  };
}
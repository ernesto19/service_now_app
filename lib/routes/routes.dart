import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/presentation/pages/search_business_page.dart';
import 'package:service_now/features/home/presentation/pages/home_page.dart';
import 'package:service_now/pages/detail_page.dart';
import 'package:service_now/pages/login/login_page.dart';
import 'package:service_now/pages/menu/settings_services_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    LoginPage.routeName   : (context) => LoginPage(),
    HomePage.routeName    : (context) => HomePage(),
    SettingsCategories.routeName : (context) => SettingsCategories(),
    BusinessDetailPage.routeName : (context) => BusinessDetailPage(),

    SearchBusinessPage.routeName : (context) => SearchBusinessPage()
  };
}
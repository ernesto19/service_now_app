import 'package:flutter/material.dart';
import 'package:service_now/pages/login/login_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    LoginPage.routeName   : (context) => LoginPage(),
    // MainPage.routeName    : (context) => MainPage(),
    // HomePage.routeName    : (context) => HomePage(),
    // RecipePage.routeName  : (context) => RecipePage(),
    // RecipeDetailPage.routeName : (context) => RecipeDetailPage()
  };
}
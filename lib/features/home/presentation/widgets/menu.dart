import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(UserPreferences.instance.firstName ?? '' + ' ' + UserPreferences.instance.lastName ?? '', style: TextStyle(fontSize: 18)),
                    Text(UserPreferences.instance.email ?? '')
                  ]
                )
              ),
              SizedBox(height: 20),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  height: 20
                ),
                title: Text(allTranslations.traslate('menu_profile')),
                onTap: () {
                  
                }
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/services.svg',
                  height: 20
                ),
                title: Text(allTranslations.traslate('menu_services')),
                onTap: () {
                  Navigator.pushNamed(context, SettingsCategories.routeName);
                }
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/terms.svg',
                  height: 20
                ),
                title: Text(allTranslations.traslate('menu_terms')),
                onTap: () {
                  
                }
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/support.svg',
                  height: 20
                ),
                title: Text(allTranslations.traslate('menu_support')),
                onTap: () {
                  
                }
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/log_out.svg',
                  height: 20
                ),
                title: Text(allTranslations.traslate('log_out')),
                onTap: () {
                  _clearData();
                  Navigator.pushNamed(context, LoginPage.routeName);
                }
              )
            ]
          )
        )
      )
    );
  }

  void _clearData() {
    UserPreferences.instance.token = '';
  }
}
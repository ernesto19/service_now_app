import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_now/features/login/presentation/pages/login_page.dart';
import 'package:service_now/features/home/presentation/pages/settings_services_page.dart';
import 'package:service_now/features/professional/presentation/pages/professional_business_page.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/widgets/rounded_button.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<OptionMenu> options = List();
    options.add(OptionMenu(id: 1, title: allTranslations.traslate('menu_profile'), icon: 'assets/icons/profile.svg'));
    options.add(OptionMenu(id: 2, title: allTranslations.traslate('menu_services'), icon: 'assets/icons/services.svg'));
    options.add(OptionMenu(id: 3, title: allTranslations.traslate('menu_terms'), icon: 'assets/icons/terms.svg'));
    options.add(OptionMenu(id: 4, title: allTranslations.traslate('menu_support'), icon: 'assets/icons/support.svg'));
    options.add(OptionMenu(id: 5, title: allTranslations.traslate('menu_business'), icon: 'assets/icons/work.svg'));
    options.add(OptionMenu(id: 10, title: allTranslations.traslate('log_out'), icon: 'assets/icons/log_out.svg'));

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
                    Text('${UserPreferences.instance.firstName ?? ''} ${UserPreferences.instance.lastName ?? ''}', style: TextStyle(fontSize: 18)),
                    Text(UserPreferences.instance.email ?? '')
                  ]
                )
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: SvgPicture.asset(
                        options[index].icon,
                        height: 23
                      ),
                      title: Text(options[index].title),
                      onTap: () => _onTap(options[index].id, context)
                    );
                  }
                )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: RoundedButton(
                  onPressed: () {}, 
                  label: allTranslations.traslate('acquire_membership'),
                  backgroundColor: secondaryDarkColor,
                  width: double.infinity,
                  fontSize: 14,
                  icon: Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.person_add, color: Colors.white, size: 18)
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  void _onTap(int id, BuildContext context) {
    switch (id) {
      case 2:
        Navigator.pushNamed(context, SettingsCategories.routeName);
        break;
      case 5:
        Navigator.pushNamed(context, ProfessionalBusinessPage.routeName);
        break;
      case 10:
        _clearData();
        Navigator.pushNamed(context, LoginPage.routeName);
        break;
      default:
    }
  }

  void _clearData() {
    UserPreferences.instance.token = '';
    UserPreferences.instance.email = '';
    UserPreferences.instance.firstName = '';
    UserPreferences.instance.lastName = '';
  }
}

class OptionMenu {
  int id;
  String title;
  String icon;

  OptionMenu({
    this.id,
    this.title,
    this.icon
  });
}
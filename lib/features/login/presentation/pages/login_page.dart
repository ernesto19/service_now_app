import 'package:flutter/material.dart';
import 'package:service_now/preferences/user_preferences.dart';
import 'package:service_now/utils/all_translations.dart';
import '../widgets/login_form.dart';
import '../widgets/welcome.dart';

class LoginPage extends StatefulWidget {
  static final routeName = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _languageSelected = UserPreferences.instance.language == null ? 'ES' : UserPreferences.instance.language.toString().toUpperCase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(247, 247, 247, 1),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDropdown(),
                    Welcome(),
                    SizedBox(height: 30),
                    LoginForm()
                  ]
                ),
              )
            )
          ),
        ),
      )
    );
  }

  Widget _buildDropdown() {
    List<Language> languages = List();
    languages.add(Language(title: 'ES', icon: 'assets/images/spain-flag.png'));
    languages.add(Language(title: 'EN', icon: 'assets/images/usa-flag.png'));

    return Container (
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 10),
      child: DropdownButton<String>(
        style: TextStyle(fontFamily: 'sans', color: Colors.black87, fontSize: 14.0),
        underline: Divider(
          height: 0.0,
          color: Color.fromRGBO(247, 247, 247, 1)
        ),
        items: languages.map((Language item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Row(
              children: <Widget>[
                Image.asset(
                  item.icon,
                  width: 20,
                  height: 20
                ),
                SizedBox(width: 5),
                Text(item.title)
              ],
            )
          );
        }).toList(),
        value: _languageSelected,
        onChanged: (value) async {
          await allTranslations.setNewLanguage(value == 'ES' ? 'es' : 'en');
          _languageSelected = value;
          setState((){});
        }
      )
    );
  }
}

class Language {
  String title;
  String icon;

  Language({
    this.title,
    this.icon
  });
}
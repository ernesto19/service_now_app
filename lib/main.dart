import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:service_now/core/db/db.dart';
import 'package:service_now/pages/detail_page.dart';
import 'package:service_now/pages/login/login_page.dart';
import 'package:service_now/utils/all_translations.dart';
import 'features/home/presentation/pages/home_page.dart';
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

  @override
  void initState() {
    super.initState();

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
      // initialRoute: UserPreferences.instance.token == null || UserPreferences.instance.token == '' ? LoginPage.routeName : HomePage.routeName,
      // routes: getApplicationRoutes()
      home: BusinessDetailPage(),
    );
  }
}
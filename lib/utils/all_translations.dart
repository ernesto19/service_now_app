import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:service_now/preferences/user_preferences.dart';

const List<String> _supportedLanguages = ['en','es'];
// var preferences = UserPreferences();

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() => _supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  String traslate(String key) {
     return (_localizedValues == null || _localizedValues[key] == null) ? '** $key not found' : _localizedValues[key];
  }

  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  get locale => _locale;
  
  Future<Null> init([String language]) async {
    if (_locale == null){
      await setNewLanguage(language);
    }
    return null;
  }

  getPreferredLanguage() async {
    return _getApplicationSavedInformation();
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation(lang);
  }

  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null){
      language = await getPreferredLanguage();
    }

    if (language == ""){
      language = "es";
    }
    _locale = Locale(language, "");

    String jsonContent = await rootBundle.loadString("i18n/${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }

    return null;
  }

  set onLocaleChangedCallback(VoidCallback callback){
    _onLocaleChangedCallback = callback;
  }

  Future<String> _getApplicationSavedInformation() async {
    return UserPreferences.instance.language ?? '';
    // return preferences.language ?? '';
  }

  Future<void> _setApplicationSavedInformation(String value) async {
    // preferences.language = value;
    UserPreferences.instance.language = value;
  }

  static final GlobalTranslations _translations = new GlobalTranslations._internal();
  factory GlobalTranslations() {
    return _translations;
  }
  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();
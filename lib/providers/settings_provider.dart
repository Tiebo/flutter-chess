import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';

  late Box _settingsBox;
  Locale _locale = const Locale('zh');
  ThemeMode _themeMode = ThemeMode.system;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _settingsBox = await Hive.openBox(_boxName);
    _loadSettings();
  }

  void _loadSettings() {
    final localeString = _settingsBox.get(_localeKey, defaultValue: 'zh') as String;
    _locale = Locale(localeString);
    
    final themeModeString = _settingsBox.get(_themeModeKey, defaultValue: 'system') as String;
    _themeMode = _getThemeModeFromString(themeModeString);
    
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    await _settingsBox.put(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;
    
    _themeMode = themeMode;
    await _settingsBox.put(_themeModeKey, _getStringFromThemeMode(themeMode));
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
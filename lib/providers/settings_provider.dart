import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings {
  final Locale locale;
  final ThemeMode themeMode;

  const AppSettings({
    required this.locale,
    required this.themeMode,
  });

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const String _boxName = 'settings';
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';

  late Box _settingsBox;

  @override
  Future<AppSettings> build() async {
    // 初始化Hive
    _settingsBox = await Hive.openBox(_boxName);
    
    // 使用keepAlive保持状态，避免频繁重新初始化
    ref.keepAlive();
    
    // 加载设置
    final localeString = _settingsBox.get(_localeKey, defaultValue: 'zh') as String;
    final themeModeString = _settingsBox.get(_themeModeKey, defaultValue: 'system') as String;
    
    return AppSettings(
      locale: Locale(localeString),
      themeMode: _getThemeModeFromString(themeModeString),
    );
  }

  Future<void> setLocale(Locale locale) async {
    final currentSettings = await future;
    if (currentSettings.locale == locale) return;
    
    await _settingsBox.put(_localeKey, locale.languageCode);
    state = AsyncData(currentSettings.copyWith(locale: locale));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final currentSettings = await future;
    if (currentSettings.themeMode == themeMode) return;
    
    await _settingsBox.put(_themeModeKey, _getStringFromThemeMode(themeMode));
    state = AsyncData(currentSettings.copyWith(themeMode: themeMode));
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

// Provider定义
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  () => SettingsNotifier(),
);

// 便利的同步访问provider（用于UI）
final currentLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(settingsProvider).when(
    data: (settings) => settings.locale,
    loading: () => const Locale('zh'), // 加载时的默认值
    error: (_, __) => const Locale('zh'), // 错误时的默认值
  );
});

final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).when(
    data: (settings) => settings.themeMode,
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});
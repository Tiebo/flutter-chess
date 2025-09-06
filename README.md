## Flutter 应用多语言与主题切换实现文档

本文档介绍如何在 Flutter 应用中实现多语言国际化（i18n）与主题（深色/浅色/系统）切换，包括状态管理与数据持久化的设计与落地。

### 目录
- [项目概述](#项目概述)
- [技术架构](#技术架构)
  - [依赖包](#依赖包)
  - [核心组件](#核心组件)
- [国际化实现](#国际化实现)
  - [配置文件](#配置文件)
  - [语言资源文件](#语言资源文件)
  - [代码生成](#代码生成)
- [状态管理实现](#状态管理实现)
  - [SettingsProvider 类](#settingsprovider-类)
  - [核心设计原则](#核心设计原则)
- [UI 层集成](#ui-层集成)
  - [应用根部集成](#应用根部集成)
  - [设置页面实现](#设置页面实现)
- [技术特点](#技术特点)
  - [优势](#优势)
  - [性能考虑](#性能考虑)
- [开发流程](#开发流程)
  - [添加新语言](#添加新语言)
  - [添加新主题](#添加新主题)
- [最佳实践](#最佳实践)
  - [国际化](#国际化)
  - [状态管理](#状态管理)
  - [用户体验](#用户体验)
- [总结](#总结)

## 项目概述
本方案基于 Flutter 官方国际化工具链与 Provider 状态管理，提供类型安全的多语言与主题切换能力，并通过本地存储持久化用户偏好。

## 技术架构

### 依赖包
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations: # 官方国际化支持
    sdk: flutter
  provider: ^6.1.1        # 状态管理
  shared_preferences: ^2.2.2 # 本地存储

flutter:
  generate: true # 启用 gen-l10n 代码生成
```

### 核心组件
- 国际化系统：Flutter 官方 gen-l10n
- 状态管理：Provider 模式
- 数据持久化：SharedPreferences
- 主题系统：Material Design 3（明/暗/系统）

## 国际化实现

### 配置文件
`l10n.yaml`
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### 语言资源文件

`lib/l10n/app_en.arb`（英文）
```json
{
  "appTitle": "Simple ToDo",
  "todo": "Todo",
  "profile": "Profile",
  "settings": "Settings",
  "language": "Language",
  "theme": "Theme"
}
```

`lib/l10n/app_zh.arb`（中文）
```json
{
  "appTitle": "简单待办",
  "todo": "待办",
  "profile": "我的",
  "settings": "设置",
  "language": "语言",
  "theme": "主题"
}
```

### 代码生成
- 运行命令生成本地化文件：
```bash
flutter gen-l10n
```
- 生成的文件：
  - `lib/l10n/app_localizations.dart`（主入口）
  - `lib/l10n/app_localizations_en.dart`（英文实现）
  - `lib/l10n/app_localizations_zh.dart`（中文实现）

## 状态管理实现

### SettingsProvider 类
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';

  Locale _locale = const Locale('zh');
  ThemeMode _themeMode = ThemeMode.system;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final localeString = prefs.getString(_localeKey) ?? 'zh';
    _locale = Locale(localeString);

    final themeModeString = prefs.getString(_themeModeKey) ?? 'system';
    _themeMode = _getThemeModeFromString(themeModeString);

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _getStringFromThemeMode(themeMode));
    notifyListeners();
  }

  // 根据存储的字符串还原 ThemeMode（示意）
  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // 将 ThemeMode 转换为可存储的字符串（示意）
  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
```

### 核心设计原则
1. 单一数据源：设置状态集中在 `SettingsProvider`。
2. 响应式更新：使用 `ChangeNotifier` 通知 UI 更新。
3. 数据持久化：自动保存用户选择到本地存储。
4. 延迟初始化：异步加载已保存的设置。

## UI 层集成

### 应用根部集成
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'pages/main_page.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          locale: settingsProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh'),
            Locale('en'),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: settingsProvider.themeMode,
          home: const MainPage(),
        );
      },
    );
  }
}
```

### 设置页面实现
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            children: [
              // 语言选择
              RadioListTile<Locale>(
                title: Text(l10n.chinese),
                value: const Locale('zh'),
                groupValue: settingsProvider.locale,
                onChanged: (locale) => settingsProvider.setLocale(locale!),
              ),

              // 主题选择
              RadioListTile<ThemeMode>(
                title: Text(l10n.lightTheme),
                value: ThemeMode.light,
                groupValue: settingsProvider.themeMode,
                onChanged: (mode) => settingsProvider.setThemeMode(mode!),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## 技术特点

### 优势
1. 官方标准：使用 Flutter 官方国际化方案。
2. 类型安全：生成的本地化类提供编译期检查。
3. 响应式：设置变更立即反映到整个应用。
4. 持久化：用户设置在应用重启后保持一致。
5. 扩展性：易于添加新语言与新主题。

### 性能考虑
1. 懒加载：本地化文件按需加载。
2. 缓存：`SharedPreferences` 提供轻量缓存。
3. 最小重建：`Consumer` 只重建必要的 Widget。
4. 内存效率：Provider 避免不必要的状态复制。

## 开发流程

### 添加新语言
1. 创建新的 `.arb` 文件（如 `app_ja.arb`）。
2. 添加翻译内容。
3. 运行 `flutter gen-l10n` 重新生成。
4. 在 `supportedLocales` 中添加新语言。

### 添加新主题
1. 在 `MaterialApp` 中添加相应主题配置（`theme`/`darkTheme`）。
2. 在 `SettingsProvider` 中扩展对主题模式的支持。
3. 更新设置页面的选择项。

## 最佳实践

### 国际化
- 使用语义化的 key 名称。
- 保持 ARB 文件结构一致。
- 为复杂文本提供占位符支持。
- 考虑 RTL 语言的布局适配。

### 状态管理
- 遵循单向数据流。
- 避免在 Provider 中进行 UI 操作。
- 合理使用 `Consumer` 与 `Selector`。
- 处理异步操作的错误状态。

### 用户体验
- 提供直观的设置界面。
- 设置变更立即生效。
- 保持应用重启后的一致性。
- 考虑系统设置的继承。

## 总结
该实现方案提供完整的多语言与主题切换能力，具有良好的可维护性与扩展性。通过 Flutter 官方工具链与 Provider 状态管理，实现了类型安全、响应式与持久化的用户偏好设置系统。

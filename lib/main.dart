import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'l10n/app_localizations.dart';
import 'pages/main_page.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
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
          title: 'Simple ToDo',
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
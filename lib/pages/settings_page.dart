import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common/common_header.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsProvider);
    
    return Scaffold(
      appBar: CommonHeader(
        title: l10n.settings,
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildLanguageSection(context, ref, settings, l10n),
            const SizedBox(height: 16),
            _buildThemeSection(context, ref, settings, l10n),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref, AppSettings settings, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(
                settings.locale.languageCode == 'zh' 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.chinese),
              onTap: () => ref.read(settingsProvider.notifier).setLocale(const Locale('zh')),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                settings.locale.languageCode == 'en' 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.english),
              onTap: () => ref.read(settingsProvider.notifier).setLocale(const Locale('en')),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref, AppSettings settings, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(
                settings.themeMode == ThemeMode.light 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.lightTheme),
              onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                settings.themeMode == ThemeMode.dark 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.darkTheme),
              onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(
                settings.themeMode == ThemeMode.system 
                    ? Icons.radio_button_checked 
                    : Icons.radio_button_unchecked,
              ),
              title: Text(l10n.systemTheme),
              onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
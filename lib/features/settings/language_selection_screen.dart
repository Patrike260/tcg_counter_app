import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import 'app_preferences_service.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(appPreferencesProvider).localeCode;
    final options = <_LocaleOption>[
      _LocaleOption('system', l10n.languageSystem, l10n.languageSystemSubtitle),
      _LocaleOption('de', l10n.languageGerman, 'Deutsch'),
      _LocaleOption('en', l10n.languageEnglish, 'English'),
      _LocaleOption('fr', l10n.languageFrench, 'Français'),
      _LocaleOption('it', l10n.languageItalian, 'Italiano'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languageTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selected == option.code ||
              (option.code == 'system' &&
                  (selected.isEmpty || selected == 'system'));
          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(
                option.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(option.subtitle),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : const Icon(Icons.circle_outlined),
              onTap: () {
                ref.read(appPreferencesProvider.notifier).setLocaleCode(option.code);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LocaleOption {
  final String code;
  final String title;
  final String subtitle;

  const _LocaleOption(this.code, this.title, this.subtitle);
}

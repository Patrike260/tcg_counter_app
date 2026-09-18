import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/theme/app_theme_presets.dart';
import '../auth/auth_repository.dart';
import '../decks/deck_repository.dart';
import 'app_preferences_service.dart';
import 'archetype_management_screen.dart';
import 'backup_service.dart';
import 'game_management_screen.dart';
import 'game_visibility_screen.dart';
import 'match_preferences_screen.dart';
import 'tag_management_screen.dart';
import 'theme_selection_screen.dart';
import 'tool_presets_screen.dart';
import 'dashboard_settings_screen.dart';
import 'legal_info_screen.dart';
import 'language_selection_screen.dart';
import '../tournaments/tournament_list_screen.dart';
import '../../l10n/l10n.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isProcessing = false;

  Future<void> _exportCsv() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(backupServiceProvider).exportMatchesAsCsv();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.csvExported)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.csvExportFailed(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _exportJson() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(backupServiceProvider).exportFullBackup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.jsonBackupCreated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.jsonBackupFailed(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _restoreJson() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (files == null || files.isEmpty) return;

    final Uint8List bytes;
    try {
      bytes = await files.first.readAsBytes();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.fileReadFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.restoreBackupQuestion),
        content: Text(context.l10n.restoreBackupBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.restore),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final jsonString = utf8.decode(bytes);
      final count = await ref.read(backupServiceProvider).restoreBackupFromJson(jsonString);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.matchesRestored(count))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.restoreFailed(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _confirmDeleteAccount() async {
    final first = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteAccountQuestion),
        content: Text(context.l10n.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(context.l10n.continueAction),
          ),
        ],
      ),
    );
    if (first != true || !mounted) return;

    final second = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.lastConfirmation),
        content: Text(context.l10n.deleteAccountFinalBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.deletePermanently),
          ),
        ],
      ),
    );
    if (second != true || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.deleteAccountFailed(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = supabase.auth.currentUser;
    final prefs = ref.watch(appPreferencesProvider);
    final gamesAsync = ref.watch(gamesListProvider);

    final gameName = gamesAsync.maybeWhen(
      data: (games) {
        for (final game in games) {
          if (game.id == prefs.resolvedDefaultGameId) return game.name;
        }
        return null;
      },
      orElse: () => null,
    );
    final turnLabel = switch (prefs.defaultTurnOrder) {
      'first' => l10n.turnFirstShort,
      'second' => l10n.turnSecondShort,
      _ => l10n.turnFree,
    };
    final summary = [
      gameName ?? l10n.noTcg,
      prefs.defaultFormatLabel,
      turnLabel,
    ].join(' • ');

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user?.email ?? l10n.noUserLoggedIn),
                  subtitle: Text(
                    user != null && user.id.length >= 8
                        ? l10n.userIdShort(user.id.substring(0, 8))
                        : '',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sectionAppearance,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.language_outlined,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: l10n.languageTitle,
                    subtitle: prefs.localeLabel(
                      system: l10n.languageSystem,
                      german: l10n.languageGerman,
                      english: l10n.languageEnglish,
                      french: l10n.languageFrench,
                      italian: l10n.languageItalian,
                    ),
                    onTap: () => _open(const LanguageSelectionScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.palette_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: l10n.themePresetsTitle,
                    subtitle: getThemeTitle(prefs.themePreset),
                    onTap: () => _open(const ThemeSelectionScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.dashboard_customize_outlined,
                    iconColor: Colors.cyanAccent,
                    title: l10n.dashboardTabsTitle,
                    subtitle: l10n.dashboardTabsSubtitle,
                    onTap: () => _open(const DashboardSettingsScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sectionSettings,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.tune_outlined,
                    iconColor: Colors.deepPurpleAccent,
                    title: l10n.matchDefaultsTitle,
                    subtitle: summary,
                    onTap: () => _open(const MatchPreferencesScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.visibility_outlined,
                    iconColor: Colors.tealAccent,
                    title: l10n.visibleTcgsTitle,
                    subtitle: l10n.visibleTcgsSubtitle,
                    onTap: () => _open(const GameVisibilityScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.sports_esports_outlined,
                    iconColor: Colors.lightBlueAccent,
                    title: l10n.manageTcgsTitle,
                    subtitle: l10n.manageTcgsSubtitle,
                    onTap: () => _open(const GameManagementScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.calculate_outlined,
                    iconColor: Colors.amber,
                    title: l10n.toolPresetsTitle,
                    subtitle: l10n.toolPresetsSubtitle,
                    onTap: () => _open(const ToolPresetsScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sectionContent,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.emoji_events_outlined,
                    iconColor: Colors.amber,
                    title: l10n.tournamentsTitle,
                    subtitle: l10n.tournamentsSubtitle,
                    onTap: () => _open(const TournamentListScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.category_outlined,
                    iconColor: Colors.purpleAccent,
                    title: l10n.archetypesTitle,
                    subtitle: l10n.archetypesSubtitle,
                    onTap: () => _open(const ArchetypeManagementScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.label_outlined,
                    iconColor: const Color(0xFFCE93D8),
                    title: l10n.eventTagsTitle,
                    subtitle: l10n.eventTagsSubtitle,
                    onTap: () => _open(const TagManagementScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sectionBackup,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.table_chart_outlined,
                    iconColor: Colors.greenAccent,
                    title: l10n.exportCsvTitle,
                    subtitle: l10n.exportCsvSubtitle,
                    onTap: _isProcessing ? null : _exportCsv,
                  ),
                  _SettingsNavTile(
                    icon: Icons.file_download_outlined,
                    iconColor: Colors.blueAccent,
                    title: l10n.exportJsonTitle,
                    subtitle: l10n.exportJsonSubtitle,
                    onTap: _isProcessing ? null : _exportJson,
                  ),
                  _SettingsNavTile(
                    icon: Icons.file_upload_outlined,
                    iconColor: Colors.orangeAccent,
                    title: l10n.restoreBackupTitle,
                    subtitle: l10n.restoreBackupSubtitle,
                    onTap: _isProcessing ? null : _restoreJson,
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.sectionAccount,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.white70,
                    title: l10n.version,
                    subtitle: l10n.versionSubtitle,
                    trailing: const Text('0.3.1 (Web/PWA)'),
                  ),
                  _SettingsNavTile(
                    icon: Icons.gavel_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: l10n.legalSettingsTitle,
                    subtitle: l10n.legalSettingsSubtitle,
                    onTap: () => _open(const LegalInfoScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.logout,
                    iconColor: Colors.redAccent,
                    title: l10n.signOutTitle,
                    subtitle: l10n.signOutSubtitle,
                    titleColor: Colors.redAccent,
                    showChevron: false,
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                  _SettingsNavTile(
                    icon: Icons.delete_forever,
                    iconColor: Colors.red.shade700,
                    title: l10n.deleteAccountTitle,
                    subtitle: l10n.deleteAccountSubtitle,
                    titleColor: Colors.red.shade700,
                    showChevron: false,
                    showDivider: false,
                    onTap: _isProcessing ? null : _confirmDeleteAccount,
                  ),
                ],
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;
  final bool showChevron;
  final bool showDivider;

  const _SettingsNavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.titleColor,
    this.showChevron = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
          ),
          subtitle: Text(subtitle),
          trailing: trailing ??
              (showChevron ? const Icon(Icons.chevron_right) : null),
        ),
        if (showDivider) const Divider(height: 1, indent: 72),
      ],
    );
  }
}

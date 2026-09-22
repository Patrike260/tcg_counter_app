import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/settings/app_preferences_service.dart';

import 'core/constants/supabase_constants.dart';
import 'core/theme/app_themes.dart';
import 'core/widgets/dice_coin_dialog.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'features/decks/deck_list_screen.dart';
import 'features/settings/match_preferences_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/stats/dashboard_repository.dart';
import 'features/stats/dashboard_screen.dart';
import 'features/tools/tools_screen.dart';
import 'features/tools/widgets/round_timer_capsule.dart';
import 'l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FLUTTER START ERROR: ${details.exception}');
  };

  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {}
  }

  try {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('SUPABASE INIT FEHLER: $e');
  }

  // SharedPreferences synchron vor Start laden
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final prefs = ref.watch(appPreferencesProvider);
    final locale = prefs.localeOverride;

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppThemes.buildLightTheme(prefs.activePreset),
      darkTheme: AppThemes.buildDarkTheme(prefs.activePreset),
      themeMode: prefs.themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: authState.when(
        data: (data) {
          if (data.session != null) {
            return const MainNavigationHost();
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class MainNavigationHost extends ConsumerStatefulWidget {
  const MainNavigationHost({super.key});

  @override
  ConsumerState<MainNavigationHost> createState() => _MainNavigationHostState();
}

class _MainNavigationHostState extends ConsumerState<MainNavigationHost> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    DeckListScreen(),
    ToolsScreen(),
    SettingsScreen(),
  ];

  @override
  void dispose() {
    unlockToolOrientations();
    super.dispose();
  }

  void _selectTab(int index) {
    final leavingTools = _currentIndex == 2 && index != 2;
    setState(() => _currentIndex = index);
    if (leavingTools) {
      unlockToolOrientations();
    }
    if (index == 0) {
      ref.invalidate(dashboardDataProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titles = [
      l10n.navDashboard,
      l10n.titleMyDecks,
      l10n.navTools,
      l10n.navSettings,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              tooltip: l10n.tooltipDashboardFilter,
              icon: const Icon(Icons.tune_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MatchPreferencesScreen()),
                );
              },
            ),
            const SizedBox(width: 12),
          ],
          const RoundTimerCapsule(),
          if (_currentIndex == 2) const ToolsRotateButton(),
          IconButton(
            tooltip: l10n.tooltipDiceCoin,
            icon: const Icon(Icons.casino_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const DiceCoinDialog(),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.style_outlined),
            selectedIcon: const Icon(Icons.style),
            label: l10n.navDecks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.navTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
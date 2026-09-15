import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_constants.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/login_screen.dart';
import 'features/decks/deck_list_screen.dart';
import 'features/stats/dashboard_repository.dart';
import 'features/stats/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'TCG Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
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
          body: Center(child: Text('Fehler: $error')),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Dashboard' : 'Meine Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            ref.invalidate(dashboardDataProvider);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Decks',
          ),
        ],
      ),
    );
  }
}
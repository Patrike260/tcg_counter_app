import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      body: dashboardAsync.when(
        data: (data) {
          if (data.totalMatches == 0) {
            return const Center(
              child: Text(
                'Willkommen!\nTrage erste Matches in deinen Decks ein, um Statistiken zu sehen.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardDataProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Haupt-KPI Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Gesamte Match-Performance', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          '${data.overallWinRate.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${data.totalWins} Siege von ${data.totalMatches} Spielen',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Aufschlüsselung nach Spiel
                const Text(
                  'Performance nach Kartenspiel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...data.gameSummaries.map((game) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(game.gameName.isNotEmpty ? game.gameName[0] : '?'),
                        ),
                        title: Text(game.gameName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${game.wins} Siege von ${game.totalMatches} Matches'),
                        trailing: Text(
                          '${game.winRate.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: game.winRate >= 50 ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 24),

                // Letzte 5 Matches
                const Text(
                  'Letzte Matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...data.recentMatches.map((match) {
                  final isWin = match.result == 'win';
                  final isLoss = match.result == 'loss';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                      color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                    ),
                    title: Text('vs. ${match.opponentDeck}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}'),
                    trailing: Text(
                      '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';
import 'widgets/chakra_tracker_view.dart';
import 'widgets/cyberpunk_tracker_view.dart';
import 'widgets/dice_coin_view.dart';
import 'widgets/digimon_memory_view.dart';
import 'widgets/life_counter_view.dart';
import 'widgets/tournament_timer_view.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: scheme.primary.withValues(alpha: 0.2),
                border: Border.all(color: scheme.primary, width: 1.5),
              ),
              splashBorderRadius: BorderRadius.circular(24),
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.55),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
                Tab(text: l10n.toolsTabLife),
                Tab(text: l10n.toolsTabChakra),
                Tab(text: l10n.toolsTabDigimon),
                Tab(text: l10n.toolsTabCyberpunk),
                Tab(text: l10n.toolsTabDice),
                Tab(text: l10n.toolsTabTimer),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                LifeCounterView(),
                ChakraTrackerView(),
                DigimonMemoryView(),
                CyberpunkTrackerView(),
                DiceCoinView(),
                TournamentTimerView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

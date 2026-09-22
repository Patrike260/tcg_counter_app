import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/l10n.dart';
import 'widgets/chakra_tracker_view.dart';
import 'widgets/cyberpunk_tracker_view.dart';
import 'widgets/dice_coin_view.dart';
import 'widgets/digimon_memory_view.dart';
import 'widgets/life_counter_view.dart';

Future<void> unlockToolOrientations() {
  return SystemChrome.setPreferredOrientations(DeviceOrientation.values);
}

Future<void> toggleToolTableOrientation(BuildContext context) async {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  if (isPortrait) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
  }
}

class ToolsRotateButton extends StatelessWidget {
  const ToolsRotateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return IconButton(
      tooltip: context.l10n.tooltipRotateView,
      icon: Icon(
        isPortrait ? Icons.stay_current_landscape : Icons.stay_current_portrait,
      ),
      onPressed: () => toggleToolTableOrientation(context),
    );
  }
}

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  @override
  void dispose() {
    unlockToolOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 5,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

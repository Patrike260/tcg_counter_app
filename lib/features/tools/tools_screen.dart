import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';
import '../matches/add_match_dialog.dart';
import '../settings/app_preferences_service.dart';
import 'tool_preset_model.dart';

const _playerAccents = [
  Color(0xFF7E57C2),
  Color(0xFFE53935),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
];

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  String? _selectedPresetId;
  late List<_PlayerSeat> _players;
  late bool _timerEnabled;
  late Duration _timerTotal;
  Duration _remaining = Duration.zero;
  bool _timerRunning = false;
  Timer? _clock;
  bool _initialized = false;

  ToolPreset _resolvePreset(List<ToolPreset> presets) {
    return presets.firstWhere(
      (preset) => preset.id == _selectedPresetId,
      orElse: () => presets.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _players = [];
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _applyPreset(ToolPreset preset, {required bool resetNames}) {
    final previous = resetNames ? const <_PlayerSeat>[] : _players;
    _selectedPresetId = preset.id;
    _players = List.generate(preset.clampedPlayerCount, (index) {
      final names = preset.defaultNames;
      final name = (!resetNames && index < previous.length)
          ? previous[index].name
          : names[index];
      return _PlayerSeat(name: name, lp: preset.startingLife);
    });
    _timerEnabled = preset.hasTimer && preset.timerMinutes > 0;
    _timerTotal = preset.hasTimer
        ? preset.timerDuration
        : Duration.zero;
    if (_timerTotal.inSeconds <= 0) {
      _timerTotal = const Duration(minutes: 50);
    }
    _remaining = preset.hasTimer ? preset.timerDuration : Duration.zero;
    _timerRunning = false;
    _clock?.cancel();
    _initialized = true;
  }

  void _toggleTimer(bool enabled) {
    setState(() {
      _timerEnabled = enabled;
      if (!enabled) {
        _timerRunning = false;
        _clock?.cancel();
      }
    });
  }

  void _startPauseTimer() {
    if (!_timerEnabled) return;
    if (_timerRunning) {
      _clock?.cancel();
      setState(() => _timerRunning = false);
      return;
    }
    if (_remaining.inSeconds <= 0) {
      setState(() => _remaining = _timerTotal);
    }
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        _clock?.cancel();
        setState(() {
          _remaining = Duration.zero;
          _timerRunning = false;
        });
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
    setState(() => _timerRunning = true);
  }

  void _resetTimer() {
    _clock?.cancel();
    setState(() {
      _remaining = _timerTotal;
      _timerRunning = false;
    });
  }

  void _addFiveMinutes() {
    setState(() {
      _remaining += const Duration(minutes: 5);
      _timerTotal += const Duration(minutes: 5);
    });
  }

  void _changeLp(int index, int delta) {
    setState(() {
      _players[index].lp = (_players[index].lp + delta).clamp(0, 999999);
    });
  }

  void _resetLife() {
    final presets = ref.read(appPreferencesProvider).toolPresets;
    if (presets.isEmpty) return;
    final preset = _resolvePreset(presets);
    setState(() {
      for (final player in _players) {
        player.lp = preset.startingLife;
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(1000).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _suggestedResult() {
    if (_players.length < 2) return 'win';
    final me = _players[0].lp;
    final opp = _players[1].lp;
    if (opp <= 0 && me > 0) return 'win';
    if (me <= 0 && opp > 0) return 'loss';
    if (me <= 0 && opp <= 0) return 'draw';
    return 'win';
  }

  String _suggestedScore() {
    if (_players.length == 2) {
      return '${_players[0].lp}-${_players[1].lp}';
    }
    return _players.map((p) => '${p.name} ${p.lp}').join(' / ');
  }

  Future<void> _openMatchDialog() async {
    List<Deck> decks = const [];
    try {
      decks = await ref.read(userDecksProvider.future);
    } catch (_) {}

    if (!mounted) return;
    if (decks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lege zuerst ein Deck an, um Matches zu erfassen.')),
      );
      return;
    }

    final selected = await showDialog<Deck>(
      context: context,
      builder: (ctx) => _DeckPickDialog(decks: decks),
    );
    if (selected == null || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AddMatchDialog(
        deckId: selected.id,
        gameId: selected.gameId,
        suggestedResult: _suggestedResult(),
        suggestedScore: _suggestedScore(),
        suggestedNotes: 'Life Counter: ${_suggestedScore()}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presets = ref.watch(appPreferencesProvider).toolPresets;
    if (presets.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Keine Tool-Presets vorhanden.')),
      );
    }

    final selected = _resolvePreset(presets);
    final selectedExists = presets.any((preset) => preset.id == _selectedPresetId);
    if (!_initialized || !selectedExists || _players.length != selected.clampedPlayerCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _applyPreset(selected, resetNames: true));
      });
    }

    final expired = _timerEnabled && _remaining.inSeconds <= 0;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: presets.map((preset) {
                      final isSelected = preset.id == selected.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(preset.name),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _applyPreset(preset, resetNames: true));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                _TimerBar(
                  enabled: _timerEnabled,
                  running: _timerRunning,
                  expired: expired,
                  label: _formatDuration(_remaining),
                  onToggle: _toggleTimer,
                  onStartPause: _startPauseTimer,
                  onReset: _resetTimer,
                  onAddFive: _addFiveMinutes,
                  onResetLife: _resetLife,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: _players.isEmpty
                  ? const SizedBox.shrink()
                  : _LifePlayerBoard(
                      players: _players,
                      steps: selected.lifeSteps,
                      useGrid: selected.clampedPlayerCount >= 3,
                      onChangeLp: _changeLp,
                      onRename: (index, name) {
                        setState(() => _players[index].name = name);
                      },
                    ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openMatchDialog,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Match erfassen'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerSeat {
  String name;
  int lp;

  _PlayerSeat({required this.name, required this.lp});
}

class _TimerBar extends StatelessWidget {
  final bool enabled;
  final bool running;
  final bool expired;
  final String label;
  final ValueChanged<bool> onToggle;
  final VoidCallback onStartPause;
  final VoidCallback onReset;
  final VoidCallback onAddFive;
  final VoidCallback onResetLife;

  const _TimerBar({
    required this.enabled,
    required this.running,
    required this.expired,
    required this.label,
    required this.onToggle,
    required this.onStartPause,
    required this.onReset,
    required this.onAddFive,
    required this.onResetLife,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A2A3C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              tooltip: enabled ? 'Timer aus' : 'Timer ein',
              onPressed: () => onToggle(!enabled),
              icon: Icon(
                enabled ? Icons.timer : Icons.timer_off_outlined,
                color: enabled ? Colors.amber : Colors.white54,
              ),
            ),
            Expanded(
              child: Text(
                enabled ? label : '--:--',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: !enabled
                      ? Colors.white38
                      : (expired ? Colors.redAccent : Colors.white),
                ),
              ),
            ),
            IconButton(
              tooltip: running ? 'Pause' : 'Start',
              onPressed: enabled ? onStartPause : null,
              icon: Icon(running ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              tooltip: 'Reset',
              onPressed: enabled ? onReset : null,
              icon: const Icon(Icons.replay),
            ),
            IconButton(
              tooltip: '+5 Min',
              onPressed: enabled ? onAddFive : null,
              icon: const Icon(Icons.more_time),
            ),
            IconButton(
              tooltip: 'LP zurücksetzen',
              onPressed: onResetLife,
              icon: const Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }
}

class _LifePlayerBoard extends StatelessWidget {
  final List<_PlayerSeat> players;
  final List<int> steps;
  final bool useGrid;
  final void Function(int index, int delta) onChangeLp;
  final void Function(int index, String name) onRename;

  _LifePlayerBoard({
    required this.players,
    required this.steps,
    required this.useGrid,
    required this.onChangeLp,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    if (useGrid || players.length >= 3) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final landscape = constraints.maxWidth >= 700;
          return GridView.count(
            crossAxisCount: landscape ? 4 : 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: landscape ? 1.05 : 0.92,
            children: [
              for (var i = 0; i < players.length; i++)
                _PlayerTile(
                  key: ValueKey('seat-$i'),
                  player: players[i],
                  accent: _playerAccents[i % _playerAccents.length],
                  steps: steps,
                  onDelta: (delta) => onChangeLp(i, delta),
                  onRename: (name) => onRename(i, name),
                ),
            ],
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth >= 720;
        final tiles = [
          for (var i = 0; i < players.length; i++)
            Expanded(
              child: _PlayerTile(
                key: ValueKey('duel-$i'),
                player: players[i],
                accent: _playerAccents[i % _playerAccents.length],
                steps: steps,
                onDelta: (delta) => onChangeLp(i, delta),
                onRename: (name) => onRename(i, name),
              ),
            ),
        ];
        if (sideBySide) {
          return Row(
            children: [
              tiles[0],
              const SizedBox(width: 8),
              tiles[1],
            ],
          );
        }
        return Column(
          children: [
            tiles[0],
            const SizedBox(height: 8),
            tiles[1],
          ],
        );
      },
    );
  }
}

class _PlayerTile extends StatefulWidget {
  final _PlayerSeat player;
  final Color accent;
  final List<int> steps;
  final ValueChanged<int> onDelta;
  final ValueChanged<String> onRename;

  const _PlayerTile({
    super.key,
    required this.player,
    required this.accent,
    required this.steps,
    required this.onDelta,
    required this.onRename,
  });

  @override
  State<_PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<_PlayerTile> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player.name);
  }

  @override
  void didUpdateWidget(covariant _PlayerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player.name != widget.player.name) {
      _nameController.text = widget.player.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _commitName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) widget.onRename(name);
  }

  @override
  Widget build(BuildContext context) {
    final defeated = widget.player.lp <= 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.accent.withValues(alpha: 0.55)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.accent.withValues(alpha: defeated ? 0.12 : 0.28),
            const Color(0xFF1E1E2C),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            onSubmitted: (_) => _commitName(),
            onTapOutside: (_) {
              _commitName();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Name',
            ),
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${widget.player.lp}',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: defeated ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: widget.steps.map((step) {
              final negative = step < 0;
              return FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: negative
                      ? Colors.red.withValues(alpha: 0.22)
                      : Colors.green.withValues(alpha: 0.22),
                  foregroundColor: negative ? Colors.redAccent : Colors.greenAccent,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () => widget.onDelta(step),
                child: Text(step > 0 ? '+$step' : '$step'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DeckPickDialog extends StatelessWidget {
  final List<Deck> decks;

  const _DeckPickDialog({required this.decks});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eigenes Deck wählen'),
      content: SizedBox(
        width: 360,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: decks.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final deck = decks[index];
            return ListTile(
              title: Text(deck.name),
              subtitle: Text(deck.gameName ?? 'Unbekanntes Spiel'),
              onTap: () => Navigator.of(context).pop(deck),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
}

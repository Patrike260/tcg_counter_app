import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../../decks/deck_model.dart';
import '../../decks/deck_repository.dart';
import '../../matches/add_match_dialog.dart';
import '../../settings/app_preferences_service.dart';
import '../life_preset_model.dart';

class LifeCounterView extends ConsumerStatefulWidget {
  const LifeCounterView({super.key});

  @override
  ConsumerState<LifeCounterView> createState() => _LifeTapBoardState();
}

class _LifeTapBoardState extends ConsumerState<LifeCounterView> {
  String? _appliedPresetId;
  int _you = 20;
  int _opponent = 20;

  bool get _gameOver => _you == 0 || _opponent == 0;

  void _applyPreset(LifePreset preset, {required bool resetLife}) {
    HapticFeedback.selectionClick();
    setState(() {
      _appliedPresetId = preset.id;
      if (resetLife) {
        _you = preset.safeStart;
        _opponent = preset.safeStart;
      }
    });
  }

  void _adjustYou(int delta) {
    setState(() => _you = (_you + delta).clamp(0, 99999));
  }

  void _adjustOpponent(int delta) {
    setState(() => _opponent = (_opponent + delta).clamp(0, 99999));
  }

  Future<void> _saveMatch() async {
    final l10n = context.l10n;
    List<Deck> resolved;
    try {
      resolved = await ref.read(userDecksProvider.future);
    } catch (_) {
      resolved = const [];
    }
    if (!mounted) return;
    if (resolved.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.needDeckForMatch)),
      );
      return;
    }

    final chosen = await showDialog<Deck>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseOwnDeck),
        content: SizedBox(
          width: 360,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: resolved.length,
            itemBuilder: (context, index) {
              final deck = resolved[index];
              return ListTile(
                title: Text(deck.name),
                subtitle: Text(deck.gameName ?? ''),
                onTap: () => Navigator.pop(ctx, deck),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;

    final result = _you == _opponent
        ? 'draw'
        : (_you > _opponent ? 'win' : 'loss');

    await showDialog<void>(
      context: context,
      builder: (_) => AddMatchDialog(
        deckId: chosen.id,
        gameId: chosen.gameId,
        suggestedResult: result,
        suggestedScore: '$_you-$_opponent',
        suggestedNotes: 'Life Counter: $_you – $_opponent',
      ),
    );
  }

  Future<void> _createPreset() async {
    final created = await showDialog<LifePreset>(
      context: context,
      builder: (_) => const _AddLifePresetDialog(),
    );
    if (created == null || !mounted) return;
    await ref.read(appPreferencesProvider.notifier).addCustomLifePreset(created);
    _applyPreset(created, resetLife: true);
  }

  String _presetLabel(LifePreset preset, AppLocalizations l10n) {
    switch (preset.id) {
      case 'mtg60':
        return l10n.lifePresetMtg60;
      case 'commander':
        return l10n.lifePresetCommander;
      case 'ygo':
        return l10n.lifePresetYgoName;
      default:
        return preset.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final prefs = ref.watch(appPreferencesProvider);
    final preset = prefs.resolvedLifePreset;

    if (_appliedPresetId == null) {
      _appliedPresetId = preset.id;
      _you = preset.safeStart;
      _opponent = preset.safeStart;
    } else if (_appliedPresetId != preset.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _applyPreset(preset, resetLife: true);
      });
    }

    return Column(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 2,
            child: _LifeTapSeat(
              name: l10n.lifeOpponent,
              life: _opponent,
              accent: scheme.tertiary,
              tapStep: preset.safeSmall,
              holdStep: preset.safeLarge,
              onChange: _adjustOpponent,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final item in prefs.lifePresets)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: item.id == preset.id,
                          label: Text(_presetLabel(item, l10n)),
                          onSelected: (_) {
                            ref
                                .read(appPreferencesProvider.notifier)
                                .setActiveLifePresetId(item.id);
                          },
                          onDeleted: item.isBuiltIn
                              ? null
                              : () {
                                  ref
                                      .read(appPreferencesProvider.notifier)
                                      .deleteCustomLifePreset(item.id);
                                },
                        ),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: Text(l10n.lifePresetAdd),
                      onPressed: _createPreset,
                    ),
                  ],
                ),
              ),
              if (_gameOver) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _saveMatch,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.saveMatch),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: _LifeTapSeat(
            name: l10n.lifeYou,
            life: _you,
            accent: scheme.primary,
            tapStep: preset.safeSmall,
            holdStep: preset.safeLarge,
            onChange: _adjustYou,
          ),
        ),
      ],
    );
  }
}

class _LifeTapSeat extends StatefulWidget {
  final String name;
  final int life;
  final Color accent;
  final int tapStep;
  final int holdStep;
  final ValueChanged<int> onChange;

  const _LifeTapSeat({
    required this.name,
    required this.life,
    required this.accent,
    required this.tapStep,
    required this.holdStep,
    required this.onChange,
  });

  @override
  State<_LifeTapSeat> createState() => _LifeTapSeatState();
}

class _LifeTapSeatState extends State<_LifeTapSeat> {
  String? _flash;
  Timer? _flashTimer;

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _apply(int delta) {
    HapticFeedback.selectionClick();
    widget.onChange(delta);
    setState(() => _flash = delta > 0 ? '+$delta' : '$delta');
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _flash = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: widget.accent.withValues(alpha: 0.14)),
            Row(
              children: [
                Expanded(
                  child: _LifeTapZone(
                    label: '-${widget.tapStep}',
                    align: Alignment.centerLeft,
                    onTap: () => _apply(-widget.tapStep),
                    onLongPress: () => _apply(-widget.holdStep),
                  ),
                ),
                Expanded(
                  child: _LifeTapZone(
                    label: '+${widget.tapStep}',
                    align: Alignment.centerRight,
                    onTap: () => _apply(widget.tapStep),
                    onLongPress: () => _apply(widget.holdStep),
                  ),
                ),
              ],
            ),
            IgnorePointer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: widget.accent,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${widget.life}',
                      style: TextStyle(
                        fontSize: widget.life >= 1000 ? 56 : 72,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _flash == null ? 0 : 1,
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      _flash ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: (_flash ?? '').startsWith('-')
                            ? Colors.redAccent
                            : Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LifeTapZone extends StatelessWidget {
  final String label;
  final Alignment align;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _LifeTapZone({
    required this.label,
    required this.align,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Align(
          alignment: align,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddLifePresetDialog extends StatefulWidget {
  const _AddLifePresetDialog();

  @override
  State<_AddLifePresetDialog> createState() => _AddLifePresetDialogState();
}

class _AddLifePresetDialogState extends State<_AddLifePresetDialog> {
  final _name = TextEditingController();
  final _start = TextEditingController(text: '20');
  final _small = TextEditingController(text: '1');
  final _large = TextEditingController(text: '5');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _start.dispose();
    _small.dispose();
    _large.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    final name = _name.text.trim();
    final start = int.tryParse(_start.text.trim());
    final small = int.tryParse(_small.text.trim());
    final large = int.tryParse(_large.text.trim());
    if (name.isEmpty || start == null || start < 1 || small == null || small < 1 || large == null || large < 1) {
      setState(() => _error = l10n.lifePresetInvalid);
      return;
    }
    Navigator.pop(
      context,
      LifePreset(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        startingLife: start,
        stepSmall: small,
        stepLarge: large < small ? small : large,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.lifePresetAdd),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.lifePresetName),
              textCapitalization: TextCapitalization.words,
            ),
            TextField(
              controller: _start,
              decoration: InputDecoration(labelText: l10n.lifePresetStartLp),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _small,
              decoration: InputDecoration(labelText: l10n.lifePresetStepSmall),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _large,
              decoration: InputDecoration(labelText: l10n.lifePresetStepLarge),
              keyboardType: TextInputType.number,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.create),
        ),
      ],
    );
  }
}

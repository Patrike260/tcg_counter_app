import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tools/tool_preset_model.dart';
import 'app_preferences_service.dart';

class ToolPresetsScreen extends ConsumerWidget {
  const ToolPresetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(appPreferencesProvider).toolPresets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool-Presets'),
        actions: [
          IconButton(
            tooltip: 'Auf Werkseinstellungen zurücksetzen',
            icon: const Icon(Icons.restore),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Werkseinstellungen?'),
                  content: const Text(
                    'Alle eigenen Presets werden durch 1vs1, Commander und 8000 LP ersetzt.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Abbrechen'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Zurücksetzen'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(appPreferencesProvider.notifier).resetToDefaultPresets();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: presets.isEmpty
          ? const Center(child: Text('Keine Presets vorhanden.'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: presets.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final preset = presets[index];
                return Card(
                  child: ListTile(
                    title: Text(preset.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(preset.summary),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Bearbeiten',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openEditor(context, ref, preset),
                        ),
                        IconButton(
                          tooltip: 'Löschen',
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () async {
                            if (presets.length <= 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mindestens ein Preset muss erhalten bleiben.'),
                                ),
                              );
                              return;
                            }
                            final deleted = await ref
                                .read(appPreferencesProvider.notifier)
                                .deleteToolPreset(preset.id);
                            if (!deleted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mindestens ein Preset muss erhalten bleiben.'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref, ToolPreset? preset) async {
    final result = await showDialog<ToolPreset>(
      context: context,
      builder: (_) => _PresetEditorDialog(preset: preset),
    );
    if (result == null) return;
    final notifier = ref.read(appPreferencesProvider.notifier);
    if (preset == null) {
      await notifier.addToolPreset(result);
    } else {
      await notifier.updateToolPreset(result);
    }
  }
}

class _PresetEditorDialog extends StatefulWidget {
  final ToolPreset? preset;

  const _PresetEditorDialog({this.preset});

  @override
  State<_PresetEditorDialog> createState() => _PresetEditorDialogState();
}

class _PresetEditorDialogState extends State<_PresetEditorDialog> {
  static const _minuteChoices = [30, 45, 50];

  late final TextEditingController _nameController;
  late final TextEditingController _lifeController;
  late int _playerCount;
  late bool _hasTimer;
  late int _timerMinutes;

  @override
  void initState() {
    super.initState();
    final preset = widget.preset;
    _nameController = TextEditingController(text: preset?.name ?? '');
    _lifeController = TextEditingController(text: '${preset?.startingLife ?? 20}');
    _playerCount = preset?.clampedPlayerCount ?? 2;
    _hasTimer = preset?.hasTimer ?? true;
    _timerMinutes = (preset?.timerMinutes ?? 50) <= 0 ? 50 : preset!.timerMinutes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lifeController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final life = int.tryParse(_lifeController.text.trim());
    if (name.isEmpty || life == null || life <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Name und gültige Start-LP angeben.')),
      );
      return;
    }

    Navigator.of(context).pop(
      ToolPreset(
        id: widget.preset?.id ?? 'preset_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        playerCount: _playerCount,
        startingLife: life,
        hasTimer: _hasTimer,
        timerMinutes: _hasTimer ? _timerMinutes : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.preset != null;
    return AlertDialog(
      title: Text(isEdit ? 'Preset bearbeiten' : 'Neues Preset'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Spieleranzahl', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 2, label: Text('2')),
                  ButtonSegment(value: 3, label: Text('3')),
                  ButtonSegment(value: 4, label: Text('4')),
                ],
                selected: {_playerCount},
                onSelectionChanged: (set) => setState(() => _playerCount = set.first),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lifeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Start-LP',
                  hintText: '20, 40 oder 8000',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Rundentimer'),
                value: _hasTimer,
                onChanged: (value) => setState(() => _hasTimer = value),
              ),
              if (_hasTimer) ...[
                const Text('Minuten', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _minuteChoices.map((minutes) {
                    return ChoiceChip(
                      label: Text('$minutes Min'),
                      selected: _timerMinutes == minutes,
                      onSelected: (_) => setState(() => _timerMinutes = minutes),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Speichern' : 'Hinzufügen'),
        ),
      ],
    );
  }
}

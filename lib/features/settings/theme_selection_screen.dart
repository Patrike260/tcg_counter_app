import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme_presets.dart';
import '../../l10n/l10n.dart';
import 'app_preferences_service.dart';

class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(appPreferencesProvider).themePreset;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.themeScreenTitle),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppThemePreset.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.86,
        ),
        itemBuilder: (context, index) {
          final preset = AppThemePreset.values[index];
          return _ThemePresetTile(
            preset: preset,
            isSelected: preset == selected,
            onTap: () {
              ref.read(appPreferencesProvider.notifier).setThemePreset(preset);
            },
          );
        },
      ),
    );
  }
}

class _ThemePresetTile extends StatelessWidget {
  final AppThemePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePresetTile({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = preset.palette;
    final title = getThemeTitle(preset);
    final isLight = palette.isLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: palette.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? palette.primaryColor
                  : palette.primaryColor.withValues(alpha: 0.35),
              width: isSelected ? 2.4 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: palette.primaryColor, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: palette.primaryColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: palette.primaryColor.withValues(alpha: 0.45)),
                  ),
                  child: Text(
                    isLight ? context.l10n.themeLight : context.l10n.themeDark,
                    style: TextStyle(
                      color: palette.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: palette.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: palette.textColor.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: palette.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: palette.cardBorderColor != null
                              ? Border.all(color: palette.cardBorderColor!, width: 1.3)
                              : (isLight
                                  ? Border.all(color: Colors.black.withValues(alpha: 0.08))
                                  : null),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            for (var i = 0; i < palette.previewAccents.length; i++) ...[
                              if (i > 0) const SizedBox(width: 8),
                              _AccentDot(color: palette.previewAccents[i]),
                            ],
                            const Spacer(),
                            Text(
                              'Aa',
                              style: TextStyle(
                                color: palette.textColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  final Color color;

  const _AccentDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26, width: 1.2),
      ),
    );
  }
}

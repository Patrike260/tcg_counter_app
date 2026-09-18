import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/l10n.dart';
import '../../settings/app_preferences_service.dart';

const kPartnerPromoUrl =
    'https://www.cardmarket.com/de/Pokemon?utm_source=tcg_counter_app&idPartner=wowe260';

const _kCardmarketNavy = Color(0xFF0D253F);
const _kCardmarketBlue = Color(0xFF005599);
const _kCardmarketAccent = Color(0xFF0070BA);
const _kCardmarketCyan = Color(0xFF7FDBFF);

final promoBannerSessionHiddenProvider =
    NotifierProvider<PromoBannerSessionHidden, bool>(PromoBannerSessionHidden.new);

class PromoBannerSessionHidden extends Notifier<bool> {
  @override
  bool build() => false;

  void hide() => state = true;

  void reveal() => state = false;
}

class PromoBannerWidget extends ConsumerWidget {
  const PromoBannerWidget({super.key});

  Future<void> _openPartner(BuildContext context) async {
    final uri = Uri.parse(kPartnerPromoUrl);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.promoOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    final hiddenForSession = ref.watch(promoBannerSessionHiddenProvider);
    if (!prefs.showPromoBanner || hiddenForSession) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openPartner(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _kCardmarketNavy,
                Color.lerp(_kCardmarketNavy, scheme.surface, 0.22) ??
                    const Color(0xFF12324F),
              ],
            ),
            border: Border.all(
              color: _kCardmarketAccent.withValues(alpha: 0.5),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _kCardmarketBlue,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _kCardmarketCyan.withValues(alpha: 0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kCardmarketAccent.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _kCardmarketCyan.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          l10n.promoBadge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: _kCardmarketCyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.promoHeadline,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.promoSubtitle,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: l10n.promoDismiss,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      iconSize: 16,
                      onPressed: () {
                        ref.read(promoBannerSessionHiddenProvider.notifier).hide();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: _kCardmarketAccent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.promoView,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

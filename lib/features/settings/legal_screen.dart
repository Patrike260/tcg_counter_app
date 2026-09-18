import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/l10n.dart';

const _kProjectGithub = 'https://github.com/Patrike260/tcg_counter_app';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  Future<void> _openGithub() async {
    await launchUrl(
      Uri.parse(_kProjectGithub),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.legalScreenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _LegalSectionBlock(
            icon: Icons.copyright_outlined,
            title: l10n.legalTrademarksTitle,
            body: l10n.legalTrademarksBody,
          ),
          const SizedBox(height: 12),
          _LegalSectionBlock(
            icon: Icons.privacy_tip_outlined,
            title: l10n.legalPrivacyStructuredTitle,
            body: l10n.legalPrivacyStructuredBody,
          ),
          const SizedBox(height: 12),
          _LegalSectionBlock(
            icon: Icons.handshake_outlined,
            title: l10n.legalAffiliateTitle,
            body: l10n.legalAffiliateBody,
          ),
          const SizedBox(height: 12),
          _LegalSectionBlock(
            icon: Icons.badge_outlined,
            title: l10n.legalContactStructuredTitle,
            body: l10n.legalContactStructuredBody,
            footer: TextButton.icon(
              onPressed: _openGithub,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l10n.legalGithub),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalSectionBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? footer;

  const _LegalSectionBlock({
    required this.icon,
    required this.title,
    required this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                height: 1.45,
                color: scheme.onSurface.withValues(alpha: 0.86),
              ),
            ),
            if (footer != null) ...[
              const SizedBox(height: 8),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

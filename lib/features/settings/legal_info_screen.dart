import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({super.key});

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
          Text(
            l10n.legalIntro,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          _LegalTopicTile(
            icon: Icons.description_outlined,
            title: l10n.legalTermsTitle,
            body: l10n.legalTermsBody,
          ),
          const SizedBox(height: 12),
          _LegalTopicTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.legalPrivacyTitle,
            body: l10n.legalPrivacyBody,
          ),
          const SizedBox(height: 12),
          _LegalTopicTile(
            icon: Icons.copyright_outlined,
            title: l10n.legalDisclaimerTitle,
            body: l10n.legalDisclaimerBody,
          ),
          const SizedBox(height: 12),
          _LegalTopicTile(
            icon: Icons.badge_outlined,
            title: l10n.legalImprintTitle,
            body: l10n.legalImprintBody,
          ),
        ],
      ),
    );
  }
}

class _LegalTopicTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _LegalTopicTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body),
        ],
      ),
    );
  }
}

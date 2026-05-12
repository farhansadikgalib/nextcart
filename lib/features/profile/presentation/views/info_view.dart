import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';

/// Reusable static-content page for Privacy, Help, and Terms.
class InfoView extends StatelessWidget {
  const InfoView({super.key, required this.kind});

  final InfoKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spec = _specs[kind]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(spec.title),
        leading: const IosBackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                FaIcon(spec.icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    spec.tagline,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final section in spec.sections) ...[
            Text(
              section.heading,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              section.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
          ],
          const SizedBox(height: 8),
          Center(
            child: Text(
              'NextCart · v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum InfoKind { privacy, help, terms }

class _Section {
  const _Section(this.heading, this.body);
  final String heading;
  final String body;
}

class _Spec {
  const _Spec({
    required this.title,
    required this.tagline,
    required this.icon,
    required this.sections,
  });
  final String title;
  final String tagline;
  final IconData icon;
  final List<_Section> sections;
}

const _specs = <InfoKind, _Spec>{
  InfoKind.privacy: _Spec(
    title: 'Privacy Policy',
    tagline: 'Your data stays yours. Here is what we collect and why.',
    icon: FontAwesomeIcons.shieldHalved,
    sections: [
      _Section(
        'What we collect',
        'We only collect what we need to deliver your orders: your name, email, phone, address, and order history. We do not sell your data.',
      ),
      _Section(
        'How we use it',
        'Account information is used to authenticate you and ship orders. Anonymous usage signals help us fix crashes and improve the app.',
      ),
      _Section(
        'Third parties',
        'We use Firebase (Google) for authentication, database, and storage. No marketing trackers are embedded in this app.',
      ),
      _Section(
        'Your rights',
        'You can request a copy of your data or have your account deleted at any time. Contact us via Help & Support.',
      ),
    ],
  ),
  InfoKind.help: _Spec(
    title: 'Help & Support',
    tagline: 'Need a hand? We respond within one business day.',
    icon: FontAwesomeIcons.lifeRing,
    sections: [
      _Section(
        'Order issues',
        'For wrong, missing, or damaged items, open the order from My Orders and tap "Report a problem". We will sort it.',
      ),
      _Section(
        'Delivery questions',
        'Most orders ship within 24h and arrive in 2–4 business days. Cash on Delivery is supported on all standard orders.',
      ),
      _Section(
        'Account & payments',
        'You can sign in with your Google account. Update your phone and delivery address from Profile › Address.',
      ),
      _Section(
        'Contact us',
        'Email: support@nextcart.app · Hours: Sun–Thu, 9am–6pm.',
      ),
    ],
  ),
  InfoKind.terms: _Spec(
    title: 'Terms of Service',
    tagline: 'The agreement between you and NextCart.',
    icon: FontAwesomeIcons.fileLines,
    sections: [
      _Section(
        'Use of service',
        'You agree to use NextCart only for lawful shopping activity. You are responsible for the accuracy of the information you provide.',
      ),
      _Section(
        'Orders & payments',
        'Prices and stock are subject to change. We reserve the right to cancel orders if a product is mispriced or unavailable.',
      ),
      _Section(
        'Returns',
        'Items can be returned within 7 days of delivery in original condition. Some categories are non-returnable.',
      ),
      _Section(
        'Liability',
        'NextCart is provided "as is". We are not liable for indirect damages arising from your use of the app.',
      ),
    ],
  ),
};

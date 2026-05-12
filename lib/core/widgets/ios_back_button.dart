import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Drop-in AppBar `leading` that renders an iOS-style chevron-left and pops
/// the current route. Use everywhere we'd otherwise rely on Material's
/// default `arrow_back`.
class IosBackButton extends StatelessWidget {
  const IosBackButton({super.key, this.onTap, this.color});

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: FaIcon(
        FontAwesomeIcons.chevronLeft,
        size: 18,
        color: color,
      ),
      onPressed: onTap ?? () => Navigator.of(context).maybePop(),
    );
  }
}

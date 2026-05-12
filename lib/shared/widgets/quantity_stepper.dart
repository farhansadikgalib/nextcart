import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.dense = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool dense;

  void _set(int next) {
    if (next < min || next > max) return;
    HapticFeedback.selectionClick();
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = dense ? 32.0 : 40.0;
    final iconSize = dense ? 16.0 : 20.0;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: iconSize,
            constraints: BoxConstraints(minHeight: size, minWidth: size),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: value > min ? () => _set(value - 1) : null,
            icon: const FaIcon(FontAwesomeIcons.minus),
          ),
          SizedBox(
            width: dense ? 24 : 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            iconSize: iconSize,
            constraints: BoxConstraints(minHeight: size, minWidth: size),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: value < max ? () => _set(value + 1) : null,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
    );
  }
}

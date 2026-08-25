import 'package:flutter/material.dart';

import '../../core/utils/extensions/context_extensions.dart';

/// Unified placeholder for any feature not yet implemented (foundation branch only); every upcoming feature branch (patrick-auth, squidward-home, plankton-map, mrkrabs-complaints, sandy-profile...) replaces this widget's usage with its real Figma-matching implementation. Deliberately lives in common/widgets/, not core/widgets/: core/ is for infrastructure (DI, routing, theme, error handling...), while common/ is shared UI that isn't infrastructure and isn't tied to a specific business domain — unlike e.g. StatusBadge, which lives in features/complaints/ because it knows complaint-domain details.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.construction_outlined, size: 56),
              const SizedBox(height: 16),
              Text(
                context.l10n.placeholderScreenMessage,
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

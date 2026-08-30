import 'package:flutter/material.dart';

import '../utils/extensions/context_extensions.dart';

/// Unified empty state; like [ErrorView], each feature supplies its own message in the app's
/// voice, not a generic string.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: context.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message ?? context.l10n.genericEmptyMessage,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

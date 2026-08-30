import 'package:flutter/widgets.dart';

import 'extensions/context_extensions.dart';

/// Resolves an ARB-key string (returned by [Failure.message] or a [Validators] function) to its
/// localized text. Unrecognized strings are treated as already-human-readable server copy only
/// when the active locale is Arabic; any other locale falls back to the generic error so raw
/// Arabic mock-server text cannot leak into English or German UI.
String resolveMessageKey(BuildContext context, String key) {
  final l10n = context.l10n;
  return switch (key) {
    'noInternetConnectionMessage' => l10n.noInternetConnectionMessage,
    'unauthorizedMessage' => l10n.unauthorizedMessage,
    'validationRequired' => l10n.validationRequired,
    'validationInvalidEmail' => l10n.validationInvalidEmail,
    'validationPasswordTooShort' => l10n.validationPasswordTooShort,
    'validationPasswordTooWeak' => l10n.validationPasswordTooWeak,
    'validationPasswordMismatch' => l10n.validationPasswordMismatch,
    'validationTooLong' => l10n.validationTooLong,
    'genericErrorMessage' => l10n.genericErrorMessage,
    _ => Localizations.localeOf(context).languageCode == 'ar'
        ? key
        : l10n.genericErrorMessage,
  };
}

import 'package:flutter/widgets.dart';

import 'extensions/context_extensions.dart';

/// Resolves an ARB-key string (returned by [Failure.message] or a [Validators] function) to its
/// localized text; centralized here instead of every Cubit/widget repeating its own switch.
///
/// [ServerFailure.message] is a special case: it's often the mock/real backend's own already-Arabic
/// message (e.g. "الإيميل ده مستخدم بالفعل يا جار"), not one of our fixed ARB keys — any string that
/// doesn't match a known key below is assumed to already be human-readable server text and is returned
/// as-is, rather than being swallowed into a generic error message.
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
    _ => key,
  };
}

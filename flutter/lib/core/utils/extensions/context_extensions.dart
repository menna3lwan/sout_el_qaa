import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Common [BuildContext] shortcuts that cut down repetition (Theme.of(context), AppLocalizations.of(context)!) in every widget.
extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
}

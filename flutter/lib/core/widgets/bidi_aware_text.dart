import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show Bidi;

/// Isolates a user-generated string in its own detected direction so an English/German title
/// or a leading number does not scramble the surrounding Arabic (or vice versa).
class BidiAwareText extends StatelessWidget {
  const BidiAwareText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final isRtl = Bidi.detectRtlDirectionality(data);
    return Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
    );
  }
}

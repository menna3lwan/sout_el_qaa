import 'package:flutter_test/flutter_test.dart';
import 'package:sout_el_qaa/core/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('returns error key when value is null', () {
      expect(Validators.required(null), 'validationRequired');
    });

    test('returns error key when value is empty or whitespace only', () {
      expect(Validators.required(''), 'validationRequired');
      expect(Validators.required('   '), 'validationRequired');
    });

    test('returns null when value has content', () {
      expect(Validators.required('شفيق'), isNull);
    });
  });

  group('Validators.email', () {
    test('rejects null or empty', () {
      expect(Validators.email(null), 'validationRequired');
      expect(Validators.email(''), 'validationRequired');
    });

    test('rejects malformed email', () {
      expect(Validators.email('not-an-email'), 'validationInvalidEmail');
      expect(Validators.email('missing@domain'), 'validationInvalidEmail');
      expect(Validators.email('@no-local-part.com'), 'validationInvalidEmail');
    });

    test('accepts well-formed email', () {
      expect(Validators.email('resident@qaa-el-hamour.eg'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty password', () {
      expect(Validators.password(''), 'validationRequired');
    });

    test('rejects password shorter than 8 characters', () {
      expect(Validators.password('ab1'), 'validationPasswordTooShort');
    });

    test('rejects password without both letters and digits', () {
      expect(Validators.password('onlyletters'), 'validationPasswordTooWeak');
      expect(Validators.password('12345678'), 'validationPasswordTooWeak');
    });

    test('accepts a password with letters, digits, and 8+ chars', () {
      expect(Validators.password('qaaHamour1'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects empty confirmation', () {
      expect(
          Validators.confirmPassword('', 'qaaHamour1'), 'validationRequired');
    });

    test('rejects mismatch', () {
      expect(
        Validators.confirmPassword('different1', 'qaaHamour1'),
        'validationPasswordMismatch',
      );
    });

    test('accepts exact match', () {
      expect(Validators.confirmPassword('qaaHamour1', 'qaaHamour1'), isNull);
    });
  });

  group('Validators.complaintDescription', () {
    test('rejects empty description', () {
      expect(Validators.complaintDescription(''), 'validationRequired');
      expect(Validators.complaintDescription('   '), 'validationRequired');
    });

    test('accepts description at exactly the 300-char limit', () {
      final exactly300 = 'ح' * 300;
      expect(Validators.complaintDescription(exactly300), isNull);
    });

    test('rejects description over the 300-char limit (confirmed by Figma)',
        () {
      final over300 = 'ح' * 301;
      expect(Validators.complaintDescription(over300), 'validationTooLong');
    });

    test('accepts a normal description', () {
      expect(
        Validators.complaintDescription('شهر كامل والحفرة في نص الشارع بتكبر'),
        isNull,
      );
    });
  });
}

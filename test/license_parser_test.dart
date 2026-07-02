import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_license_manager/flutter_license_manager.dart';

void main() {
  group('LicenseParser.formatLicenseParagraphs', () {
    test('renders a single paragraph without a trailing newline', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('hello', 0)],
      );
      expect(out, 'hello');
    });

    test('applies two spaces of indent per indent level', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('hello', 2)],
      );
      expect(out, '    hello'); // indent 2 -> 4 spaces
    });

    test('normalizes CRLF and lone CR to LF', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('a\r\nb\rc', 0)],
      );
      expect(out, 'a\nb\nc');
    });

    test('keeps blank lines but does not indent them', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('a\n \nb', 1)],
      );
      expect(out, '  a\n\n  b');
    });

    test('joins multiple paragraphs with newlines', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('first', 0), LicenseParagraph('second', 0)],
      );
      expect(out, 'first\nsecond');
    });

    test('an empty paragraph becomes a blank line', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [
          LicenseParagraph('a', 0),
          LicenseParagraph('', 0),
          LicenseParagraph('b', 0),
        ],
      );
      expect(out, 'a\n\nb');
    });

    test('an empty paragraph list yields an empty string', () {
      expect(LicenseParser.formatLicenseParagraphs(const []), '');
    });
  });
}

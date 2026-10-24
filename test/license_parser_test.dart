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

  group('LicenseParser.formatLicenseParagraphs — centeredIndent', () {
    const centered = LicenseParagraph.centeredIndent;

    test('centers against the longest line of the entry', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [
          LicenseParagraph('ABCDEFGHIJ', 0),
          LicenseParagraph('MIT', centered)
        ],
      );
      expect(out, 'ABCDEFGHIJ\n   MIT'); // (10 - 3) ~/ 2 = 3
    });

    test('counts indentation toward the longest line', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('abcd', 1), LicenseParagraph('xx', centered)],
      );
      expect(out, '  abcd\n  xx'); // longest is '  abcd' (6)
    });

    test('a centered line that is the longest gets no padding', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [
          LicenseParagraph('LONG CENTERED TITLE', centered),
          LicenseParagraph('short', 0),
        ],
      );
      expect(out, 'LONG CENTERED TITLE\nshort');
    });

    test('centers each line of a multi-line centered paragraph', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [LicenseParagraph('abcdef\nab', centered)],
      );
      expect(out, 'abcdef\n  ab');
    });

    test('an empty centered paragraph is a blank line', () {
      final out = LicenseParser.formatLicenseParagraphs(
        const [
          LicenseParagraph('abcd', 0),
          LicenseParagraph('', centered),
          LicenseParagraph('ab', centered),
        ],
      );
      expect(out, 'abcd\n\n ab');
    });
  });
}

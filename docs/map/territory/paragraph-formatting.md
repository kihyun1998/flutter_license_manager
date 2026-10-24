# paragraph-formatting

## What it is
Turns a registry entry's `LicenseParagraph`s into one plain-text string that keeps the license's indentation and line structure (`LicenseParser.formatLicenseParagraphs`).

## Governing decisions
**None.** The CHANGELOG's 2.0.1 entry records the carriage-return fix as a change, not a decision.

## Design model
From the source and `test/license_parser_test.dart`:

- Line endings: `\r\n` → `\n`, then a lone `\r` → `\n` (CHANGELOG 2.0.1; test *"normalizes CRLF and lone CR to LF"*).
- Indent: two spaces per indent level, applied to every non-blank line of a multi-line paragraph (test *"applies two spaces of indent per indent level"*).
- Blank lines are kept, without indent; an empty paragraph becomes a blank line (tests *"keeps blank lines…"*, *"an empty paragraph becomes a blank line"*).
- Paragraphs join with `\n` with no trailing newline; no paragraphs give `''`.
- A centered paragraph (`indent == LicenseParagraph.centeredIndent`, `-1`) is centered against the longest line of the whole entry, indentation counted. Plain text has no width of its own, and the detail view is monospace, so the longest line is what *centered* can mean here (maintainer, 2026-10-24). A line is padded on the left only; the longest line gets none (tests in the *centeredIndent* group).
- Only registry texts pass through here. Custom texts never do — see [custom-licenses](custom-licenses.md).

## Code
- `lib/src/utils/license_parser.dart — LicenseParser.formatLicenseParagraphs`

## Reference behaviour
- [Flutter `foundation/licenses.dart` at 3.41.9 — `LicenseParagraph`](https://github.com/flutter/flutter/blob/3.41.9/packages/flutter/lib/src/foundation/licenses.dart) — binding. It settles: `indent` counts steps, `centeredIndent` is `-1` and means *centered*, paragraph text "should not have any leading or trailing whitespace", and newlines inside a paragraph are allowed but discouraged.
- [Dart `String.operator *`](https://github.com/dart-lang/sdk/blob/main/sdk/lib/core/string.dart) — "Returns an empty string if [times] is zero or negative". Before the centered fix, `' ' * (-1 * 2)` silently produced no indent, which is why centered paragraphs rendered flush left.

## Cross-cutting invariants
**None.**

## Blast radius
- [consolidation](consolidation.md) — dedup compares the formatted strings verbatim, so any change to the output changes which registry text matches a custom copy of the same license.
- [example-app](example-app.md) — the detail view shows the text in a monospace `SelectableText`; space indentation reads as structure only there.

## Known holes / open
**None.**

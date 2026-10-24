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
- Paragraphs join with `\n`, and the single trailing newline is removed; no paragraphs give `''`.
- Only registry texts pass through here. Custom texts never do — see [custom-licenses](custom-licenses.md).

## Code
- `lib/src/utils/license_parser.dart — LicenseParser.formatLicenseParagraphs`

## Reference behaviour
- [Flutter `foundation/licenses.dart` at 3.41.9 — `LicenseParagraph`](https://github.com/flutter/flutter/blob/3.41.9/packages/flutter/lib/src/foundation/licenses.dart) — binding. It settles: `indent` counts steps, `centeredIndent` is `-1` and means *centered*, paragraph text "should not have any leading or trailing whitespace", and newlines inside a paragraph are allowed but discouraged.
- [Dart `String.operator *`](https://github.com/dart-lang/sdk/blob/main/sdk/lib/core/string.dart) — "Returns an empty string if [times] is zero or negative", which is what decides the centered case below.

## Cross-cutting invariants
**None.**

## Blast radius
- [consolidation](consolidation.md) — dedup compares the formatted strings verbatim, so any change to the output changes which registry text matches a custom copy of the same license.
- [example-app](example-app.md) — the detail view shows the text in a monospace `SelectableText`; space indentation reads as structure only there.

## Known holes / open
- **Bug: centered paragraphs lose their centering.** `indent == LicenseParagraph.centeredIndent` (`-1`) gives `' ' * -2`, an empty string, so the paragraph renders flush left. The binding reference says it is centered. Confirmed by reading both sources; no test covers it. Recorded as a bug (maintainer, 2026-10-24).

# registry-loading

## What it is
Reads every license an app has registered with Flutter's `LicenseRegistry`, turns each entry into package records, appends the caller's custom licenses, and hands the lot to consolidation. It is the package's one entry point (`LicenseService.loadFromLicenseRegistry`).

## Governing decisions
**None.** No decision records exist. The CHANGELOG's 3.0.0 entry (one record per package) governs the record this area produces, not how it reads the registry — see [license-record](license-record.md).

## Design model
From the source and `test/flutter_license_manager_test.dart`; no record states these.

- Every `LicenseEntry` is formatted once (`LicenseParser.formatLicenseParagraphs`) and that one text is given to each of its packages: a multi-package entry is **exploded** into one record per package (`loadFromLicenseRegistry`; test *"explodes a multi-package registry entry"*).
- An entry with no packages is skipped; a package name is trimmed, and a blank one is skipped (`loadFromLicenseRegistry`).
- Custom licenses are appended **after** all registry records, unmodified (`licenses.addAll(customLicenses)`). Order matters downstream: see Blast radius.
- Any error — a failing collector included — is printed with `debugPrint` and rethrown (`loadFromLicenseRegistry`; test *"rethrows when a license collector fails"*).
- Each call reads the whole registry again: `LicenseRegistry.licenses` re-runs every collector on listen ([Flutter `licenses.dart` — `LicenseRegistry.licenses`](https://github.com/flutter/flutter/blob/3.41.9/packages/flutter/lib/src/foundation/licenses.dart)).
- **Input bound:** none. The entry count and text size are whatever the app's dependencies registered, and all of it is held in memory as one list.

## Code
- `lib/src/services/license_service.dart — LicenseService.loadFromLicenseRegistry`
- `lib/flutter_license_manager.dart` — the library's exports (the public surface)

## Reference behaviour
- [Flutter `foundation/licenses.dart` at 3.41.9](https://github.com/flutter/flutter/blob/3.41.9/packages/flutter/lib/src/foundation/licenses.dart) — binding (`docs/agents/thegraph.md`). It settles: `licenses` is a `Stream<LicenseEntry>` built fresh per listen, collectors run in registration order, and the docs call generating it "expensive". The version is the one CI pins (`.github/workflows/ci.yml — FLUTTER_VERSION`).

## Cross-cutting invariants
**None.**

## Blast radius
- [consolidation](consolidation.md) — it keeps the **first** record's casing for a merged name, and registry records always come before custom ones, so changing the append order changes which casing survives.
- [license-record](license-record.md) — the one-package-per-record rule is enforced only here; stop exploding and the model's single-identity promise is false.
- [paragraph-formatting](paragraph-formatting.md) — every registry text passes through it exactly once, here.
- [example-app](example-app.md) — `loadAppLicenses` calls this up to twice at startup, so its cost doubles there.

## Known holes / open
- Nothing bounds the registry's size (see Design model).
- An entry is formatted before the empty-packages check, so a skipped entry still pays for formatting (reading, `loadFromLicenseRegistry`).

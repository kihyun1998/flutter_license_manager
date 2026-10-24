# consolidation

## What it is
Makes the final list one record per package: records whose names match are merged, verbatim-duplicate texts are dropped, and the result is sorted (`LicenseService._consolidateSamePackages`, `_mergeMultipleLicenses`).

## Governing decisions
**None** as records. The CHANGELOG's 3.0.0 *Changed* entry and commit `5aca307` (#5) introduced the text dedup.

## Design model
From the source and the `loadFromLicenseRegistry` tests:

- Names match on `toLowerCase().trim()` (test *"consolidates same-name records case-insensitively, then sorts"*).
- A merged record keeps the **first** record's `packageName`, untrimmed casing included.
- Texts are merged in first-seen order and an exact repeat is dropped; distinct texts are all kept (tests *"drops identical license texts…"*, *"preserves distinct license texts, in order…"*). Equality is exact string equality, nothing looser.
- The list is sorted by `packageName.toLowerCase()` — not trimmed, unlike the merge key.

## Code
- `lib/src/services/license_service.dart — LicenseService._consolidateSamePackages`
- `lib/src/services/license_service.dart — LicenseService._mergeMultipleLicenses`

## Reference behaviour
**None.** Flutter's own `LicensePage` groups by package too, but this area was never compared to it.

## Cross-cutting invariants
**None.**

## Blast radius
- [license-record](license-record.md) — `licenseCount` and `hasMultipleLicenses` are read off the deduplicated list, so a dedup change changes what they report.
- [example-app](example-app.md) — the dialog keys its detail view on `packageName`, which assumes names are unique after merging.

## Known holes / open
- A custom name with surrounding spaces merges as trimmed but sorts with its spaces, and keeps them on screen when it is the first record (reading, `_consolidateSamePackages`).
- A registry text and a custom copy of the same license rarely match, because only the registry text was formatted — see [custom-licenses](custom-licenses.md).

# license-record

## What it is
`OssLicenseInfo`, the one public data type: a package name and its license texts. Everything the package returns is a list of these.

## Governing decisions
**None** as records. The CHANGELOG's 3.0.0 *BREAKING CHANGES* entry and commit `6e36202` (#1) made the record single-package; commit `21e3144` made `licenseCount` derived.

## Design model
- `packageName` names **exactly one package** and is opaque; a comma in it means nothing (doc comment on `OssLicenseInfo.packageName`; test *"packageName is one opaque identity"*). The loader is what makes this true — see [registry-loading](registry-loading.md). A custom record is trusted to follow it; nothing checks.
- `licenseCount` is derived from `licenseTexts.length` and cannot desync (`OssLicenseInfo.licenseCount`).
- `hasMultipleLicenses` is `licenseTexts.length > 1`.
- Nothing is validated in the constructor, and the `licenseTexts` list is the caller's own list, not a copy (reading, `OssLicenseInfo`).

## Code
- `lib/src/models/oss_license_info.dart — OssLicenseInfo`, `.licenseCount`, `.hasMultipleLicenses`, `.toString`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [publishing](publishing.md) — this is the public API; a field or getter change is a breaking release with a CHANGELOG migration section, as 3.0.0 was.
- [example-app](example-app.md) — the list and the detail view show `packageName` and `licenseCountLabel(licenseCount)`.

## Known holes / open
- A caller can mutate `licenseTexts` after construction (reading).

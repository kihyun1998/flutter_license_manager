# custom-licenses

## What it is
Lets an app add licenses Flutter's registry does not know about — a native DLL, a C++ library — through `LicenseService.createCustomLicense` and the `customLicenses` argument of `loadFromLicenseRegistry`.

## Governing decisions
**None** as records. Commit `f3d6446` (#3) documented `createCustomLicense` as the way to make a custom record.

## Design model
- `createCustomLicense` builds a one-text record from a name and a text, unmodified (`LicenseService.createCustomLicense`; test *"produces a single-package record"*).
- `customLicenses` takes any `OssLicenseInfo`, several texts included, and appends it after the registry records without trimming, splitting or formatting (`loadFromLicenseRegistry`).
- Custom texts **skip** [paragraph-formatting](paragraph-formatting.md): `\r\n` stays as it is.

## Code
- `lib/src/services/license_service.dart — LicenseService.createCustomLicense`
- `lib/src/services/license_service.dart — LicenseService.loadFromLicenseRegistry` (the `customLicenses` step)
- `example/lib/main.dart — main` (two sample custom licenses)

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [consolidation](consolidation.md) — custom records merge with registry ones by name, and lose the casing contest to them; their untrimmed names reach the sort.
- [paragraph-formatting](paragraph-formatting.md) — whether custom texts should pass through it is open; routing them there changes what dedup matches.

## Known holes / open
- **Undecided:** whether custom texts should be normalized like registry texts. Today a custom `\r\n` is left as it is, and a custom copy of a registry license is not deduplicated against it (maintainer, 2026-10-24: not decided).

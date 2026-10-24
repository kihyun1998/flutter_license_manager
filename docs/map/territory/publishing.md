# publishing

## What it is
How the package reaches pub.dev: the version and constraints in `pubspec.yaml`, what `.pubignore` leaves out of the archive, and the CHANGELOG and README sections a release carries.

## Governing decisions
**None.**

## Design model
- No runtime dependency beyond the Flutter SDK; `sdk: ">=3.0.0 <4.0.0"`, `flutter: ">=3.0.0"` (`pubspec.yaml`).
- A `.pubignore` replaces `.gitignore` for publishing, so the usual build exclusions are repeated in it. Without them the archive was 13 MB, and `docs/` raised a layout warning (commit `103fa55`, 2026-07-02). `docs/` is excluded, so this map never ships.
- A breaking release gets a *BREAKING CHANGES* and a *Migration* section in the CHANGELOG and a migration section in the README (CHANGELOG 3.0.0; commit `103fa55`).
- The publish is guarded only by CI's `flutter pub publish --dry-run`. Publishing itself is done by hand; no workflow publishes.

## Code
- `pubspec.yaml`, `.pubignore`, `CHANGELOG.md`, `README.md`, `LICENSE`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [ci](ci.md) — its dry-run is the only check that the archive is still valid and small; a new top-level folder lands in the archive unless `.pubignore` lists it.

## Known holes / open
- The `sdk >=3.0.0` / `flutter >=3.0.0` floor is never tested: CI runs only on the pinned 3.41.9 (`.github/workflows/ci.yml`).
- Whether `.github/` ships is not settled here: `.pubignore` does not list it, and pub's default for dot-folders was not checked (raised by the reading test, 2026-10-24).
- `.codeignore` belongs to dead codebase-dump tooling (comment in `.pubignore`) and is still tracked.

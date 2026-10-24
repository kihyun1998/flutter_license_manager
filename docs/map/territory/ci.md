# ci

## What it is
The one GitHub Actions workflow that checks every push to `main` and every pull request: format, analyze and test for both the package and the example, then a publish dry-run.

## Governing decisions
**None.** Issue #9 holds the design for the Dependabot setup that is still to come (Known holes).

## Design model
- Flutter is pinned (`env.FLUTTER_VERSION`) "so CI does not drift with the runner's default Flutter" (comment in `ci.yml`).
- The format check runs over `.`, covering the package and `example/`; analyze and test run separately in each.
- The last step, `flutter pub publish --dry-run`, guards the published archive — see [publishing](publishing.md).
- Actions are pinned to major tags (`actions/checkout@v5`, `subosito/flutter-action@v2`), and nothing bumps them yet.

## Code
- `.github/workflows/ci.yml — jobs.dart`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [publishing](publishing.md) — moving the pinned Flutter changes the SDK the dry-run validates against.
- [example-app](example-app.md) — a Flutter bump can deprecate an API the example uses (as `withOpacity` was, commit `a900095`) and fail its analyze step.

## Known holes / open
- **Dependabot is not set up.** Issue #9 specifies it: root pub monthly with `increase-if-necessary`, one PR per dependency; actions monthly, grouped. Tracked: #9.
- Issue #9 disagrees with itself about `example/`: *Implementation Decisions* says example PRs are grouped, and *Further Notes* says `example/` is left out. Settle it before writing the config.

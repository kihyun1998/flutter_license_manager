# ci

## What it is
The one GitHub Actions workflow that checks every push to `main` and every pull request: format, analyze and test for both the package and the example, then a publish dry-run.

## Governing decisions
**None.** Issue #9 holds the design of the Dependabot setup.

## Design model
- Flutter is pinned (`env.FLUTTER_VERSION`) "so CI does not drift with the runner's default Flutter" (comment in `ci.yml`).
- The format check runs over `.`, covering the package and `example/`; analyze and test run separately in each.
- The last step, `flutter pub publish --dry-run`, guards the published archive — see [publishing](publishing.md).
- Actions are pinned to major tags (`actions/checkout@v5`, `subosito/flutter-action@v2`); Dependabot bumps them in one grouped monthly PR.
- Dependabot (`.github/dependabot.yml`, design in #9): root `pub` monthly with `increase-if-necessary`, so a PR opens only when a release falls outside the caret, ungrouped so each PR is one constraint decision for consumers; `github-actions` monthly, grouped. Both apply `needs-triage`. `example/` stays out: it ships nothing and depends only on `cupertino_icons` and `flutter_lints` (maintainer, 2026-10-24).

## Code
- `.github/workflows/ci.yml — jobs.dart`
- `.github/dependabot.yml`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [publishing](publishing.md) — moving the pinned Flutter changes the SDK the dry-run validates against.
- [example-app](example-app.md) — a Flutter bump can deprecate an API the example uses (as `withOpacity` was, commit `a900095`) and fail its analyze step.

## Known holes / open
- Dependabot's first run has not been observed; a configuration error shows only in the repository's Dependabot status (#9, *Testing Decisions*).

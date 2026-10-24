# Territory map

<!-- grill-map build stamp: 8e5a943 -->
<!-- grill-map synced at: 2418c32 (2026-10-24) -->

The territory map. A comment's why, trap and measured value go to a note here.
Notes are added as they come up, or all at once with `grill-map`, which also
reads hand-written notes as leads and keeps their paths.

## What it answers

- **If I touch this, what else moves?** Open the territory, then follow its `## Blast radius`. The list is a checklist; an item with nothing to do is a correct outcome.
- **What decision is this shape derived from?** Read `## Governing decisions`. **None.** is itself the answer: this repo has no decision records yet, so most rules here come from reading the source and the tests, and the note says which.

## The repo in one paragraph

A Flutter package with one entry point, `LicenseService.loadFromLicenseRegistry`. It reads Flutter's `LicenseRegistry`, formats each entry's paragraphs, explodes multi-package entries into one `OssLicenseInfo` per package, appends custom licenses, then merges same-name records, drops duplicate texts and sorts. `example/` demonstrates it; CI and a hand-run publish ship it. The largest gap: Flutter's source is binding (`docs/agents/thegraph.md`), and the formatter already diverges from it on centered paragraphs — see [paragraph-formatting](territory/paragraph-formatting.md).

## Territories

- [registry-loading](territory/registry-loading.md)
- [paragraph-formatting](territory/paragraph-formatting.md)
- [consolidation](territory/consolidation.md)
- [license-record](territory/license-record.md)
- [custom-licenses](territory/custom-licenses.md)
- [example-app](territory/example-app.md)
- [publishing](territory/publishing.md)
- [ci](territory/ci.md)

No cross-cutting invariants yet. The best candidate, *one record names one package*, is enforced at a single site and lives in [license-record](territory/license-record.md).

## Conventions

- Section headings are identical in every note; an empty one says **None.**
- Code is cited as `file — Symbol`, never by line number.
- A fact another artifact owns (an issue's state, a count) is linked, not copied.
- Every claim carries its evidence (a symbol, a test, a commit) or its source and date, `(maintainer, 2026-10-24)`.

## What it cannot answer

Source files and issues are text inside notes, not nodes: the map does not list every caller of a symbol. Ask the code for that.

## Scope

Out of scope: `docs/agents/`, `CLAUDE.md` and this folder (agent tooling); `.codeignore` (dead codebase-dump tooling); the Flutter-generated `example/windows/` runner. A territory appears when something in the repo commits to it — code, a spec, or an open issue with a design. An idea with nothing behind it gets a line here, not a note.

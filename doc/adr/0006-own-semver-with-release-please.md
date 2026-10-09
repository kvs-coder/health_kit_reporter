# 6. Own semantic versioning, released by release-please

Date: 09.10.2026

## Status

Accepted. Ships with 3.0.0; supersedes the earlier rule that the plugin's major version equals HealthKitReporter's.

## Context

The plugin's major version had been planned to follow HealthKitReporter's (4.0.0 for HealthKitReporter 4.0.0).
pub.dev's latest release is 2.3.1, so a 4.0.0 would skip a major for consumers, and the library's majors don't
always break the plugin's Dart API (or do so at other times). Versions and changelogs were edited by hand; the
library already releases with release-please.

## Decision

The plugin follows semantic versioning of its own: the next release is 3.0.0, depending on HealthKitReporter
`from: "4.0.0"`. release-please (`release.yml`, `release-please-config.json`, `.release-please-manifest.json`, dart
release type, `v`-prefixed tags) derives each version from the Conventional Commits on `master`, keeps a release PR
that bumps `pubspec.yaml`, the example's `pubspec.yaml`, the README and `CHANGELOG.md`, and tags on merge. A tag
publishes to pub.dev from `publish.yml` with GitHub's OIDC token; because a tag created with `GITHUB_TOKEN` starts no push
workflow, `release.yml` starts `publish.yml` on the new tag with `workflow_dispatch`, so no personal token is needed.
release-please also cuts 3.0.0 itself: a GitHub release `v2.3.1` on the published 2.3.1 commit is its starting
point, and the breaking commits since make the next version 3.0.0, as HealthKitReporter's 3.1.0 release anchored its 4.0.0.

## Consequences

- Plugin and library majors are independent; the README and `Package.swift` state the library version the plugin needs.
- Commit messages carry the release notes, so `feat` / `fix` / `!` must be accurate; versions are never bumped by hand.
- Publishing needs automated publishing on pub.dev for push and `workflow_dispatch` events; CI on release PRs needs a `RELEASE_PLEASE_TOKEN`.
- Generated notes list commit subjects; the 3.0.0 notes were curated in its release PR, later releases use the generated ones.

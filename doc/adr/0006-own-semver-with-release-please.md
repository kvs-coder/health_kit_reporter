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
publishes to pub.dev from `publish.yml` with GitHub's OIDC token. 3.0.0 is the bootstrap release, tagged by hand.

## Consequences

- Plugin and library majors are independent; the README and `Package.swift` state the library version the plugin needs.
- Commit messages carry the release notes, so `feat` / `fix` / `!` must be accurate; versions are never bumped by hand.
- Publishing needs automated publishing enabled on pub.dev and, for CI on release PRs, a `RELEASE_PLEASE_TOKEN`.

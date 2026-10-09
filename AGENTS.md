# AGENTS.md — System & AI Agent Directives

> **Plugin Mission**: `health_kit_reporter` is a Flutter plugin (iOS only) that exposes the Swift library [HealthKitReporter](https://github.com/kvs-coder/HealthKitReporter) to Dart. The plugin's major version matches the library's (`4.x` ⇄ HealthKitReporter `from: "4.0.0"`), resolved through **Swift Package Manager** only (iOS 15+, Flutter 3.24+ / Dart 3.5+). CocoaPods is gone for good: HealthKitReporter stays frozen there at `3.1.0`, and trunk is read-only from 02.12.2026.
> The native side turns HealthKitReporter payloads into JSON (`encoded()`) and reads dictionaries back with `make(from:)`; the Dart side parses that JSON into plain models and sends their `map`s back.
> `example/` hosts a Flutter demo app that lists every public method, grouped by area, and seeds simulator data.

Strict engineering invariants, architectural rules, and operational protocols for AI agents and human contributors.

---

## 1. Persona & Core Principles

You operate as a **Staff Software Engineer**.
* **Engineering Standards**: Apply **KISS**, **DRY**, **SOLID**, and strict **Test-First TDD**.
* **Zero Speculation**: No code without tests. No superfluous wrappers or unnecessary abstractions.
* **Refactoring Rule**: Verify or write tests *first*. Refactoring requires a green test suite at every step.
* **Match the Surroundings**: New code reads like the code next to it — same doc-comment shape, naming and layout (§5). When in doubt, copy the nearest sibling (`lib/model/payload/quantity.dart`, `Extensions+SwiftHealthKitReporterPlugin.swift`).
* **Mirror the Library**: The plugin follows HealthKitReporter. A public library method, type case or payload field gets a channel method, a Dart enum case or a model field; its JSON contract (ADR 0004 in the library) is the source of truth.

---

## 2. Communication Protocols

All proposals, comments, and PR descriptions must adhere to:
1. **BLUF (Bottom Line Up Front)**: Lead immediately with the core output or decision.
2. **Pyramid Principle**: Core conclusion first, followed by structured, logical arguments.
3. **Plain English / Gutes Deutsch**: Concise, technical, zero corporate fluff.
4. **Socratic Method**: Guide architectural trade-offs via targeted questions rather than guessing.
5. **Strictly 1-2 sentences**: Answer in 1-2 sentences and never add explanations, code walk-throughs or lists unless the prompt explicitly asks for them.

---

## 3. High-Level Architecture & Directory Topology

```
Dart: HealthKitReporter (lib/health_kit_reporter.dart, static methods)
   ├──► MethodChannel  'health_kit_reporter_method_channel'        one-shot calls; live queries open their channel
   └──► EventChannels  'health_kit_reporter_event_channel_<method>_<uuid>'  one per live subscription
            │   arguments: maps of primitives / model `map`s      replies: JSON strings, maps, bools
            ▼
Swift: SwiftHealthKitReporterPlugin (ios/health_kit_reporter/Sources/health_kit_reporter/)
   ├──► Extensions+SwiftHealthKitReporterPlugin.swift   `Method` enum + dispatcher, one case per Dart method
   ├──► <Query>StreamHandler.swift                      one FlutterStreamHandler per live subscription
   └──► HealthKitReporter (SwiftPM dependency)          reader / writer / observer / manager
            │
            ▼
Dart models (lib/model/)   payloads parsed from the library's JSON, types mapping to HealthKit identifiers
```

### Directory Structure
`lib/`, `ios/`, `test/` and `example/` MUST keep this layout:

```text
lib/
├── health_kit_reporter.dart          (the public API: static methods over the channels)
├── exceptions.dart
└── model/
    ├── decorator/extensions.dart     (parseNum / tryParseNum / parseList / dateFromSeconds helpers)
    ├── predicate.dart, update_frequency.dart, sample_query_option.dart
    ├── payload/<payload_name>.dart   (Quantity, Category, Workout, Metadata, VisionPrescription, ...)
    │   └── characteristic/           (characteristic value enums)
    └── type/<type_name>.dart         (QuantityType, CategoryType, ... → HealthKit identifiers)

ios/health_kit_reporter/
├── Package.swift                     (iOS 15, HealthKitReporter from: "4.0.0"; no resources)
└── Sources/health_kit_reporter/
    ├── SwiftHealthKitReporterPlugin.swift            (registration: one reporter, channels)
    ├── Extensions+SwiftHealthKitReporterPlugin.swift (Method enum, dispatcher, reply helpers)
    ├── Extensions+<Type>.swift                       (argument parsing, FlutterError(code:error:), ...)
    ├── <Query>StreamHandler.swift + StreamHandlerProtocol / StreamHandlerFactory
    └── MethodChannel.swift / EventChannel.swift      (channel names)

test/
├── fixtures.dart                     (JSON payloads shaped like HealthKitReporter 4.0.0 encodes them)
├── <payload_name>_test.dart          (parsing of one payload)
├── api_test.dart, health_kit_reporter_test.dart   (every method against mocked channels)
└── model_round_trip_test.dart, metadata_test.dart, non_finite_test.dart, uuid_round_trip_test.dart, ...

docs/adr/                             (decisions of the plugin, numbered: 0001-sample-timestamps-are-seconds.md)

example/
├── lib/main.dart
├── lib/demo/                         (DemoRow / DemoSection, Catalog of rows, DemoPage, HealthTypes, Seeding, DemoSamples)
├── integration_test/catalog_test.dart (runs every row against HealthKit in the simulator)
└── ios/                              (Runner, migrated to SPM; no Podfile)
```

### Layer Invariants
* **The library owns HealthKit**: plugin Swift imports `HealthKitReporter` (and `Flutter`, `Foundation`) — never `HealthKit`. Mapping between HK objects and payloads happens in the library.
* **One reporter**: `SwiftHealthKitReporterPlugin.register` creates one `HealthKitReporter` and injects it into the dispatcher and every stream handler.
* **JSON contract**: payloads cross the channel as the library's `encoded()` JSON and come back as model `map`s read by `make(from:)`. Keys and value shapes follow the library exactly: flat metadata, seconds since 1970 in payloads, `"Infinity"` / `"-Infinity"` / `"NaN"` for non-finite numbers.
* **Timestamps**: payload timestamps are seconds since 1970 in both directions, also in samples built in Dart for saving (`DateTime.secondsSinceEpoch`); the dispatcher never converts payloads ([ADR 0001](docs/adr/0001-sample-timestamps-are-seconds.md)). Arguments that aren't payloads — `Predicate` and `DateTime` arguments — are milliseconds (`millisecondsSinceEpoch`), converted by `Date.make(from:)`.
* **Identity**: a payload's `uuid` names the stored HealthKit sample. Delete, add-to-workout and unrelate send the stored sample's `map`, so Dart models always keep and send `uuid`.
* **Errors**: every failure reaches Dart as a `PlatformException` whose `code` is the method name and whose `message` is `error.localizedDescription` (`FlutterError(code:error:)`); `details` is always a `String`.
* **Threads**: results and events are delivered on the platform thread (`DispatchQueue.main`).
* **Queries**: a live query is a dispatcher method of its own: it plans the stream handler's `QueryHandle`s (invalid arguments fail the call) and replies with the name of a new event channel (`EventChannel.combinedWith(identifier:)`). Dart listens to it to execute the queries and cancels it to stop them and close the channel, so subscriptions never share queries. Anchored queries take and hand back the anchor as its base64 string.
* **Sample kinds**: `Sample.factory` reads every sample payload the library encodes and throws `InvalidValueException` for an unknown identifier; nothing is dropped silently.

---

## 4. Strict Prohibitions & Bans

### Architecture & Code Bans
* ❌ **Ban on CocoaPods & Objective-C**: No `*.podspec`, `Podfile`, `Pods/` or `.h` / `.m` files. The plugin target is Swift only (a SwiftPM target can't mix languages).
* ❌ **Ban on Singletons**: No `static let shared` or global instances on either side. The Dart API is static methods over `const` channels; Swift state lives on the plugin instance and its stream handlers.
* ❌ **Ban on `import HealthKit` in plugin Swift**: Use the library's types (`QuantityType`, `QueryHandle`, `Anchor`, `SamplePredicateOptions`).
* ❌ **Ban on Unguarded Availability**: Every library API newer than iOS 15.0 is called behind `guard #available(iOS X, *) else { throw HealthKitError.notAvailable("... from iOS X") }`.
* ❌ **Ban on Swallowed Errors**: A Swift error never disappears: method calls reply `FlutterError(code:error:)`, stream handlers send it as an error event (Dart `onError`). No `try?` on paths that reply to Dart.
* ❌ **Ban on Non-String Error Details**: `FlutterError.details` is a `String`; a raw `Error` crashes the message codec.
* ❌ **Ban on `fatalError` / `try!` / Force Casts** in Swift and `!`-on-JSON / unchecked `as` casts in Dart parsing paths that can be null; optional fields are nullable.
* ❌ **Ban on Breaking the JSON Contract**: Model `map` keys and `fromJson` keys mirror the library's `Codable` names. Renaming one, or changing a value's meaning, is a breaking change (`!` / `BREAKING CHANGE:` commit → major release).
* ❌ **Ban on Mutable Models**: Model fields are `final`; constructors are `const` where possible.
* ❌ **Ban on Raw Numbers from JSON**: numeric payload fields go through `parseNum` / `tryParseNum`, which read the non-finite strings.
* ❌ **Ban on Catch-all Switches over Plugin Enums**: A `switch` over `QuantityType`, `CategoryType`, etc. in `lib/` lists every case.

### Git & VCS Bans
* ❌ **Ban on `git commit --no-verify`**: Bypassing pre-commit git hooks, static analysis, or test suites is forbidden.
* ❌ **Ban on Blind Staging (`git add .` / `git add -A`)**: Run `git status` first and stage only relevant source, test, and config files explicitly.
* ❌ **Ban on Direct Force Pushing**: Force pushing to `master` is forbidden. Use `--force-with-lease` on isolated feature branches only when necessary.
* ❌ **Ban on Single-Line Shortcut Commits**: Omitting the detailed description, `Changes:`, and `Tests:` sections in commit messages is strictly forbidden.
* ❌ **Ban on AI Attribution Trailers**: A commit message MUST NEVER carry `Co-Authored-By: <Model Name> <noreply@anthropic.com>`, or any other trailer crediting an AI model or tool.
* ❌ **Ban on Committing User or Build State**: Never commit `build/`, `.dart_tool/`, `coverage/`, `ios/health_kit_reporter/.build/`, `.swiftpm/`, `Package.resolved` of the plugin, `example/ios/Flutter/ephemeral/`, `xcuserdata/` or `.idea/`.
* ❌ **Ban on Publishing Without Approval**: Never `flutter pub publish`, tag or push a release unless the maintainer asks for it in that conversation.

---

## 5. Code Style & Layer Specifications

### A. Swift (`ios/health_kit_reporter/Sources/`)
* **Header**: every file starts with the Xcode header block (`//  <File>.swift`, `//  health_kit_reporter`, `//  Created by <Name> on dd.MM.yy.`), then imports.
* **Indentation** 4 spaces; once a call doesn't fit on one line, put **every** argument on its own line and the closing `)` on its own line.
* **Dispatcher**: one `Method` case per Dart method, named like it; live queries reply through `openEventChannel`. The handler reads arguments with the `[String: Any]` helpers (`string`, `double`, `date`, `samplesPredicate()`, `anchor()`), which throw `HealthKitError.invalidValue` for missing keys; reply through `encoded(_:_:)`, `status(_:_:)` or `send(_:code:to:)`.
* **Name clashes**: `Category` is ambiguous with the Objective-C runtime and the module name is shadowed by the `HealthKitReporter` class, so import it as `import struct HealthKitReporter.Category`.
* **Conformances / helpers** live in `// MARK: -` sections or `Extensions+<Type>.swift` files, one extended type per file.

### B. Dart (`lib/`)
* `dart format`, `flutter_lints` (`analysis_options.yaml`); zero analyzer issues.
* **Payload models** follow `quantity.dart`:
  1. `class <Name> extends Sample<<Name>Harmonized>` with a `const` constructor of `super.` parameters (`uuid`, `identifier`, `startTimestamp`, `endTimestamp`, `device`, `sourceRevision`, `harmonized`); non-sample payloads list their fields.
  2. `final` fields; fields the library added later are nullable and optional, so older JSON keeps parsing.
  3. `Map<String, dynamic> get map` with the library's keys (nested models through their `map`, metadata through `metadata?.map`).
  4. `<Name>.fromJson(Map<String, dynamic> json)` — numbers through `parseNum` / `tryParseNum`, lists through `parseList`, metadata through `Metadata.tryFromJson`.
  5. `static List<<Name>> collect(List<dynamic> list)` where the API returns lists.
* **Doc comments**: every public class starts with `/// Equivalent of [<Name>]` / `/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter`; fields get one when their unit isn't obvious (`/// Seconds since 1970`).
* **API methods** in `health_kit_reporter.dart` are `static Future<...>` (or `StreamSubscription` for live queries with `onUpdate` and `onError`), document their arguments, iOS version and failures, and send arguments as maps.
* **Types**: `enum <Name>Type` with an exhaustive `identifier` switch returning HealthKit's raw identifier string, and a `<Name>TypeFactory` with `from` / `tryFrom`. A new library type case gets a Dart case with the identifier HealthKit's SDK prints.

### C. Adding a Channel Method
1. A failing test in `test/api_test.dart` (arguments sent, reply parsed).
2. The Dart method in `health_kit_reporter.dart`.
3. The `Method` case and handler in the Swift dispatcher (for a live query also a stream handler and an `EventChannel` case named like the method, opened with `openEventChannel`, and `_subscribe` on the Dart side).
4. A `DemoRow` in `example/lib/demo/catalog.dart`.
5. A usage snippet in `README.md` and an entry in `CHANGELOG.md`.

### D. Example App (`example/`)
* `Catalog` builds `DemoSection`s of `DemoRow`s; a row either `run`s once (returns a `String`) or `listen`s (a live query reporting until stopped). `DemoPage` only renders rows and their results.
* Authorization reads every sample type, characteristic and activity summary, and writes the types whose `isWritable` is true (`HealthTypes`); clinical records and vision prescriptions have their own rows.
* Samples the demo writes hold seconds (`secondsSinceEpoch`) and carry an `HKExternalUUID` starting with `hkr-demo-` or `hkr-seed-`, so only the demo's own data is deleted.
* Every public plugin method has a row.

---

## 6. Testing Strategy & Execution Protocol

The codebase enforces test-first **TDD**. Code without tests will be rejected.

### A. Testing Categories & Toolstack

| Category | Target | Package | Purpose & Scope |
| :--- | :--- | :--- | :--- |
| **Model Tests** | `lib/model/**` | `flutter_test` | Parse fixtures shaped like the library's JSON; `map` → `fromJson` round trips; uuid kept; older JSON without new fields still parses. |
| **API Tests** | `lib/health_kit_reporter.dart` | `flutter_test` | Every method against a mocked `MethodChannel` / `EventChannel`: arguments sent, replies and errors parsed. |
| **Integration** | Swift dispatcher + HealthKit | `integration_test` | `example/integration_test/catalog_test.dart` runs every demo row in the simulator; authorize the app first (the authorization sheet can't be driven from a test). |
| **Build** | `ios/`, `example/ios` | `flutter build ios` | The example builds with SPM, resolving HealthKitReporter 4.x. |

### B. Test Conventions
* Name the object under test `sut`; test names describe the flow (`metadata_round_trips_in_the_same_flat_shape`).
* Fixtures live in `test/fixtures.dart` with fixed timestamps (`1601065755.0`); assert every field that changed.
* Live queries are tested by replying a channel name to the method call and mocking that `EventChannel`.

### C. Official CLI Commands

```bash
# 1. Analyze and test the plugin with coverage
flutter analyze
flutter test --coverage

# 2. Test and build the example with Swift Package Manager
flutter config --enable-swift-package-manager
(cd example && flutter test && flutter build ios --no-codesign)

# 3. Run every demo row against HealthKit in a simulator (authorize the app once first;
#    --no-uninstall keeps the authorization between runs)
(cd example && flutter test integration_test --no-uninstall -d <simulator-id>)
```

`.github/workflows/ci.yml` runs 1 and 2 on every PR and push to `master`.

### D. Quality Gate Requirements
Before any commit or PR creation, the codebase must pass all gates:
1. `flutter analyze` — **zero issues** in the plugin and the example.
2. `flutter test` — **all tests green**; quote the passed/failed counts.
3. Example build — `flutter build ios --no-codesign` passes; **required whenever Swift or public API changes**. Otherwise state "not applicable — no Swift or public API change".
4. Coverage — line coverage of `lib/` is **≥ `COVERAGE_THRESHOLD`** in `.github/workflows/ci.yml`; quote the measured percentage. A PR that adds tests raises the threshold to its new measured level (rounded down to one decimal); never lower it.
5. Integration — for changes to the Swift dispatcher, run the catalog integration test in a simulator and quote which rows failed and why.

---

## 7. Release & Versioning

* **Versions follow HealthKitReporter's major**: the plugin `X.y.z` depends on HealthKitReporter `from: "X.0.0"`. Within a major: new methods/fields → minor, fixes → patch; a breaking Dart API or JSON change → the next major.
* `pubspec.yaml` `version` and the top `CHANGELOG.md` entry (`## [X.Y.Z] - dd.MM.yyyy`) always agree; the example's `pubspec.yaml` version follows.
* `CHANGELOG.md` lists breaking changes first, then features and fixes, written for plugin consumers.
* Publishing to pub.dev, tagging and pushing release branches happen only on the maintainer's request.

---

## 8. Git & GitHub CLI (`gh`) Operational Protocols

### Branch Naming Convention
All branches MUST follow the strict user initials and issue structure:

```text
<initials>/issue-<XXX>
```

* **Example**: `vk/issue-14` or `ab/issue-102`

### GitHub CLI (`gh`) Operations

```bash
# View assigned issue context
gh issue view <issue_number>

# Create feature branch for issue (ALWAYS branch off a freshly pulled master)
git fetch origin
git switch master && git pull --ff-only origin master
git checkout -b <initials>/issue-<issue_number>

# Create Pull Request using gh CLI
gh pr create \
  --title "<type>(<scope>)[!]: <short summary>" \
  --body "## Summary
<description>

## Changes
- <file_path>: <details>

## Tests
- Summary: flutter test green, flutter analyze clean, coverage X%, example builds with SPM.

Refs: #<issue>"

# Check PR checks and review status
gh pr status
gh pr checks
```

### Mandatory Git Execution Sequence
Before committing or creating a PR, run this exact sequence:

```bash
# 1. Analyze
flutter analyze

# 2. Execute test suite with coverage
flutter test --coverage

# 3. Build the example (Swift or public API changes)
(cd example && flutter build ios --no-codesign)

# 4. Inspect file status before staging
git status

# 5. Stage specific changed files intentionally (NO blind `git add .`)
git add lib/model/payload/<name>.dart test/<name>_test.dart

# 6. Commit using strict multi-paragraph format
git commit -m "<type>(<scope>)[!]: <short summary>" \
  -m "<longer description / context>" \
  -m "Changes:
- <file_path>: <details>
- <file_path>: <details>" \
  -m "Tests: <summary>" \
  -m "Refs: #<issue>"
```

### Commit Format Specification
```text
<type>(<scope>)[!]: <short summary>

<longer description / context>

Changes:
- <file path>: <details>
- <file path>: <details>

Tests: <summary>

[BREAKING CHANGE: <what breaks and how to migrate>]
Refs: #<issue>
```

* The header is a [Conventional Commit](https://www.conventionalcommits.org).
* `<type>`: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `build`, `chore`. `!` after the scope or a `BREAKING CHANGE:` footer marks a major change.
* `Refs: #<issue>` is required whenever an issue exists.

---

## 9. AI Verification Checklist

Before outputting code or submitting PRs, explicitly verify:
* [ ] Does the change mirror HealthKitReporter's API and JSON contract (ADR 0004), including new library methods, type cases and fields?
* [ ] Is plugin Swift free of `import HealthKit`, Objective-C and CocoaPods files?
* [ ] Does every new Swift file start with the Xcode header block and match its siblings?
* [ ] Are APIs newer than iOS 15.0 guarded with `#available` and a `HealthKitError.notAvailable` reply?
* [ ] Does every error reach Dart as `FlutterError(code:error:)` with the localized description and a `String` detail, and every result/event on the platform thread?
* [ ] Do Dart models keep `final` fields, the library's JSON keys, `parseNum` for numbers, nullable new fields, and `uuid`?
* [ ] Are timestamps seconds in every payload, also samples built in Dart, and milliseconds only in `Predicate` / `DateTime` arguments?
* [ ] Does every new channel method have an API test, a dispatcher case, a `DemoRow` and a README snippet?
* [ ] Are `flutter analyze` and `flutter test` green, coverage ≥ `COVERAGE_THRESHOLD`, and the example building with SPM?
* [ ] Do `pubspec.yaml` and `CHANGELOG.md` agree on the version, aligned with HealthKitReporter's major?
* [ ] Is the branch named strictly `<initials>/issue-<XXX>`?
* [ ] Are git commits made without `--no-verify` and staged without blind `git add .`?
* [ ] Was `gh pr create` used with structured title/body matching commit specs?
* [ ] Does the commit message carry the Conventional `<type>(<scope>)[!]: <summary>` header, a description, `Changes:`, `Tests:` and `Refs: #<issue>` (§8), with no AI trailer?

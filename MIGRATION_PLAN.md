# X Insight KMP migration plan

Last updated: 2026-08-10

This is the living roadmap for rewriting X Insight from Flutter to Kotlin and
Compose Multiplatform. It records the current direction without treating early
design ideas as irreversible decisions. Update it as milestones are completed
and architectural choices are validated in code.

## Goals and constraints

- Target Android and iOS.
- Use the rewrite to learn Kotlin, Kotlin Multiplatform, and Compose
  Multiplatform through small, supervised steps.
- Share business logic, state, and most UI in `commonMain`.
- Use platform-specific implementations where security or native UX justifies
  them.
- Display independent pieces of account content as soon as their required API
  endpoints have completed.
- Keep financial data in memory unless an explicit, secure offline-storage
  design is introduced later.
- Keep dependencies deliberate and limited, but do not reimplement complex
  infrastructure solely to avoid a well-maintained dependency.

## Fixed product identity

These identifiers preserve the existing store listings even though the old
Android identifier still reflects the former **Indexa X** name:

| Platform | Published identifier | Notes |
| --- | --- | --- |
| Android | `com.victormarino.indexax` | Used for the `applicationId`, Android namespaces, and Kotlin source packages. |
| iOS | `com.victormarino.xinsight` | Must remain the Xcode product bundle identifier. |

Before the first distributable build, choose version names and build numbers
that continue from the published Flutter releases. Do not ship the starter
values (`1.0` / build `1`).

## Proposed technical direction

Keep the existing `shared` module and establish boundaries with packages before
considering additional Gradle modules:

```text
com.victormarino.indexax
├── core
│   ├── network
│   ├── security
│   └── formatting
├── feature
│   ├── authentication
│   ├── account
│   └── settings
├── model
└── ui
    ├── navigation
    ├── components
    └── theme
```

The intended data flow is:

```text
API DTO -> mapper -> domain model -> ViewModel StateFlow -> Compose UI
```

Initial architectural preferences:

- Typed DTOs with `kotlinx.serialization`, not dynamic maps.
- Ktor Client for shared networking, subject to a dependency review before it
  is added.
- Coroutines and independent immutable load states for each endpoint.
- Shared ViewModels and `StateFlow` for screen state.
- Manual constructor injection through a small dependency container at first.
- A top-level navigation graph for login, the main experience, settings,
  privacy, and about screens.
- A shared horizontal pager inside the main destination for the primary screens.
- A shared floating menu initially, with native iOS navigation chrome remaining
  an option if exact system Liquid Glass becomes a requirement.

## Endpoint and UI dependencies

Avoid recreating the Flutter app's single all-or-nothing `Account` load.

| Endpoint data | Primary consumers |
| --- | --- |
| User accounts | Token validation, account selection |
| Account info | Header and overview metadata |
| Performance | Overview, evolution, projection |
| Portfolio | Overview distribution, portfolio |
| Instrument transactions | Transactions |
| Cash transactions | Transactions |
| Pending transactions | Alerts and transaction indicators |

Requests for an account should run concurrently. Each successful response
updates only its own state. A failed request must not cancel unrelated requests.
Account changes must cancel or invalidate requests for the previous account.
Content that combines endpoints waits only for the endpoints it actually needs.

## Security invariants

- Treat the API token as a bearer credential.
- Store it only after successful server validation.
- Never log it or include it in crash reports.
- On Android, protect encryption/decryption with an authentication-bound Android
  Keystore key and BiometricPrompt.
- On iOS, use an access-controlled, device-only Keychain item.
- Keep the platform implementations behind a small common credential-vault
  interface.
- Do not interpret connectivity or server failures as invalid credentials.
- Clear credentials and in-memory financial data on logout.
- Use ordinary preferences storage only for non-secret settings.

## Chart strategy

Run a focused prototype before committing to a chart implementation. Evaluate a
Compose Multiplatform chart library such as Vico against realistic data and the
following requirements:

- Area and line combinations.
- Multiple line series and column charts.
- Donut charts.
- Date axes and configurable visible ranges.
- Custom markers and tooltips.
- Private-mode value masking.
- Light and dark themes.
- Accessibility and acceptable performance with several thousand points.

If a library meets these needs, prefer one well-maintained dependency over a
full custom chart engine. If it does not, build narrowly scoped internal chart
primitives rather than a general-purpose framework.

## Settings strategy

Start with a shared Compose settings screen while keeping settings state and
actions independent of its UI. Re-evaluate after the core app works:

- Keep shared Compose if it provides a satisfactory experience on both
  platforms.
- Split Android Compose and iOS SwiftUI presentation if native settings fidelity
  is worth the extra platform code.

## Roadmap

### Phase 0: Baseline and compatibility

- [x] Bootstrap the Android/iOS Compose Multiplatform project.
- [x] Restore the published Android and iOS application identifiers.
- [ ] Choose release version names and build numbers that continue from the
  Flutter releases.
- [ ] Decide whether users will re-enter saved tokens after upgrading or whether
  the Flutter secure-storage format will be migrated.
- [ ] Inventory existing screens, API behavior, calculations, localizations,
  privacy behavior, and intentional redesigns.

### Phase 1: Kotlin foundations

- [ ] Define typed DTOs for representative API responses.
- [ ] Define domain models independent of JSON structure and UI concerns.
- [ ] Port validation, mapping, formatting, sorting, and financial calculations
  with common tests.
- [ ] Prepare sanitized JSON fixtures or typed fake data for development.

### Phase 2: Fake-data vertical slice

- [ ] Define a reusable load-state model.
- [ ] Create a fake repository that returns endpoints with independent delays
  and failures.
- [ ] Create shared account state and a ViewModel/state holder.
- [ ] Build a simple overview screen that reveals sections progressively.
- [ ] Verify cancellation and stale-response protection when switching accounts.

### Phase 3: Real networking

- [ ] Review and add the Ktor and serialization dependencies.
- [ ] Implement typed API calls and centralized response/error mapping.
- [ ] Add in-memory manual-token login and `/users/me` validation.
- [ ] Load account endpoints concurrently and support per-section retry.
- [ ] Profile realistic large responses before introducing streaming or custom
  parsing.

### Phase 4: Secure authentication

- [ ] Define the common credential-vault interface and session state machine.
- [ ] Implement Android Keystore and BiometricPrompt protection.
- [ ] Implement access-controlled iOS Keychain protection.
- [ ] Handle unavailable biometrics, invalidated keys, cancellation, offline
  startup, and logout.
- [ ] Add token redaction and app-switcher privacy protections.

### Phase 5: App shell and screens

- [ ] Add top-level navigation for login, main content, settings, privacy, and
  about.
- [ ] Add the horizontal pager and synchronized floating menu.
- [ ] Add the remaining screens first with simple text and list presentation.
- [ ] Preserve screen and account state without duplicating network requests.
- [ ] Resolve gesture interaction between the pager and chart content.

### Phase 6: Charts

- [ ] Prototype the chart-library requirements with realistic data on Android
  and iOS.
- [ ] Record the library-versus-custom decision and rationale here.
- [ ] Implement charts incrementally, including private mode and accessibility.
- [ ] Measure rendering performance and add visual downsampling if needed.

### Phase 7: Platform polish

- [ ] Decide whether the iOS settings screen should become SwiftUI.
- [ ] Decide whether the floating menu is shared glass-like Compose or native
  iOS Liquid Glass chrome.
- [ ] Add adaptive layouts, orientation handling, localization, accessibility,
  lifecycle locking, and theme behavior.
- [ ] Verify Android and iOS behavior throughout rather than postponing iOS QA.

### Phase 8: Release migration

- [ ] Confirm signing, capabilities, store identifiers, and version continuity.
- [ ] Test upgrade behavior from the last Flutter release on both platforms.
- [ ] Complete privacy, security, performance, and accessibility reviews.
- [ ] Run release builds and a staged beta before production rollout.

## Open decisions

| Decision | Current direction |
| --- | --- |
| Existing stored-token migration | Undecided; requiring one-time re-entry is the simpler default. |
| Persistent financial-data cache | None initially; keep data in memory. |
| Chart implementation | Prototype Vico, then decide from evidence. |
| Settings UI | Shared Compose initially; preserve the option for SwiftUI on iOS. |
| Floating menu | Shared Compose initially; exact native Liquid Glass remains optional. |
| Dependency injection | Manual construction initially. |
| Release version | Undecided; must continue from the published builds. |

## Progress log

- **2026-08-10:** Created the KMP migration roadmap, recorded the learning-first
  collaboration model, restored the existing store identifiers, and aligned
  Android namespaces and Kotlin source packages with
  `com.victormarino.indexax`.

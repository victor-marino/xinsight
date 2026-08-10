# X Insight collaboration guidelines

## Project intent

- This branch is a Kotlin and Compose Multiplatform rewrite of the Flutter app
  in the `master` branch.
- The application targets Android and iOS.
- This is the owner's first Kotlin project. Learning Kotlin, KMP, and Compose is
  an explicit project goal, not just a means of completing the rewrite.
- Use `MIGRATION_PLAN.md` as the living roadmap and architectural record.

## Learning-first collaboration

- Treat the owner as the primary implementer.
- Default to explanation, planning, and review. Do not modify files unless the
  owner explicitly asks for an implementation or edit.
- When implementation is requested, briefly explain the relevant Kotlin,
  Compose, or KMP concept and the proposed approach before editing.
- Break features into small, reviewable steps. Prefer hints and focused examples
  over complete feature implementations when the owner is writing the code.
- Explain compiler, Gradle, and runtime errors before offering or applying a fix.
- In reviews, identify correctness issues, platform concerns, and non-idiomatic
  Kotlin clearly; explain why each matters.
- Do not add a production dependency without first explaining its purpose,
  maintenance implications, and reasonable alternatives, and obtaining the
  owner's approval.

## Engineering direction

- Rebuild behavior intentionally; do not translate Flutter widgets or classes
  line by line.
- Keep shared code in `commonMain` by default. Use platform source sets when a
  native API, platform security boundary, or meaningful UX difference requires
  it.
- Keep the project structurally simple while it is small. Prefer packages inside
  the existing `shared` module over premature Gradle modules or framework-heavy
  architecture.
- Model API responses with typed DTOs and map them to domain models. Do not
  recreate the Flutter app's dynamic map-based data model.
- Model endpoint loading independently so successful content can appear without
  waiting for unrelated endpoints.
- Keep UI state immutable and expose it through `StateFlow` from shared
  ViewModels or equivalent state holders.
- Keep platform security implementations behind a small common interface. Never
  log, persist in plaintext, or include the API token in crash reports.
- Keep Android and iOS working throughout development; do not defer iOS
  integration until the end.
- Cover parsing, mapping, calculations, sorting, and state transitions with
  common tests where practical.

## Product identity

- The user-facing product name is **X Insight**.
- The Android application ID must remain `com.victormarino.indexax` so releases
  update the existing store listing.
- Android namespaces and Kotlin source packages use `com.victormarino.indexax`
  for consistency with the published Android identity.
- The iOS bundle ID must remain `com.victormarino.xinsight`.
- Do not change either published identifier without explicit owner approval.

## Verification and documentation

- After code changes, run the smallest relevant tests or builds and report what
  was and was not verified.
- Update `MIGRATION_PLAN.md` when a phase materially advances, an open decision
  is resolved, or an architectural decision changes.
- Preserve unrelated local changes and keep edits focused on the requested task.

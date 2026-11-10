# Frontend / Mobile Parity

## Objective and authorization

Align the existing Flutter app's colors, typography, component styling, and supported API behavior with the current frontend develop branch, adapted to mobile without changing existing layouts. The user authorized implementation with agents. Backend and frontend are read-only reference repositories; the parent is now authorized to build, merge and push Mobile-app main after API parity. This worker may only implement and commit locally. No frontend/backend writes, credentials access, or live backend calls are authorized.

## Evidence and constraints

- Mobile baseline: `da7ef88`, previous branch `feat/mobile-backend-integration`; working branch `feat/frontend-mobile-parity`.
- Reference: sibling `primefuel-frontend-reference`, develop `0457aaa`. Its only change beyond main `2a5a412` is 3D/WebGL tank visualization, explicitly excluded.
- Corporate palette: primary `#1E3A8A`, accent `#F59E0B`, background `#F4F6F9`, white surfaces; text `#1F2937` / `#4B5563`; Roboto typography. Sources: frontend `src/material-theme.scss`, `src/styles.css`, shared layout CSS.
- Mobile currently has no explicit global theme in `lib/app/fulltank_app.dart`; 171 corporate/text/background color occurrences were found across presentation files. Reuse existing widgets and layouts, no added framework or design dependency.
- Preserve prior backend alignment described in `odd/tasks/mobile-backend-api-alignment.md`. Local backend `CustomerTanksController` explicitly supports the current nested `/api/v2/buyer-companies/{companyId}/sites/{siteId}/tanks` route. Do not replace it merely because the web uses `/api/tanks`.
- Local backend `SignInResource` accepts `rememberMe`; `AuthenticationController` exposes server-side sign-out. Mobile currently omits the rememberMe payload and clears tokens locally on sign-out.
- Backend CodeGraph reported stale auth source; current controller was read directly. Frontend CodeGraph initialization previously failed; filesystem fallback used. No backend/frontend source edits.
- Exclusions: 3D, WebGL, new screens, new business features, backend changes, broad cleanup, speculative endpoints, layout redesign, unrelated `.atl/` content.

## Execution and delivery

- Route: delegated direct for every task; writer/preparation triggers apply because shared theme, screen consumers, auth/API adapters, and tests span multiple non-trivial files.
- Strict TDD: enabled by supplied AGENTS instructions. Observe RED before implementation, then GREEN and REFACTOR. Runner: `/home/ejos/flutter/bin/flutter test`; static checks: `/home/ejos/flutter/bin/flutter analyze`.
- Normalize changed Dart files before final checks. Focused tests, full test suite, analyze, and `git diff --check` are required; report existing warnings separately.
- Delivery strategy: `ask-on-risk`. Chain strategy: `feature-branch-chain`, selected by parent after the user delegated the lowest-breakage choice. Integration branch: `feat/frontend-mobile-parity`; first local slice: `feat/frontend-mobile-parity-style`. No remote PR creation is authorized. Forecast: **750 authored changed lines** (additions + deletions, generated files excluded): FMP-1 410, FMP-2 260, FMP-3 80. This is a planning estimate, not a hard per-task cap or invitation to code-golf.
- Forecast rationale: 171 existing color occurrences alone imply up to 342 changed lines, before shared theme imports/configuration, tests, typography, and auth contract changes. Do not omit tests or compress code to meet a budget.
- RDD: read-only `gentle-ai review mode status` reports on, decided by global. Parent owns all candidate assessment/review lifecycle and consent.
- Delivery forecast is addressed through the authorized integration-chain strategy. Implement the styling slice first, then stop for parent-owned assessment before the API slice.

## Tasks

- [x] **FMP-1 — Shared corporate mobile styling.** Define the smallest shared Flutter palette/theme; explicitly select Roboto, align existing screen/widget colors and semantic status styling without layout changes. Add focused theme/style tests with observed RED/GREEN. Rollback boundary: theme configuration, palette consumers, and their tests only. Route: delegated, multi-file writer/preparation trigger. Estimate: 410 authored lines.
- [x] **FMP-2 — Existing auth/API contract parity.** Verify changed contracts against local backend before editing; pass rememberMe, implement supported server logout with safe local cleanup, and align expiry/401 behavior for existing sessions. Check supported request response mapping only where existing screens use it. Keep proven nested tank APIs; record unsupported/unverified contracts rather than guessing. Add focused HTTP/session tests, preserving prior tenant behavior. Rollback boundary: auth/client adapters and focused contract tests. Route: delegated, multi-file writer/preparation trigger. Estimate: 260 authored lines.
- [ ] **FMP-3 — Regression and visual verification.** Format changed Dart files, run focused/full Flutter tests and analyze, inspect device availability, and verify representative existing screens where possible. Record missing device/runtime/backend evidence honestly. Update this tracker and its full Engram mirror after each observed task outcome; each completed work unit requires a local Conventional Commit, with commit identity and authored count recorded. Rollback boundary: task-specific tests/docs; no unrelated cleanup. Route: delegated verification. Estimate: 80 authored lines.

## Acceptance criteria

- Existing screens share the corporate palette/Roboto while retaining mobile layouts, navigation, accessibility, and current supported features.
- Existing auth/API changes match checked-out backend contracts, preserve tenant identity, and pass focused behavior tests.
- No 3D/WebGL, speculative endpoint migration, framework addition, new screen, or unrelated changes.
- Strict TDD evidence, focused/full test results, analyze result, formatting, authored count, and local Conventional Commit identities are recorded per completed unit.
- Device-rendered visual checks are reported as pending unless actually observed; source inspection is not a visual pass.

## Progress and checks

- FMP-1 styling implementation complete on `feat/frontend-mobile-parity-style`; API behavior is untouched. Shared palette consumers retain existing layouts/navigation. Roboto Regular/Medium/Bold/Black are bundled from the installed Flutter material font assets with their Apache license, so typography works offline on all platforms. Corporate primary authentication action is solid blue rather than an orange gradient/glow.
- Tracker/mirror readback: initial planning document is mirrored under `odd/frontend-mobile-parity/tasks`; readback evidence is reported in the worker handoff.
- Source edits: shared theme, existing presentation palette consumers, app theme wiring, font manifest/assets, style tests. Styling commit `c780b29` is published on main: 63 tests passed, Android debug APK build passed (parent evidence), 17 baseline analyze diagnostics remain. Native review was declined for that styling candidate only.
- RED: `flutter test test/brand_style_test.dart` failed three assertions against the old navigation color, orange-gradient auth action, and hardcoded palette. GREEN: focused suite passes 4 tests, including bundled font asset loading. Full `flutter test` passes 63 tests. `git diff --check` passes. Analysis reports the same 17 baseline diagnostics (unused legacy widgets/import and deprecated dropdown value); **plain analyze exits 1**, so this required check is not a pass. Format check `dart format --output=none --set-exit-if-changed lib test/brand_style_test.dart` passes (137 files, 0 changed). Device inventory finds Linux only: mobile simulator/device visual and motion checks remain pending, not passed.
- SDK resolution: current Flutter requires matcher 0.12.20 and test_api 0.7.12, meta ^1.18.3 and vector_math ^2.4.0, verified in installed SDK pubspec files. The four resulting transitive lock updates are retained for reproducible checks; no dependency was added for styling.
- Runtime harness: focused widget tests exercise primary action, active bottom navigation, shared typography/surfaces and font loading. No live API/backend or device rendering was performed.
- Rollback: revert the style work-unit commit to remove only theme/palette/font/test changes; prior API/tenant alignment remains intact.
- Native review: not started; parent-owned.
- Next step: parent assesses the styling commit. FMP-2 API/auth work and FMP-3 mobile-device visual validation remain pending. No remote PR has been opened; intended first slice targets local integration branch `feat/frontend-mobile-parity`.

## FMP-2 resumed scope

- API slice branch: `feat/frontend-mobile-parity-api` from main `c780b29`; parent owns merge/push and fresh native review. Preserve `.atl/` and `.aws` without reading credentials.
- Implement existing auth rememberMe/server sign-out/expired-session restore and authenticated 401 handling, including stale-response guards. Verify existing request detail/accept behavior and audit the existing facade route families against reference/backend; preserve supported v2 tanks and explicitly unsupported operations.
- Strict TDD remains enabled. Focused/full runner: `/home/ejos/flutter/bin/flutter test --no-pub`; analyze `--no-pub` has 17 accepted baseline diagnostics. Parent/verifier owns final Android debug build.
- FMP-1 is complete; device-rendered visual validation remains pending. FMP-2 implementation and fresh review remain pending. Mirror reconciliation readback is recorded in worker handoff.

- Parent authorized the bounded inventory identity fix discovered during the API audit: remove fixed tenant/site=1 and silent API-error-to-mock fallback. Reuse existing customer/site lookup, require a unique site in the absence of a site-selection UI, retain explicit mock/guest previews, and surface real-session loading/errors. Add provider and widget RED/GREEN assertions. No new inventory layout/screens.

- Parent authorized the minimal existing-payment contract correction: use shared authenticated API and session company; omit invented amount (backend derives order total); remove fabricated MOBILE transaction reference and automatic completion. Registration remains pending until genuine confirmation exists. No new reference-entry workflow or live payment calls. Also wire existing provider-order consumers to the shared authenticated API rather than standalone clients.

## FMP-2 outcome and route audit

- Implemented rememberMe payload, public-auth Bearer exclusion, server sign-out (10-second bound with guaranteed local cleanup on network/server failure), JWT expiry on restore, central authenticated-401 invalidation for JSON and CSV requests, and stale restore/login/logout/401 guards. Secure-storage writes/clears are serialized so old cleanup cannot delete a newer login's persistence. Opaque legacy tokens remain server-validated, matching web behavior.
- Existing request detail now calls `GET /api/replenishment-requests/{id}`: confirmed in current `replenishment/interfaces/rest/ReplenishmentRequestsController.java:130`. Earlier old-index/moved-path assessment of missing detail was corrected against current source. Accept returns a request resource, not an order: follow its confirmed `orderId` and map the fetched fuel order.
- Inventory no longer defaults company/site IDs to 1 or turns failures into sample data. It derives session company and linked customer/site through existing lookup, requires a unique site (explicit unavailable error for ambiguous sites), preserves guest/mock preview only, and uses actual list data for search and counts. Provider product reads carry the authenticated provider ID.
- Payment now uses the shared authenticated API and session company, omits fabricated amount (backend derives total from the order), and never generates a transaction reference or invokes automatic completion. Receipt says pending, not paid; query parameters cannot manufacture the paid screen. Static fake total/card details and hardcoded order links were removed. This deliberately leaves final payment confirmation unavailable without genuine external transaction evidence; no new payment workflow or live call was added.
- Existing provider-order list/actions now receive the shared authenticated API, preserving Bearer/401 handling instead of creating independent unauthenticated clients.

| Existing facade family | Confirmed current contract / preserved difference |
|---|---|
| Authentication, users, business profiles | `/api/authentication/*`, `/api/users`, `/api/buyer-companies`, `/api/provider-companies`; rememberMe/sign-out corrected. Users list remains admin-only; deprecated company creation wrappers are preserved, not used as replacement onboarding. |
| Orders and replenishment | `/api/fuel-orders` company/provider/detail/confirm/cancel and `/api/replenishment-requests` collection/inbox/detail/accept/reject; accept resource mapping corrected. Web receive/cancel-request actions are not new mobile features in this slice. |
| Catalog and equipment | `/api/fuel-products` collection/provider/stock/PUT/DELETE and `/api/equipment` collection/company/detail/POST update match backend. Provider product reads now use provider scope. Unsupported favorite-provider mutation remains unavailable. |
| Customers, sites and tanks | `/api/customers/{id}/sites` and supported nested `/api/v2/buyer-companies/{company}/sites/{site}/tanks` preserved. Web also uses flat `/api/tanks`; no blind migration or guessed site is performed. |
| Fleet and deliveries | `/api/tankers`, `/api/drivers`, eligible/detail/create/update/deactivate; `/api/deliveries` assignment/start/complete/fail and current tracking/timeline match local controllers. Required command/window/volume semantics from prior backend alignment retained. No invented delivery-by-order/dispatch endpoint. |
| Payments | `/api/payments` create/company/order/complete/refund routes exist; backend CreatePaymentResource derives amount and validates optional company. Existing UI now registers only; generic complete wrapper remains available only for callers with real evidence. Web provider-payment filters are not newly added mobile features. |
| Notifications, analytics, reports | `/api/me/notifications`, unread/read; `/api/analytics/buyers|providers/{id}`; `/api/v2/reports/*/export` CSV match controllers. Generic create-notification/rating mutations remain explicitly unsupported. |

### Verification and remaining boundaries

- RED observed: old auth Bearer/rememberMe behavior; expired and late-restored session; request detail UnsupportedError; accepted request incorrectly mapped as order ID77 instead of linked42; inventory scope `(1,1)`, mock-data error fallback, ambiguous-site guessing and concealed UI failure; payment company1/invented amount and standalone unauthenticated client.
- GREEN: full `/home/ejos/flutter/bin/flutter test --no-pub` passes **77 tests** after implementation. Focused auth/contracts/adapter/inventory suites passed 30 tests before the final detail/payment additions; final full suite covers those additions. No live backend/payment calls were made (loopback test server only).
- Final Dart format normalization completed before checks; `git diff --check` passes. Final `flutter analyze --no-pub` exits 1 with exactly 17 baseline diagnostics and no new diagnostics; this is a known nonzero check, not a clean pass. Parent/verifier must build Android debug APK for the final API candidate.
- Rollback boundary: this API-slice commit removes only auth/client/affected inventory-order-payment adapters, safe UI states and their tests/docs; styling main commit `c780b29` remains intact. Parent owns fresh native RDD candidate consent/review, merge and push. Styling decline does not apply to this candidate.
- Device visual/motion validation remains pending. Existing illustrative telemetry/alerts/restock preview content and web-only organization/administration/device-management features were not expanded into new mobile features. These are not claimed as runtime API parity or live telemetry verification.
- Work-unit commit identity and actual authored line count will be returned in handoff after local commit. FMP-3 final APK/device checks remain pending; no main mutation or remote push by this worker.

# Mobile Backend API Alignment

Align the Flutter client with the backend after its authorized merge of `origin/main`. Static reconciliation and the first route/session implementation are complete; broader coverage and UI input gaps remain.

## Quick path

1. Fix the API root and migrate mobile calls to current routes and DTOs.
2. Carry authenticated company/provider identity through the session; remove fixed tenant IDs.
3. Add HTTP/adapter contract coverage, then verify on the supported toolchains.

## Scope and constraints

| Area | Scope |
|---|---|
| In scope | Flutter API client/facade, auth/session and tenant identifiers, feature adapters/mappers, contract tests, directly relevant configuration/docs. |
| Out of scope | Further backend changes, unrelated UI redesign, deployment, push, PR, or merge. |
| Backend baseline | `/home/ejos/Documents/proyectos_code/backend` at `7c34b0e5c4a8fea4f2c575d27bf88e5ab1b9dbff`. |
| TDD | Strict TDD is enabled. Runner resolved as `flutter test` (Flutter 3.47.2, Dart 3.13.2). Require observed RED, GREEN, then REFACTOR. |
| Backend verification blocker | Focused Maven tests were attempted with `bash mvnw -Dtest=CustomerTanksControllerTest,ReportExportControllerTest,FullTankPlatformApplicationTests test`; compilation is blocked because the project requires Java 26 and only JDK 25 is installed. No backend test pass is claimed. |
| Delivery | Substantial ODD implementation: use one delegated direct writer for the multi-file API/session/adapter changes. Keep tests with each work unit and record Conventional Commit evidence here. |

## Reconciliation evidence

CodeGraph was checked before filesystem exploration in both repositories. The backend checkout is exactly the merged commit above. Backend source has no `server.servlet.context-path` or `spring.mvc.servlet.path` override; controllers declare `/api/...` routes (with only specific controllers under `/api/v2/...`). The mobile default `API_BASE_URL` ends in `/api/v1`, so ordinary `FullTankApi` calls currently address a non-matching prefix. `getV2` strips that suffix and addresses the server root.

### Safe route/method matches (after correcting the API root)

These paths/methods exist in the current backend; still add contract tests for response mapping and role behavior before calling their adapters complete:

| Mobile calls | Current backend contract | Qualification |
|---|---|---|
| sign-in, sign-up, password-reset request/confirm | `POST /api/authentication/sign-in`, `/sign-up`, `/password-reset/request`, `/password-reset/confirm` | Body keys match (`username/password`; signup `roles` plus exactly one nested company profile; reset `email` and `token/newPassword`). Reset request returns 202 JSON; confirm returns 204 empty. Sign-in resource is `{id, username, token, roles, companyId, providerId, memberships:[{organizationId, role}]}`. |
| buyer/provider company detail/update; provider-company list | `/api/buyer-companies/{id}`, `/api/provider-companies[/id]` | Detail/update require owning tenant; provider list requires buyer role. Buyer-company list is admin-only, not a general buyer list. Legacy company POSTs exist but are deprecated and do not create a user or membership; use authentication sign-up for onboarding. |
| fuel-order list/detail, create, confirm/cancel | `/api/fuel-orders`, `/company/{companyId}`, `/provider/{providerId}`, `/{orderId}`, `POST /{orderId}/confirm|cancel` | Company/provider reads require matching authenticated tenant. No mobile `receive` call exists; backend exposes `POST /{orderId}/receive`. |
| fuel products, create/update/stock/delete | `/api/fuel-products`, `/provider/{providerId}`, `/{fuelProductId}`, `POST /{id}/update-stock`, `PUT/DELETE /{id}` | Catalog list requires buyer role; provider-specific list permits buyer or owning provider. Product resource uses `fuelType` and `pricePerUnit` (mobile mapper already accepts those aliases). |
| equipment create/update/list/detail | `/api/equipment`, `/company/{companyId}`, `/{equipmentId}`, `POST /{equipmentId}/update` | Company list requires owner; unfiltered list is admin-only. Equipment reads/updates are owner-scoped. The mobile `favoriteProvider` method has no matching route. |
| payments and analytics | `/api/payments/company/{companyId}`, `/order/{orderId}`, `/api/analytics/buyers/{companyId}`, `/providers/{providerId}` | Tenant-specific routes require ownership. Preserve `transactionReference` for payment completion; confirm full response-field mappings in contract tests. |
| customer tanks, CSV export | `GET /api/v2/buyer-companies/{companyId}/sites/{siteId}/tanks[/{tankId}]`; `GET /api/v2/reports/{buyers/{companyId}|providers/{providerId}|platform}/export` | These v2 roots exist. Tank calls require company ownership; report exports return `text/csv` and require owner for buyer/provider or admin for platform. |

### Confirmed mismatches and required changes

| Mobile call/assumption | Current backend evidence | Proposed client change |
|---|---|---|
| Default `API_BASE_URL=/api/v1` for ordinary calls | Controllers use `/api/...`; no global context-path adds `/v1`. | Change default/config contract to `/api` (or a host-only root plus explicit `/api` paths); update HTTP contract tests for both normal and v2 URLs. |
| `fuelRequests`, `createFuelRequest`, `acceptFuelRequest`, `rejectFuelRequest` on `/api/fuel-requests` | No current `FuelRequestsController`/`/api/fuel-requests` route exists. Replacement is `/api/replenishment-requests`: GET collection (active organization), GET `/inbox` (authenticated provider), POST collection, POST `/{id}/accept`, `/reject`, `/cancel`. | Replace old fuel-request routes with replenishment routes and adapt request/response model. Create DTO uses `customerAccountId`, `tankId`, `providerId`, `fuelProductId`, `quantity`, `unit`, optional `source`, `episodeKey`, `deliveryAddress`, `deliveryDate`; organization is derived from active membership, not `buyerCompanyId`. `equipmentId` is not the replacement field. Use `/inbox` for provider requests; no client-selected provider filter. Confirm allowed `source` enum rather than sending old `MOBILE`. |
| Default buyer/provider IDs (`companyId = 1`, `providerId = 1`) and explicit IDs in list calls | Sign-in returns `companyId`, `providerId`, roles, and memberships. Backend tenant access derives provider identity from the JWT/principal; replenishment additionally derives the active organization from membership. Company/provider ownership checks reject unrelated IDs. | Extend `AuthSession` and persistence/restore with actual tenant IDs and role/membership context; supply them from authenticated state, never fallback IDs. Call provider inbox/current-organization collection without spoofable tenant query values where backend derives identity. |
| `notifications(userId)`, `unreadNotifications(userId)`, `notificationsV2(userId)`, create notification, mark-as-read legacy path | Current API is `GET /api/me/notifications`, `GET /api/me/notifications/unread`, `POST /api/me/notifications/{notificationId}/read`. No generic notification-create or `/api/v2/users/{id}/notifications` route exists. | Use current-user paths without a caller-supplied user ID; change mark path to `/{id}/read`; remove or explicitly disable generic create unless a supported product workflow is identified. |
| `vehicles(providerId)` and vehicle CRUD at `/api/vehicles`; `eligibleFleet` at `/api/v2/fleet/eligible` | No `/api/vehicles` or `/api/v2/fleet/eligible` controller exists. Fleet APIs are `/api/tankers` and `/api/drivers`, with `/eligible` for each. Tenant IDs are derived from the provider principal. Tanker DTO uses `licensePlate, brand, model, capacity, unit, status`; driver DTO is a separate driver identity. Deletes are not provided: `POST /{id}/deactivate` preserves records; activate is also a POST. | Replace vehicle API/model with tanker where that is the intended fleet concept; use the current principal-scoped list/eligible paths; map tanker vs driver separately. Replace DELETE with deactivate semantics. Do not send `providerId` as authority. |
| Delivery creation sends `providerId`, `vehicleId`, `scheduledDate` and omits idempotency/window fields | `POST /api/deliveries` consumes `commandId, orderId, driverId, tankerId, windowStart, windowEnd, scheduledDate, notes`; provider ID comes from the principal. Requires an order backed by a replenishment request accepted by that provider. Response is assignment data including `deliveryId`, `orderId`, `providerId`, `driverId`, `tankerId`, reservation IDs, physical state, and command ID. | Replace create body with the assignment contract; source provider from auth and vehicle identifier becomes `tankerId`. Add required idempotency `commandId`, delivery window fields, and accept-before-assign flow. |
| `dispatchDelivery` `/deliveries/{id}/dispatch`; `deliveryForOrder`; provider delivery list `/deliveries/provider/{id}` | No dispatch action or delivery-by-order route. Assignment is POST collection; lifecycle is POST `/{id}/start`, `/arrive`, `/complete`, `/fail`, `/cancel`. Provider list is GET `/api/deliveries` with optional `providerId` that must equal principal and optional ISO date; GET `/{id}` is available. | Replace dispatch with `start`; remove or redesign order lookup (no equivalent); list current provider at collection root. `complete` requires `{deliveredVolume}`; `fail`/`cancel` require `{reason}`. |
| `tracking/latest`, v2 tracking/timeline paths | Tracking latest is `GET /api/deliveries/{id}/tracking`; samples are `/tracking/samples`; timeline is `/api/deliveries/{id}/timeline`. No `/api/v2/deliveries/...` or `/tracking/latest` route. | Point latest/tracking/timeline to these exact `/api` paths; map `latestTracking` to the existing latest route or samples only if its intended meaning is history. |
| `providerRatings`, `createProviderRating`, `updateProviderRating` | No current provider-ratings controller/route exists in the checked-out backend. Provider company resource contains a rating field, but its update endpoint intentionally ignores `rating`. | Remove/disable unsupported rating mutations or identify an existing supported workflow; do not assume provider-profile update writes a rating. |
| `equipment/{id}/favorite-provider` | Current equipment controller has no matching favorite-provider mapping. | Remove/disable this call or use a supported field only as part of an owner-authorized equipment update if product semantics explicitly permit it; do not invent a route. |
| `/api/users` list/detail | Route exists, but list is admin-only and detail is self-only. | Do not use as a general directory; keep only if those authorization semantics match the feature. |

### Test and adapter targets

- `test/api_http_contract_test.dart`: default URL prefix, v2 URL stripping, exact route/method/query/body, Bearer header, empty/CSV response handling.
- `test/backend_mapping_test.dart`: sign-in tenant fields and persistence/restore; replenishment DTO/resource fields; order/resource status mappings; provider-scoped drivers/tankers; delivery assignment and lifecycle payloads; tank and analytics/report mappers.
- Add focused assertions for missing-route behavior (notifications, ratings, favorite provider, order-to-delivery lookup) so no stale endpoint is silently reintroduced.
- Flutter runner is `flutter test` (Flutter 3.47.2 / Dart 3.13.2); behavior-first implementation tests now cover the initial route/session contract.

## Tasks

- [x] **MBA-0 — Reconcile the backend contract baseline after the main merge.** Verified `HEAD` equals merge commit `7c34b0e5c4a8fea4f2c575d27bf88e5ab1b9dbff`, rebuilt the current route/auth inventory, and corrected stale pre-merge claims. The focused Maven test attempt remains blocked by JDK 26 requirement versus installed JDK 25; static reconciliation is not a test pass. Route: delegated backend reconciliation. Dependency: complete before implementation.
- [x] **MBA-1 — Inventory current backend/mobile contracts.** Compared the current `FullTankApi` surface and affected auth/order/inventory/fleet/dispatch/report adapters to backend routes, resources, role checks, and tenant derivation. Every stale path above is classified as supported, mismatched, or unsupported/no equivalent; unclear response mapping is explicitly assigned to contract tests. Route: delegated exploration. Evidence: CodeGraph both repos, current controller/resource sources, controller route scan, and no context-path config.
- [x] **MBA-2 — Align endpoints and request/response adapters.** Updated the `/api` root, replenishment, notifications, tankers/drivers, delivery lifecycle, tracking/timeline, and current v2 tank/report routes. Unsupported rating, notification-create, request-detail, and delivery-by-order operations now fail explicitly instead of calling absent routes. Delivery creation maps command/tanker/window fields; tanker/driver deactivation uses POST routes. Completion now requires delivered volume. The provider's legacy "dispatch" action no longer mistakes an order ID for a delivery ID; assignment is surfaced as unavailable until the required command/driver/tanker/window inputs exist. Route: delegated direct writer. Evidence: strict TDD RED/GREEN and passing route/mapping checks.
- [x] **MBA-3 — Align authentication and tenant identity.** `AuthSession` now carries company/provider IDs, roles, and memberships; secure token storage saves/restores the added context, sign-in hydrates it from the backend, and orders/reports/dispatch/provider-order adapters consume current session identity. Removed fixed tenant IDs and omitted provider IDs where the backend derives them from the principal. Bearer token behavior remains unchanged. Order creation now rejects missing tank/product/provider selections instead of sending dummy IDs; the UI still needs to expose those selections. Route: delegated direct writer. Evidence: strict TDD RED/GREEN and passing session/mapping checks.
- [ ] **MBA-4 — Expand contract coverage and verify.** Continue route/mapping/auth/tenant isolation coverage beyond the implemented slices and resolve UI selection workflows for tank/product/provider and delivery assignment. Strict TDD RED/GREEN was observed; `dart format`, full `flutter test`, and `flutter analyze` pass. Report Java checks as blocked until JDK 26 is available; do not claim cross-project test success.

## Acceptance criteria

- [x] Static classification covers every exposed `FullTankApi` route family and affected mobile adapter call site against the merged backend's route/method, DTO/resource, auth, and tenant assumptions; unsupported paths are called out above.
- [ ] Ordinary mobile API paths use `/api`, while only confirmed backend v2 controllers use `/api/v2`.
- [ ] Request/response fields and expected status/body semantics match current backend resources, including replenishment, payment completion, delivery assignment/lifecycle, tanks, auth, and CSV export.
- [ ] Tenant-scoped IDs come from the authenticated session/context or are omitted when the backend derives identity; no default-ID access remains in affected production calls.
- [ ] Unsupported features are adapted to a supported workflow or surfaced unavailable; no speculative route is introduced.
- [ ] Contract/adapter tests pass under the discovered Flutter runner after observed RED/GREEN/REFACTOR. Backend focused tests are separately rerun when Java 26 is available.
- [ ] Each implementation task is checked only after observed outcome/verification; each ODD work unit has Conventional Commit evidence on the feature branch.

## Progress and verification

- Current status: MBA-0 through MBA-3 implementation complete; MBA-4 remains open for broader route/role coverage and final verification review. UI input gaps for order tank/product/provider and delivery assignment are surfaced safely rather than sent as fabricated backend requests.
- Backend commit: `7c34b0e5c4a8fea4f2c575d27bf88e5ab1b9dbff` (`chore(backend): merge latest main`).
- Backend Maven test: attempted, blocked during compile because installed JDK is 25 while backend targets Java 26. This blocker remains open; no Java test pass is claimed.
- Flutter: `flutter test` — PASS (55 tests); `flutter test test/missing_pages_test.dart` — PASS (5 tests); `flutter analyze` — PASS (no issues); `git diff --check` — PASS. Focused RED was observed before route/DTO and session behavior changes; GREEN followed, then `dart format` and the full test/analyzer rerun passed.
- Mobile implementation: API root/routes, delivery/tanker/driver adapters, tenant persistence, repository session wiring, and contract tests changed; backend source untouched.
- ODD work-unit commit: `cf0c7e7` (`fix(mobile): align backend routes and session identity`).
- Backend focused Maven tests remain blocked by JDK 25 vs required JDK 26; no backend pass is claimed.
- Next step: close MBA-4 with broader behavior coverage and review the UI input gaps; record commits and rerun backend checks when Java 26 is available.

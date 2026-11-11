# Mobile Flow Gaps Fix

Wire the Flutter screens that were found to be local-only, static or unreachable to the real backend contracts, using the sibling repos as reference.

## Objective and problem

A static review of the app (wireframes in `../Mobile-app-wireframes/`) found screens that look finished but do nothing against the backend. Fix every gap the backend supports; leave the rest explicitly disabled or hidden instead of faking success.

## Scope and constraints

| Area | Detail |
|---|---|
| Branch | `fix/mobile-flow-gaps` from `main` (`72af247`). Merge to local `main` when green. No push, no PR. |
| Reference | Backend `/home/ejos/Documents/proyectos_code/backend` (source of truth for contracts). Frontend `/home/ejos/Documents/proyectos_code/primefuel-frontend-reference` (UX reference). |
| TDD | Strict TDD enabled (project config). Runner `flutter test`. Require observed RED, GREEN, REFACTOR. |
| Route | One delegated writer per task group, single writer thread (mapping trigger fired: 4+ files; writer trigger fired: 2+ non-trivial files). |
| Out of scope | Backend changes, push/PR, redesign. |
| Blocked by backend (do not fake) | Support ticket submit, change-password form, invoice download, buyer-side live tracking, customer edit/archive. |

## Checklist

- [x] **T1** Route the real API sign-up (`SignUpPage`) on `/signup*`, with initial role for `/signup/provider`; remove the mock `SignupPage`.
- [x] **T2** Password recovery: `RecoverPage` calls `requestPasswordReset`, always shows the sent stage (no "not found"); route `/reset-password?token=` to `ResetPasswordPage`; add to auth-route redirect; add `fulltank://` scheme in Android/iOS config.
- [x] **T3** `RestockPage` submits through `OrdersRepository.create` with real tank, provider, product, date; drop mock data and unsupported priority/notes.
- [x] **T4** Home variant derived from `session.roles` (`ROLE_PROVIDER`), plus router role guards for provider-only and buyer-only routes.
- [x] **T5** Account profile edit loads and saves company data (`PUT /buyer-companies/{id}` or `/provider-companies/{id}`); security screen signs out via API and offers the reset-email path instead of a fake password change.
- [x] **T6** Unsupported buttons ("Descargar factura", buyer "Seguimiento en vivo") hidden or disabled with a clear message; provider tracking wired; history CSV export wired only if a save/share path exists.
- [ ] **T7** Home dashboard numbers from analytics, orders and tanks instead of constants.
- [ ] **T8** Provider customers list from `GET /api/provider/buyer-companies`.

## Acceptance

- `flutter analyze` and `flutter test` pass on the branch; failures reported honestly.
- Each task has tests written first (RED observed), and one Conventional Commit.
- No screen reports success without a backend call, except where it is labelled as local.

## Progress

Branch created. Baseline and tasks pending. Engram mirror `odd/mobile-flow-gaps-fix/tasks` is PENDING: the first `mem_save` was blocked by the auto-mode classifier because a hook altered the call. Local file is the source of truth until it is resynced.

## Verification evidence

- Baseline (before changes): `flutter analyze` 17 issues (pre-existing: unused_element/deprecated_member_use/unused_import in dispatches, orders, test/dispatch_pages_test.dart); `flutter test` 77 passed, 0 failed.
- T1: RED = `test/signup_routes_test.dart` failed to compile (`initialRole` undefined on `SignUpPage`); GREEN = signup route, missing_pages and sign_up_page tests pass. Mock `SignupPage` tests removed with the mock.
- T2: RED = 7 new tests failed in `recover_page_test.dart` / `reset_route_test.dart` (no repo call, no error state, no `/reset-password` route); GREEN = 10/10 pass.
- T4: RED = 7 of 12 `role_routing_test.dart` tests failed (home variant ignored roles, no guards); GREEN = 13/13 pass after pure-function guard tests replaced two router tests that built real network pages.
- End of T4: `flutter analyze` 17 issues (same pre-existing set, none new); `flutter test` 98 passed, 0 failed.
- Not verifiable here: native deep link `fulltank:///reset-password?token=` (Android intent-filter, iOS CFBundleURLTypes) needs a device.
- T4b (nav): RED = buyer still saw Despachos in `bottom_nav_roles_test.dart`; GREEN = 5/5; analyze 17, tests 103 pass.
- T3: RED = 5 new `restock_page_test.dart` tests failed (page was local-only); GREEN = 6/6 (real tank/provider/product/qty/date reach `OrdersRepository.create`, failure shows error, empty quantity and missing provider make no call, preview labelled). `inventory_page_test` restock test now wraps a ProviderScope.
- T5: RED = compile failure (no `CompanyProfileRepository`, no `companyProfileRepositoryProvider`); GREEN = 4 repository tests (load, buyer/provider full-replace payload, failure) + 10 widget tests (load, save, save error, RUC validation, load error, guest preview, reset email, reset error, sign-out, fake rows gone). `account_page_test` now wraps a ProviderScope.
- T6: RED = 3 behavioural failures visible in `orders_unsupported_actions_test.dart` (invoice button, live tracking button, old export label) plus missing export tooltip; GREEN = 6/6.
- End of T6: `flutter analyze` 17 issues (same pre-existing set, none new); `flutter test` 128 passed, 0 failed.
- Route evidence: delegated writer (single writer thread) for T1, T2, T4; second delegated writer for T4b, T3, T5, T6.

## Commits

- T1 `37076c3` fix(auth): route the API sign-up screen
- T2 `f8f08f6` fix(auth): wire password recovery and reset route
- T4 `7635381` feat(auth): derive home variant and route guards from session roles
- T4b `1522257` fix(nav): hide provider-only tabs from buyers
- T3 `29b5df1` fix(inventory): submit restock requests through the replenishment API
- T5 `a7407c2` fix(account): load and save company profile and wire security actions
- T6 `a28fde5` fix(orders): remove actions the backend cannot back

## Next step

T1-T6 done. Next: T7 (home dashboard numbers), T8 (provider customers list). Open follow-ups: provider tracking view not built (hidden for all, delivery-id lookup is not small); Account overview still shows static plan/member-since/sessions card and quick actions sheet "Crear pedido" is buyer-only; native deep link needs device check.

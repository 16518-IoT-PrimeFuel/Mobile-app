# Mobile tanks and report export

## Objective

Connect the inventory tank screens and report export action to the committed v2 backend contract while preserving mock-backed visual tests.

## Scope

- Add v2 tank list/detail adapters and mock fallback.
- Add CSV export adapter and a visible success/error result.
- Add focused tests and update implementation status.

## Constraints

- Mobile slice only.
- Reuse the existing HTTP client and Riverpod architecture.
- Do not add a file-saving dependency.

## Checklist

- [x] T1: Map tank v2 responses into the inventory UI.
- [x] T2: Wire report export to the CSV route.
- [x] T3: Verify tests, analyzer, and documentation.

## Route

Delegated direct was unavailable in this runtime; implementation is kept bounded to the existing inventory/report files.

## Checks

- `flutter analyze`
- `flutter test`

## Evidence

- `flutter analyze`: passed.
- `flutter test`: passed, 50 tests.
- Runtime harness: N/A; no device/emulator boundary was requested or available.
- Rollback boundary: remove the tank v2 and CSV adapter changes plus their focused tests/docs.

# Inventory UI integration

Objective: connect inventory-owned product UI to the existing inventory repository while preserving mock tank/IoT visuals.

Constraints: touch only `lib/features/inventory/presentation` and, if needed, inventory application code. Do not modify orders, dispatch, reports, `main.dart`, backend, or unrelated user changes.

Checks: `flutter analyze`; focused inventory tests.

- [ ] I1 Add controller save operation for product edits.
- [ ] I2 Render API/controller-backed product list with loading, empty, and error states.
- [ ] I3 Add focused edit interaction coverage and run checks.

Route: direct inline because the scoped change is understood and delegation tools are unavailable in this session.

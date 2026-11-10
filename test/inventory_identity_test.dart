import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_controller.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/inventory/application/inventory_providers.dart';

void main() {
  ProviderContainer containerFor(_InventoryApi api) => ProviderContainer(
    overrides: [
      fullTankApiProvider.overrideWithValue(api),
      authControllerProvider.overrideWith(
        (ref) => _SignedIn(ref.read(authRepositoryProvider)),
      ),
    ],
  );

  test(
    'authenticated inventory derives company and unique site from real identity',
    () async {
      final api = _InventoryApi();
      final container = containerFor(api);
      addTearDown(container.dispose);
      final tanks = await container.read(inventoryTanksProvider.future);
      expect(tanks.single.id, 'tank-4');
      expect(api.tankScope, (17, 5));
    },
  );

  test(
    'authenticated inventory propagates API failure instead of sample tanks',
    () async {
      final api = _InventoryApi()..fail = true;
      final container = containerFor(api);
      addTearDown(container.dispose);
      await expectLater(
        container.read(inventoryTanksProvider.future),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test(
    'multiple sites are unavailable without an explicit site selection',
    () async {
      final api = _InventoryApi()..multipleSites = true;
      final container = containerFor(api);
      addTearDown(container.dispose);
      await expectLater(
        container.read(inventoryTanksProvider.future),
        throwsA(isA<StateError>()),
      );
      expect(api.tankScope, isNull);
    },
  );
}

class _SignedIn extends AuthController {
  _SignedIn(super.repository) {
    state = const AuthState(
      status: AuthStatus.authenticated,
      session: AuthSession(
        username: 'buyer',
        token: 'real-token',
        companyId: 17,
        memberships: [
          {'organizationId': 17, 'role': 'OWNER'},
        ],
      ),
    );
  }
}

class _InventoryApi extends FullTankApi {
  _InventoryApi() : super(ApiClient());
  bool fail = false;
  bool multipleSites = false;
  (int, int)? tankScope;
  @override
  Future<dynamic> customers() async => [
    {'id': 23, 'legacyCompanyId': 17, 'active': true},
  ];
  @override
  Future<dynamic> customerSites(int customerId) async => [
    {'id': 5, 'active': true},
    if (multipleSites) {'id': 6, 'active': true},
  ];
  @override
  Future<dynamic> providerCompanies() async => [];
  @override
  Future<dynamic> fuelProducts({int? providerId}) async => [];
  @override
  Future<dynamic> tanks(int companyId, int siteId) async {
    tankScope = (companyId, siteId);
    if (fail) throw const ApiException(503, 'offline');
    return [
      {
        'id': 'tank-4',
        'siteId': siteId,
        'name': 'Actual tank',
        'capacity': 1000,
        'currentLevel': 400,
      },
    ];
  }
}

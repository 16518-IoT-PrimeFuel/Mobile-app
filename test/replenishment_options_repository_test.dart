import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/orders/data/replenishment_options_repository.dart';

void main() {
  test('resolves the customer account by legacy company identity', () async {
    final options = await ApiReplenishmentOptionsRepository(_OptionsApi()).load(
      companyId: 17,
      memberships: const [
        {'organizationId': 17, 'role': 'ROLE_BUYER'},
      ],
    );

    expect(options.customerAccountId, 23);
    expect(options.sites.single.id, 5);
    expect(options.providers.single.id, 9);
    expect(options.products.single.providerId, 9);
    expect(
      (await ApiReplenishmentOptionsRepository(
        _OptionsApi(),
      ).tanks(companyId: 17, siteId: 5)).single.id,
      'tank-4',
    );
  });

  test('refuses ambiguous memberships and never guesses an account', () async {
    final options = await ApiReplenishmentOptionsRepository(_OptionsApi()).load(
      companyId: 17,
      memberships: const [
        {'organizationId': 17},
        {'organizationId': 18},
      ],
    );

    expect(options.customerAccountId, isNull);
    expect(options.unavailableReason, contains('organización activa'));
  });
}

class _OptionsApi extends FullTankApi {
  _OptionsApi() : super(ApiClient());

  @override
  Future<dynamic> customers() async => [
    {'id': 23, 'legacyCompanyId': 17, 'name': 'Buyer', 'active': true},
  ];

  @override
  Future<dynamic> customerSites(int customerId) async => [
    {
      'id': 5,
      'customerAccountId': customerId,
      'name': 'Main site',
      'active': true,
    },
  ];

  @override
  Future<dynamic> providerCompanies() async => [
    {'id': 9, 'name': 'Provider', 'active': true},
  ];

  @override
  Future<dynamic> fuelProducts({int? providerId}) async => [
    {'id': 8, 'providerId': 9, 'name': 'Diesel B5', 'active': true},
  ];

  @override
  Future<dynamic> tanks(int companyId, int siteId) async => [
    {'id': 'tank-4', 'siteId': siteId, 'name': 'Tank 4', 'status': 'ACTIVE'},
  ];
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/account/data/company_profile_repository.dart';

void main() {
  test('loads a buyer company', () async {
    final api = _Api();
    final profile = await CompanyProfileRepository(
      api,
    ).load(provider: false, id: 17);
    expect(api.loaded, 'buyer:17');
    expect(profile.isProvider, isFalse);
    expect(profile.name, 'PetroAndes');
    expect(profile.ruc, '20123456789');
    expect(profile.sector, 'Mining');
    expect(profile.contactEmail, 'ops@petro.test');
  });

  test('buyer save sends every editable field (full replace)', () async {
    final api = _Api();
    final repo = CompanyProfileRepository(api);
    final profile = await repo.load(provider: false, id: 17);
    await repo.save(profile.copyWith(phone: '999111222'));
    expect(api.saved, 'buyer:17');
    expect(api.payload, {
      'name': 'PetroAndes',
      'ruc': '20123456789',
      'sector': 'Mining',
      'address': 'Av. Lima 1',
      'contactEmail': 'ops@petro.test',
      'phone': '999111222',
    });
  });

  test('provider save keeps fuel types and omits rating', () async {
    final api = _Api();
    final repo = CompanyProfileRepository(api);
    final profile = await repo.load(provider: true, id: 9);
    expect(profile.isProvider, isTrue);
    await repo.save(profile.copyWith(description: 'New text'));
    expect(api.saved, 'provider:9');
    expect(api.payload, {
      'name': 'Global Fuel',
      'ruc': '20987654321',
      'address': 'Calle 2',
      'phone': '555',
      'fuelTypesOffered': ['DIESEL', 'GASOLINE'],
      'description': 'New text',
    });
  });

  test('save failure propagates', () async {
    final repo = CompanyProfileRepository(_Api(fail: true));
    final profile = await repo.load(provider: false, id: 17);
    expect(() => repo.save(profile), throwsA(isA<Exception>()));
  });
}

class _Api extends FullTankApi {
  _Api({this.fail = false}) : super(ApiClient());
  final bool fail;
  String? loaded;
  String? saved;
  Map<String, dynamic>? payload;

  @override
  Future<dynamic> buyerCompany(int id) async {
    loaded = 'buyer:$id';
    return {
      'id': id,
      'name': 'PetroAndes',
      'ruc': '20123456789',
      'sector': 'Mining',
      'address': 'Av. Lima 1',
      'contactEmail': 'ops@petro.test',
      'phone': '555',
    };
  }

  @override
  Future<dynamic> providerCompany(int id) async => {
    'id': id,
    'name': 'Global Fuel',
    'ruc': '20987654321',
    'address': 'Calle 2',
    'phone': '555',
    'fuelTypesOffered': ['DIESEL', 'GASOLINE'],
    'description': 'Old',
    'rating': 4.5,
  };

  @override
  Future<dynamic> updateBuyerCompany(int id, Map<String, dynamic> body) async {
    if (fail) throw Exception('boom');
    saved = 'buyer:$id';
    payload = body;
    return {'id': id, ...body};
  }

  @override
  Future<dynamic> updateProviderCompany(
    int id,
    Map<String, dynamic> body,
  ) async {
    if (fail) throw Exception('boom');
    saved = 'provider:$id';
    payload = body;
    return {'id': id, ...body};
  }
}

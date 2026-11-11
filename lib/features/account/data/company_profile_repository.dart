import '../../../data/fulltank_api.dart';

/// Editable company profile of the signed-in buyer or provider.
///
/// The backend `PUT` endpoints replace the whole resource, so a profile is
/// always loaded first and every editable field is sent back on save.
class CompanyProfile {
  const CompanyProfile({
    required this.isProvider,
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
    required this.phone,
    this.sector = '',
    this.contactEmail = '',
    this.description = '',
    this.fuelTypesOffered = const [],
  });

  final bool isProvider;
  final int id;
  final String name;
  final String ruc;
  final String address;
  final String phone;

  /// Buyer only.
  final String sector;
  final String contactEmail;

  /// Provider only.
  final String description;
  final List<String> fuelTypesOffered;

  CompanyProfile copyWith({
    String? name,
    String? ruc,
    String? address,
    String? phone,
    String? sector,
    String? contactEmail,
    String? description,
  }) => CompanyProfile(
    isProvider: isProvider,
    id: id,
    name: name ?? this.name,
    ruc: ruc ?? this.ruc,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    sector: sector ?? this.sector,
    contactEmail: contactEmail ?? this.contactEmail,
    description: description ?? this.description,
    fuelTypesOffered: fuelTypesOffered,
  );

  Map<String, dynamic> toPayload() => isProvider
      ? {
          'name': name,
          'ruc': ruc,
          'address': address,
          'phone': phone,
          'fuelTypesOffered': fuelTypesOffered,
          'description': description,
        }
      : {
          'name': name,
          'ruc': ruc,
          'sector': sector,
          'address': address,
          'contactEmail': contactEmail,
          'phone': phone,
        };
}

class CompanyProfileRepository {
  const CompanyProfileRepository(this.api);
  final FullTankApi api;

  Future<CompanyProfile> load({required bool provider, required int id}) async {
    final raw = provider
        ? await api.providerCompany(id)
        : await api.buyerCompany(id);
    if (raw is! Map) throw const FormatException('Invalid company response');
    return _map(raw, provider: provider, id: id);
  }

  Future<CompanyProfile> save(CompanyProfile profile) async {
    final body = profile.toPayload();
    final raw = profile.isProvider
        ? await api.updateProviderCompany(profile.id, body)
        : await api.updateBuyerCompany(profile.id, body);
    return raw is Map
        ? _map(raw, provider: profile.isProvider, id: profile.id)
        : profile;
  }

  CompanyProfile _map(Map raw, {required bool provider, required int id}) =>
      CompanyProfile(
        isProvider: provider,
        id: id,
        name: _text(raw['name']),
        ruc: _text(raw['ruc']),
        address: _text(raw['address']),
        phone: _text(raw['phone']),
        sector: _text(raw['sector']),
        contactEmail: _text(raw['contactEmail']),
        description: _text(raw['description']),
        fuelTypesOffered: raw['fuelTypesOffered'] is List
            ? [for (final item in raw['fuelTypesOffered']) '$item']
            : const [],
      );

  String _text(Object? value) => value == null ? '' : '$value';
}

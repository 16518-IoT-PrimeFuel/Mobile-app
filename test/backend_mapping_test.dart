import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/core/storage/token_storage.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/auth/auth_api_repository.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/orders/data/api_orders_repository.dart';
import 'package:mobile_app/features/orders/domain/order.dart';
import 'package:mobile_app/features/dispatches/data/api_dispatch_repository.dart';
import 'package:mobile_app/features/dispatches/domain/driver.dart';
import 'package:mobile_app/features/reports/data/api_reports_repository.dart';

void main() {
  test('order adapter maps backend response names and statuses', () async {
    final orders = await ApiOrdersRepository(
      _BackendApi(),
      companyId: 17,
      providerId: null,
      providerMode: false,
    ).list();

    expect(orders, hasLength(1));
    expect(orders.single.id, '42');
    expect(orders.single.quantity, 120.0);
    expect(orders.single.total, 186.0);
    expect(orders.single.status, OrderStatus.inTransit);
  });

  test('vehicle adapter sends the backend resource fields', () async {
    final api = _VehicleBackendApi();
    final vehicle = await ApiDispatchRepository(api, providerId: 9)
        .createVehicle(
          plate: 'ABC-123',
          brand: 'Freightliner',
          model: 'M2',
          capacity: 12000,
        );

    expect(vehicle.id, 81);
    expect(api.body, {
      'providerId': 9,
      'licensePlate': 'ABC-123',
      'brand': 'Freightliner',
      'model': 'M2',
      'capacity': 12000,
      'unit': 'LITERS',
      'status': 'AVAILABLE',
    });
  });

  test('driver and delivery adapters use backend request fields', () async {
    final api = _DispatchBackendApi();
    final repository = ApiDispatchRepository(api, providerId: 9);
    await repository.createDriver(
      const Driver(
        id: 0,
        firstName: 'Ana',
        lastName: 'Navarro',
        licenseNumber: 'A-2',
        phoneNumber: '+51999999999',
        email: 'ana@example.test',
      ),
    );
    await repository.createDelivery(
      orderId: 42,
      driverId: 7,
      vehicleId: 81,
      scheduledDate: DateTime(2026, 9, 1),
    );

    expect(api.driverBody, {
      'providerId': 9,
      'firstName': 'Ana',
      'lastName': 'Navarro',
      'licenseNumber': 'A-2',
      'phoneNumber': '+51999999999',
      'email': 'ana@example.test',
      'status': 'AVAILABLE',
    });
    expect(api.deliveryBody, {
      'orderId': 42,
      'providerId': 9,
      'driverId': 7,
      'vehicleId': 81,
      'scheduledDate': '2026-09-01',
      'notes': '',
    });
  });

  test(
    'analytics adapter maps backend monthly values and order volume',
    () async {
      final summary = await ApiReportsRepository(
        _AnalyticsBackendApi(),
        providerId: null,
        companyId: 17,
        providerMode: false,
      ).summary();

      expect(summary.revenue, 1800.0);
      expect(summary.orders, 3);
      expect(summary.confirmedOrders, 2);
      expect(summary.liters, 260.0);
      expect(summary.monthly.single.month, '2026-08');
      expect(summary.monthly.single.amount, 1800.0);
    },
  );

  test('signup creates the business and account in one request', () async {
    final api = _SignupBackendApi();
    final repository = AuthApiRepository(
      api: api,
      storage: const TokenStorage(FlutterSecureStorage()),
    );
    await repository.signUp(
      const SignUpRequest(
        username: 'buyer@example.test',
        password: 'StrongPass1!',
        role: BusinessRole.buyer,
        businessName: 'Buyer LLC',
        ruc: '20999111223',
        address: 'Lima',
        phone: '999111222',
        sector: 'Fuel',
        contactEmail: 'buyer@example.test',
      ),
    );

    expect(api.body, {
      'username': 'buyer@example.test',
      'password': 'StrongPass1!',
      'roles': ['ROLE_BUYER'],
      'buyerCompany': {
        'name': 'Buyer LLC',
        'ruc': '20999111223',
        'sector': 'Fuel',
        'address': 'Lima',
        'contactEmail': 'buyer@example.test',
        'phone': '999111222',
      },
      'providerCompany': null,
    });
  });

  test('password recovery calls the matching backend endpoints', () async {
    final api = _RecoveryBackendApi();
    final repository = AuthApiRepository(
      api: api,
      storage: const TokenStorage(FlutterSecureStorage()),
    );

    await repository.requestPasswordReset('buyer@example.test');
    await repository.resetPassword('opaque-token', 'NewPass123!');

    expect(api.email, 'buyer@example.test');
    expect(api.resetBody, {
      'token': 'opaque-token',
      'newPassword': 'NewPass123!',
    });
  });
}

class _BackendApi extends FullTankApi {
  _BackendApi() : super(ApiClient());

  @override
  Future<dynamic> orders({required int companyId}) async {
    expect(companyId, 17);
    return [
      {
        'id': 42,
        'fuelProductId': 8,
        'requestedQuantity': 120,
        'totalPrice': 186,
        'status': 'DISPATCHED',
      },
    ];
  }

  @override
  Future<dynamic> fuelRequests({int? buyerCompanyId, int? providerId}) async =>
      [];

  @override
  Future<dynamic> fuelProducts({int? providerId}) async => [];
}

class _VehicleBackendApi extends FullTankApi {
  _VehicleBackendApi() : super(ApiClient());

  Map<String, dynamic>? body;

  @override
  Future<dynamic> createVehicle(Map<String, dynamic> body) async {
    this.body = body;
    return {'id': 81, ...body};
  }
}

class _DispatchBackendApi extends FullTankApi {
  _DispatchBackendApi() : super(ApiClient());

  Map<String, dynamic>? driverBody;
  Map<String, dynamic>? deliveryBody;

  @override
  Future<dynamic> createDriver(Map<String, dynamic> body) async {
    driverBody = body;
    return {'id': 7, ...body};
  }

  @override
  Future<dynamic> createDelivery(Map<String, dynamic> body) async {
    deliveryBody = body;
    return {'id': 2, ...body};
  }
}

class _AnalyticsBackendApi extends FullTankApi {
  _AnalyticsBackendApi() : super(ApiClient());

  @override
  Future<dynamic> analyticsForBuyer(int companyId) async => {
    'companyId': companyId,
    'totalOrders': 3,
    'totalSpent': 1800,
    'completedPayments': 2,
    'pendingPayments': 1,
    'monthlySpending': [
      {'month': '2026-08', 'amount': 1800},
    ],
  };

  @override
  Future<dynamic> orders({required int companyId}) async => [
    {'requestedQuantity': 100},
    {'requestedQuantity': 160},
  ];
}

class _SignupBackendApi extends FullTankApi {
  _SignupBackendApi() : super(ApiClient());

  Map<String, dynamic>? body;

  @override
  Future<dynamic> signUp(Map<String, dynamic> body) async {
    this.body = body;
    return {'id': 1};
  }
}

class _RecoveryBackendApi extends FullTankApi {
  _RecoveryBackendApi() : super(ApiClient());

  String? email;
  Map<String, dynamic>? resetBody;

  @override
  Future<dynamic> requestPasswordReset(String email) async {
    this.email = email;
  }

  @override
  Future<dynamic> resetPassword(String token, String newPassword) async {
    resetBody = {'token': token, 'newPassword': newPassword};
  }
}

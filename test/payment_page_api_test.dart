import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/features/auth/application/auth_controller.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/gaps/presentation/missing_pages.dart';

void main() {
  testWidgets(
    'registers authenticated payment without invented amount or completion',
    (tester) async {
      final api = _PaymentApi();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fullTankApiProvider.overrideWithValue(api),
            authControllerProvider.overrideWith(
              (ref) => _Buyer(ref.read(authRepositoryProvider)),
            ),
          ],
          child: MaterialApp(
            home: PaymentPage(orderId: '42', api: api),
          ),
        ),
      );
      await tester.tap(find.textContaining(RegExp('Pagar|Registrar pago')));
      await tester.pumpAndSettle();
      expect(api.createdBody, {
        'orderId': 42,
        'companyId': 17,
        'paymentMethod': 'CREDIT_CARD',
      });
      expect(api.completedId, isNull);
      expect(find.text('Pago pendiente'), findsOneWidget);
      expect(find.text('Pago confirmado'), findsNothing);
    },
  );

  testWidgets(
    'payment uses shared authenticated API without an explicit override',
    (tester) async {
      final api = _PaymentApi();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fullTankApiProvider.overrideWithValue(api),
            authControllerProvider.overrideWith(
              (ref) => _Buyer(ref.read(authRepositoryProvider)),
            ),
          ],
          child: const MaterialApp(home: PaymentPage(orderId: '42')),
        ),
      );
      await tester.tap(find.textContaining(RegExp('Pagar|Registrar pago')));
      await tester.pumpAndSettle();
      expect(api.createdBody?['companyId'], 17);
      expect(api.completedId, isNull);
    },
  );
}

class _Buyer extends AuthController {
  _Buyer(super.repository) {
    state = const AuthState(
      status: AuthStatus.authenticated,
      session: AuthSession(
        username: 'buyer',
        token: 'real-token',
        companyId: 17,
      ),
    );
  }
}

class _PaymentApi extends FullTankApi {
  _PaymentApi() : super(ApiClient()..token = 'real-token');
  Map<String, dynamic>? createdBody;
  int? completedId;
  @override
  Future<dynamic> createPayment(Map<String, dynamic> body) async {
    createdBody = body;
    return {'id': 7, 'status': 'PENDING'};
  }

  @override
  Future<dynamic> completePayment(int id, String reference) async {
    completedId = id;
    return {'id': id, 'status': 'COMPLETED'};
  }
}

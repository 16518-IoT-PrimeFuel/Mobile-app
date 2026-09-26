import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/gaps/presentation/missing_pages.dart';

void main() {
  testWidgets('creates and completes a payment through the API', (
    tester,
  ) async {
    final api = _PaymentApi();
    await tester.pumpWidget(
      MaterialApp(
        home: PaymentPage(orderId: '42', api: api),
      ),
    );

    await tester.tap(find.text('Pagar S/ 42,600'));
    await tester.pumpAndSettle();

    expect(find.text('Pago confirmado'), findsOneWidget);
    expect(api.createdBody, {
      'orderId': 42,
      'companyId': 1,
      'amount': 42600,
      'paymentMethod': 'CREDIT_CARD',
    });
    expect(api.completedId, 7);
    expect(api.transactionReference, startsWith('MOBILE-'));
  });
}

class _PaymentApi extends FullTankApi {
  _PaymentApi() : super(ApiClient());

  Map<String, dynamic>? createdBody;
  int? completedId;
  String? transactionReference;

  @override
  Future<dynamic> createPayment(Map<String, dynamic> body) async {
    createdBody = body;
    return {'id': 7};
  }

  @override
  Future<dynamic> completePayment(int id, String reference) async {
    completedId = id;
    transactionReference = reference;
    return {'id': id, 'status': 'COMPLETED'};
  }
}

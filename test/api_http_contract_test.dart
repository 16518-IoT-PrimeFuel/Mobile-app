import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';

void main() {
  test(
    'request detail uses the current authorized replenishment route',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final seen = <String>[];
      server.listen((request) {
        seen.add('${request.method} ${request.uri.path}');
        request.response
          ..write('{"id":77,"quantity":120}')
          ..close();
      });
      try {
        final api = FullTankApi(
          ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api'),
        );
        expect(await api.fuelRequest(77), {'id': 77, 'quantity': 120});
        expect(seen, ['GET /api/replenishment-requests/77']);
      } finally {
        await server.close(force: true);
      }
    },
  );

  test('default API base URL uses the backend namespace', () {
    expect(ApiClient().baseUrl, 'http://10.0.2.2:8080/api');
  });

  test(
    'customer account selection APIs use the current backend routes',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final seen = <String>[];
      server.listen((request) async {
        seen.add('${request.method} ${request.uri.path}');
        request.response
          ..headers.contentType = ContentType.json
          ..write('[]')
          ..close();
      });

      try {
        final api = FullTankApi(
          ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api'),
        );
        await api.customers();
        await api.customerSites(23);
        await api.providerCompanies();
        await api.tanks(17, 5);
        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(seen, [
          'GET /api/customers',
          'GET /api/customers/23/sites',
          'GET /api/provider-companies',
          'GET /api/v2/buyer-companies/17/sites/5/tanks',
        ]);
      } finally {
        await server.close(force: true);
      }
    },
  );

  test(
    'replenishment request uses backend route and organization-scoped fields',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final requestSeen =
          Completer<(String, String, String?, String?, String)>();
      server.listen((request) async {
        final body = await utf8.decoder.bind(request).join();
        requestSeen.complete((
          request.method,
          request.uri.path,
          request.headers.value(HttpHeaders.authorizationHeader),
          request.headers.contentType?.mimeType,
          body,
        ));
        request.response
          ..statusCode = HttpStatus.created
          ..write('{"id":42}')
          ..close();
      });

      try {
        final api = FullTankApi(
          ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api')
            ..token = 'test-jwt',
        );
        final result = await api.createReplenishmentRequest({
          'customerAccountId': 17,
          'tankId': 'tank-4',
          'providerId': 9,
          'fuelProductId': 8,
          'quantity': 120,
          'deliveryAddress': 'Av. Central 100',
          'deliveryDate': '2026-09-12',
          'source': 'APP',
        });
        final request = await requestSeen.future;

        expect(request.$1, 'POST');
        expect(request.$2, '/api/replenishment-requests');
        expect(request.$3, 'Bearer test-jwt');
        expect(request.$4, 'application/json');
        expect(jsonDecode(request.$5), {
          'customerAccountId': 17,
          'tankId': 'tank-4',
          'providerId': 9,
          'fuelProductId': 8,
          'quantity': 120,
          'deliveryAddress': 'Av. Central 100',
          'deliveryDate': '2026-09-12',
          'source': 'APP',
        });
        expect(result, {'id': 42});
      } finally {
        await server.close(force: true);
      }
    },
  );

  test('v2 export requests the CSV attachment route', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final requestSeen = Completer<String>();
    server.listen((request) async {
      requestSeen.complete(request.uri.path);
      request.response
        ..headers.contentType = ContentType('text', 'csv', charset: 'utf-8')
        ..write('id,name\n1,Tank\n')
        ..close();
    });

    try {
      final api = FullTankApi(
        ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api'),
      );
      expect(await api.exportReport(companyId: 17), 'id,name\n1,Tank\n');
      expect(await requestSeen.future, '/api/v2/reports/buyers/17/export');
    } finally {
      await server.close(force: true);
    }
  });

  test(
    'current-user notifications and delivery lifecycle use backend routes',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final seen = <(String, String, String)>[];
      server.listen((request) async {
        final body = await utf8.decoder.bind(request).join();
        seen.add((request.method, request.uri.path, body));
        request.response
          ..statusCode = HttpStatus.noContent
          ..close();
      });

      try {
        final api = FullTankApi(
          ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api'),
        );
        await api.notifications();
        await api.markNotificationRead(6);
        await api.startDelivery(8);
        await api.completeDelivery(8, deliveredVolume: 100);
        await api.failDelivery(9, 'Road closed');
        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(seen, [
          ('GET', '/api/me/notifications', ''),
          ('POST', '/api/me/notifications/6/read', ''),
          ('POST', '/api/deliveries/8/start', ''),
          ('POST', '/api/deliveries/8/complete', '{"deliveredVolume":100.0}'),
          ('POST', '/api/deliveries/9/fail', '{"reason":"Road closed"}'),
        ]);
      } finally {
        await server.close(force: true);
      }
    },
  );

  test(
    'unsupported backend mutations do not issue speculative requests',
    () async {
      final api = FullTankApi(ApiClient(baseUrl: 'http://127.0.0.1:1/api'));
      await expectLater(
        api.createProviderRating({'rating': 5}),
        throwsA(isA<UnsupportedError>()),
      );
      await expectLater(
        api.deliveryForOrder(42),
        throwsA(isA<UnsupportedError>()),
      );
      await expectLater(
        api.createNotification({'message': 'hello'}),
        throwsA(isA<UnsupportedError>()),
      );
    },
  );
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/fulltank_api.dart';

void main() {
  test(
    'mobile request sends backend path, bearer token, and JSON body',
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
          ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api/v1')
            ..token = 'test-jwt',
        );
        final result = await api.createFuelRequest({
          'buyerCompanyId': 17,
          'providerId': 9,
          'fuelProductId': 8,
          'equipmentId': 6,
          'quantity': 120,
          'deliveryAddress': 'Av. Central 100',
          'deliveryDate': '2026-09-12',
          'source': 'MOBILE',
        });
        final request = await requestSeen.future;

        expect(request.$1, 'POST');
        expect(request.$2, '/api/v1/fuel-requests');
        expect(request.$3, 'Bearer test-jwt');
        expect(request.$4, 'application/json');
        expect(jsonDecode(request.$5), {
          'buyerCompanyId': 17,
          'providerId': 9,
          'fuelProductId': 8,
          'equipmentId': 6,
          'quantity': 120,
          'deliveryAddress': 'Av. Central 100',
          'deliveryDate': '2026-09-12',
          'source': 'MOBILE',
        });
        expect(result, {'id': 42});
      } finally {
        await server.close(force: true);
      }
    },
  );
}

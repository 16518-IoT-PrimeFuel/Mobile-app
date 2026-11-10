import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/storage/token_storage.dart';
import 'package:mobile_app/data/api_client.dart';
import 'package:mobile_app/data/auth/auth_api_repository.dart';
import 'package:mobile_app/data/fulltank_api.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  late HttpServer server;
  late ApiClient client;
  late FullTankApi api;
  late TokenStorage storage;
  late AuthApiRepository repository;
  late Future<void> Function(HttpRequest) handler;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    client = ApiClient(baseUrl: 'http://127.0.0.1:${server.port}/api');
    api = FullTankApi(client);
    storage = const TokenStorage(FlutterSecureStorage());
    repository = AuthApiRepository(api: api, storage: storage);
    handler = (request) async {
      request.response.write(
        jsonEncode({
          'id': 44,
          'username': 'buyer',
          'token': 'current',
          'companyId': 17,
          'roles': ['ROLE_BUYER'],
          'memberships': [
            {'organizationId': 17, 'role': 'OWNER'},
          ],
        }),
      );
      await request.response.close();
    };
    server.listen((request) => handler(request));
  });
  tearDown(() async => server.close(force: true));

  test(
    'rememberMe reaches backend and public auth omits existing bearer',
    () async {
      client.token = 'previous';
      String? bearer;
      Object? body;
      handler = (request) async {
        expect(request.uri.path, '/api/authentication/sign-in');
        bearer = request.headers.value(HttpHeaders.authorizationHeader);
        body = jsonDecode(await utf8.decoder.bind(request).join());
        request.response.write('{"token":"temporary"}');
        await request.response.close();
      };
      await repository.signIn('buyer', 'secret', rememberMe: false);
      expect(bearer, isNull);
      expect(body, {
        'username': 'buyer',
        'password': 'secret',
        'rememberMe': false,
      });
      expect(await storage.read(), isNull);
    },
  );

  test(
    'logout calls revocation then clears credentials even on server failure',
    () async {
      await repository.signIn('buyer', 'secret', rememberMe: true);
      var revoked = false;
      handler = (request) async {
        expect(request.uri.path, '/api/authentication/sign-out');
        expect(
          request.headers.value(HttpHeaders.authorizationHeader),
          'Bearer current',
        );
        revoked = true;
        request.response.statusCode = 503;
        await request.response.close();
      };
      await repository.signOut();
      expect(revoked, isTrue);
      expect(client.token, isNull);
      expect(await storage.read(), isNull);
    },
  );

  test(
    'expired persisted JWT is discarded without server revocation',
    () async {
      final payload = base64Url
          .encode(utf8.encode('{"exp":1}'))
          .replaceAll('=', '');
      await storage.save(
        token: 'header.$payload.signature',
        username: 'buyer',
        companyId: 17,
      );
      expect(await repository.restoreSession(), isNull);
      expect(await storage.read(), isNull);
      expect(client.token, isNull);
    },
  );

  test('authenticated 401 clears app session and tenant storage', () async {
    final container = ProviderContainer(
      overrides: [fullTankApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);
    await container
        .read(authControllerProvider.notifier)
        .signIn(username: 'buyer', password: 'secret', rememberMe: true);
    handler = (request) async {
      request.response.statusCode = 401;
      await request.response.close();
    };
    await expectLater(api.notifications(), throwsA(isA<ApiException>()));
    expect(container.read(authControllerProvider).session, isNull);
    expect(client.token, isNull);
    expect(await storage.read(), isNull);
  });

  test('late unauthorized response cannot clear a newer session', () async {
    final container = ProviderContainer(
      overrides: [fullTankApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);
    final controller = container.read(authControllerProvider.notifier);
    await controller.signIn(
      username: 'buyer',
      password: 'secret',
      rememberMe: true,
    );
    final seen = Completer<HttpRequest>();
    handler = (request) async {
      if (request.uri.path.endsWith('/sign-in')) {
        request.response.write(
          '{"id":45,"username":"new","token":"new-token","companyId":18}',
        );
        await request.response.close();
      } else {
        seen.complete(request);
      }
    };
    final pending = api.notifications();
    final assertion = expectLater(pending, throwsA(isA<ApiException>()));
    final oldRequest = await seen.future;
    await controller.signIn(
      username: 'new',
      password: 'secret',
      rememberMe: true,
    );
    oldRequest.response.statusCode = 401;
    await oldRequest.response.close();
    await assertion;
    expect(container.read(authControllerProvider).session?.companyId, 18);
    expect(client.token, 'new-token');
    expect((await storage.read())?.companyId, 18);
  });

  test(
    'late restore cannot overwrite credentials from a newer login',
    () async {
      final delayed = _PausedReadStorage();
      await delayed.save(token: 'old-token', username: 'old', companyId: 1);
      final repo = AuthApiRepository(api: api, storage: delayed);
      final restoring = repo.restoreSession();
      await delayed.started.future;
      await repo.signIn('buyer', 'secret', rememberMe: true);
      delayed.resume.complete();
      expect(await restoring, isNull);
      expect(client.token, 'current');
    },
  );

  test('late logout completion cannot clear a newer local session', () async {
    await repository.signIn('buyer', 'secret', rememberMe: true);
    final seen = Completer<HttpRequest>();
    handler = (request) async {
      if (request.uri.path.endsWith('/sign-out')) {
        seen.complete(request);
      } else {
        request.response.write(
          '{"token":"new-token","username":"new","companyId":18}',
        );
        await request.response.close();
      }
    };
    final signingOut = repository.signOut();
    final oldRequest = await seen.future;
    await repository.signIn('new', 'secret', rememberMe: true);
    oldRequest.response.statusCode = 204;
    await oldRequest.response.close();
    await signingOut;
    expect(client.token, 'new-token');
    expect((await storage.read())?.companyId, 18);
  });
}

class _PausedReadStorage extends TokenStorage {
  _PausedReadStorage() : super(const FlutterSecureStorage());
  final started = Completer<void>();
  final resume = Completer<void>();
  @override
  read() async {
    final saved = await super.read();
    started.complete();
    await resume.future;
    return saved;
  }
}

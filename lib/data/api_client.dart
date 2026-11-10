import 'dart:convert';
import 'dart:io';

class ApiClient {
  ApiClient({String? baseUrl})
    : baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'http://10.0.2.2:8080/api',
          );

  final String baseUrl;
  String? token;
  Future<void> Function(String token)? onUnauthorized;

  Future<dynamic> get(String path) => _request('GET', path, null);
  Future<dynamic> getV2(String path) =>
      _request('GET', path, null, baseUrlOverride: _apiRoot);
  Future<String> getV2Text(String path) =>
      _requestText('GET', path, baseUrlOverride: _apiRoot);
  Future<dynamic> post(String path, [Map<String, dynamic>? body]) =>
      _request('POST', path, body);
  Future<dynamic> postV2(String path, [Map<String, dynamic>? body]) =>
      _request('POST', path, body, baseUrlOverride: _apiRoot);
  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _request('PUT', path, body);
  Future<void> delete(String path) async => _request('DELETE', path, null);

  Future<dynamic> _request(
    String method,
    String path,
    Map<String, dynamic>? body, {
    String? baseUrlOverride,
  }) async {
    final text = await _requestText(
      method,
      path,
      body: body,
      baseUrlOverride: baseUrlOverride,
    );
    return text.isEmpty ? null : jsonDecode(text);
  }

  Future<String> _requestText(
    String method,
    String path, {
    String? baseUrlOverride,
    Map<String, dynamic>? body,
  }) async {
    final sentToken = token;
    final isAuthentication = path.contains('/authentication/');
    final authorize =
        !isAuthentication || path.endsWith('/authentication/sign-out');
    final client = HttpClient();
    try {
      final request = await client.openUrl(
        method,
        Uri.parse('${baseUrlOverride ?? baseUrl}$path'),
      );
      request.headers.contentType = ContentType.json;
      if (sentToken != null && authorize) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $sentToken',
        );
      }
      if (body != null) request.write(jsonEncode(body));
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      if (response.statusCode == 401 &&
          !isAuthentication &&
          sentToken != null &&
          token == sentToken) {
        await onUnauthorized?.call(sentToken);
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(response.statusCode, text);
      }
      return text;
    } finally {
      client.close(force: true);
    }
  }

  String get _apiRoot => baseUrl.replaceFirst(RegExp(r'/api(?:/v1)?/?$'), '');
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'API $statusCode: $body';
}

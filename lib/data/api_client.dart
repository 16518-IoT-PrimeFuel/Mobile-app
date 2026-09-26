import 'dart:convert';
import 'dart:io';

class ApiClient {
  ApiClient({String? baseUrl})
    : baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'http://10.0.2.2:8080/api/v1',
          );

  final String baseUrl;
  String? token;

  Future<dynamic> get(String path) => _request('GET', path, null);
  Future<dynamic> getV2(String path) =>
      _request('GET', path, null, baseUrlOverride: _apiRoot);
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
    final client = HttpClient();
    try {
      final request = await client.openUrl(
        method,
        Uri.parse('${baseUrlOverride ?? baseUrl}$path'),
      );
      request.headers.contentType = ContentType.json;
      if (token != null)
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      if (body != null) request.write(jsonEncode(body));
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      if (response.statusCode < 200 || response.statusCode >= 300)
        throw ApiException(response.statusCode, text);
      return text.isEmpty ? null : jsonDecode(text);
    } finally {
      client.close(force: true);
    }
  }

  String get _apiRoot => baseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');
}

class ApiException implements Exception {
  const ApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'API $statusCode: $body';
}

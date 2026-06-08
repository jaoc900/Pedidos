import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'exceptions/network_exceptions.dart';
import 'api_endpoints.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  // Flag para controlar logs en debug mode
  static const bool _isDebugMode = true; // Cambiar a false en producción

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    _log('Inicializando HttpClient...');
    _log('HttpClient inicializado correctamente');
  }

  void _log(String message, {bool isError = false}) {
    if (_isDebugMode) {
      final timestamp = DateTime.now().toString().substring(11, 23);
      if (isError) {
        print('🔴 [HttpClient][$timestamp] ERROR: $message');
      } else {
        print('🟢 [HttpClient][$timestamp] $message');
      }
    }
  }

  Future<bool> _hasConnection() async {
    _log('Verificando conexión a internet...');
    final hasConnection = await InternetConnectionChecker().hasConnection;
    _log('Estado de conexión: ${hasConnection ? "Conectado" : "Desconectado"}');
    return hasConnection;
  }

  Map<String, String> _getHeaders(Map<String, String>? customHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  Future<dynamic> get(
      String path, {
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    _log('📡 Iniciando petición GET a: $path');
    _log('Query parameters: ${queryParameters ?? "ninguno"}');

    try {
      if (!await _hasConnection()) {
        _log('❌ Sin conexión a internet', isError: true);
        throw NetworkExceptions.connectionError();
      }

      // Construir URL con query parameters
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: queryParameters);
        _log('URL completa con query params: $uri');
      } else {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
        _log('URL completa: $uri');
      }

      _log('⏳ Enviando petición GET...');
      _log('Headers: ${_getHeaders(headers)}');

      final response = await http.get(
        uri,
        headers: _getHeaders(headers),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⏰ Timeout en petición GET', isError: true);
          throw NetworkExceptions.timeoutError();
        },
      );

      _log('✅ Petición GET exitosa a: $path');
      _log('Status code: ${response.statusCode}');
      _log('Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      _log('❌ Error en petición GET a: $path', isError: true);
      _log('Error: ${e.toString()}', isError: true);
      rethrow;
    }
  }

  Future<dynamic> post(
      String path, {
        dynamic data,
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    _log('📡 Iniciando petición POST a: $path');
    _log('Datos a enviar: $data');
    _log('Query parameters: ${queryParameters ?? "ninguno"}');

    try {
      if (!await _hasConnection()) {
        _log('❌ Sin conexión a internet', isError: true);
        throw NetworkExceptions.connectionError();
      }

      // Construir URL con query parameters
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: queryParameters);
        _log('URL completa con query params: $uri');
      } else {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
        _log('URL completa: $uri');
      }

      final body = data != null ? json.encode(data) : null;
      _log('Body encodeado: $body');
      _log('Headers: ${_getHeaders(headers)}');

      _log('⏳ Enviando petición POST...');
      final response = await http.post(
        uri,
        headers: _getHeaders(headers),
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⏰ Timeout en petición POST', isError: true);
          throw NetworkExceptions.timeoutError();
        },
      );

      _log('✅ Petición POST exitosa a: $path');
      _log('Status code: ${response.statusCode}');
      _log('Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      _log('❌ Error en petición POST a: $path', isError: true);
      _log('Error: ${e.toString()}', isError: true);
      rethrow;
    }
  }

  Future<dynamic> put(
      String path, {
        dynamic data,
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    _log('📡 Iniciando petición PUT a: $path');
    _log('Datos a enviar: $data');
    _log('Query parameters: ${queryParameters ?? "ninguno"}');

    try {
      if (!await _hasConnection()) {
        _log('❌ Sin conexión a internet', isError: true);
        throw NetworkExceptions.connectionError();
      }

      // Construir URL con query parameters
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: queryParameters);
        _log('URL completa con query params: $uri');
      } else {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
        _log('URL completa: $uri');
      }

      final body = data != null ? json.encode(data) : null;
      _log('Body encodeado: $body');
      _log('Headers: ${_getHeaders(headers)}');

      _log('⏳ Enviando petición PUT...');
      final response = await http.put(
        uri,
        headers: _getHeaders(headers),
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⏰ Timeout en petición PUT', isError: true);
          throw NetworkExceptions.timeoutError();
        },
      );

      _log('✅ Petición PUT exitosa a: $path');
      _log('Status code: ${response.statusCode}');
      _log('Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      _log('❌ Error en petición PUT a: $path', isError: true);
      _log('Error: ${e.toString()}', isError: true);
      rethrow;
    }
  }

  Future<dynamic> delete(
      String path, {
        dynamic data,
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    _log('📡 Iniciando petición DELETE a: $path');
    _log('Query parameters: ${queryParameters ?? "ninguno"}');

    try {
      if (!await _hasConnection()) {
        _log('❌ Sin conexión a internet', isError: true);
        throw NetworkExceptions.connectionError();
      }

      // Construir URL con query parameters
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: queryParameters);
        _log('URL completa con query params: $uri');
      } else {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
        _log('URL completa: $uri');
      }

      _log('Headers: ${_getHeaders(headers)}');

      _log('⏳ Enviando petición DELETE...');
      final response = await http.delete(
        uri,
        headers: _getHeaders(headers),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⏰ Timeout en petición DELETE', isError: true);
          throw NetworkExceptions.timeoutError();
        },
      );

      _log('✅ Petición DELETE exitosa a: $path');
      _log('Status code: ${response.statusCode}');
      _log('Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      _log('❌ Error en petición DELETE a: $path', isError: true);
      _log('Error: ${e.toString()}', isError: true);
      rethrow;
    }
  }

  Future<dynamic> patch(
      String path, {
        dynamic data,
        Map<String, String>? headers,
        Map<String, dynamic>? queryParameters,
      }) async {
    _log('📡 Iniciando petición PATCH a: $path');
    _log('Datos a enviar: $data');
    _log('Query parameters: ${queryParameters ?? "ninguno"}');

    try {
      if (!await _hasConnection()) {
        _log('❌ Sin conexión a internet', isError: true);
        throw NetworkExceptions.connectionError();
      }

      // Construir URL con query parameters
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path').replace(queryParameters: queryParameters);
        _log('URL completa con query params: $uri');
      } else {
        uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
        _log('URL completa: $uri');
      }

      final body = data != null ? json.encode(data) : null;
      _log('Body encodeado: $body');
      _log('Headers: ${_getHeaders(headers)}');

      _log('⏳ Enviando petición PATCH...');
      final response = await http.patch(
        uri,
        headers: _getHeaders(headers),
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⏰ Timeout en petición PATCH', isError: true);
          throw NetworkExceptions.timeoutError();
        },
      );

      _log('✅ Petición PATCH exitosa a: $path');
      _log('Status code: ${response.statusCode}');
      _log('Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      _log('❌ Error en petición PATCH a: $path', isError: true);
      _log('Error: ${e.toString()}', isError: true);
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    _log('🔍 Procesando respuesta...');
    _log('Status code: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _log('✅ Respuesta exitosa');
      if (response.body.isNotEmpty) {
        try {
          final decoded = json.decode(response.body);
          _log('Respuesta decodificada: $decoded');
          return decoded;
        } catch (e) {
          _log('⚠️ Respuesta no es JSON válido: ${response.body}');
          return response.body;
        }
      }
      return null;
    } else {
      _log('❌ Error en respuesta: ${response.statusCode}', isError: true);
      _log('Body del error: ${response.body}', isError: true);
      throw NetworkExceptions.fromResponse(
        response.statusCode,
        response.body,
      );
    }
  }
}
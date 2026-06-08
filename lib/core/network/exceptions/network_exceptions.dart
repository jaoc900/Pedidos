import 'dart:convert';

class NetworkExceptions implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  NetworkExceptions({
    required this.message,
    this.statusCode,
    this.data,
  });

  static NetworkExceptions fromResponse(int statusCode, dynamic response) {
    String message = 'Ha ocurrido un error inesperado';

    if (response != null && response is String) {
      try {
        final decoded = json.decode(response);
        message = decoded['message'] ?? decoded['error'] ?? message;
      } catch (e) {
        message = response;
      }
    } else if (response is Map) {
      message = response['message'] ?? response['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        message = 'Solicitud incorrecta. $message';
        break;
      case 401:
        message = 'No autorizado. Por favor, inicia sesión nuevamente.';
        break;
      case 403:
        message = 'Acceso prohibido. No tienes permisos suficientes.';
        break;
      case 404:
        message = 'Recurso no encontrado.';
        break;
      case 500:
        message = 'Error interno del servidor. Intenta más tarde.';
        break;
    }

    return NetworkExceptions(
      message: message,
      statusCode: statusCode,
      data: response,
    );
  }

  static NetworkExceptions connectionError() {
    return NetworkExceptions(
      message: 'Error de conexión. Verifica tu conexión a internet.',
    );
  }

  static NetworkExceptions timeoutError() {
    return NetworkExceptions(
      message: 'Tiempo de espera agotado. El servidor no responde.',
    );
  }

  @override
  String toString() => message;
}
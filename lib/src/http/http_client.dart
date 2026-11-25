import 'package:dio/dio.dart';

/// Configuração do Dio para comunicação com sistemas externos (ViaCEP).
class HttpClient {
  HttpClient._();

  static const String viaCepBaseUrl = 'https://viacep.com.br/ws';

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: viaCepBaseUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        headers: const {'Accept': 'application/json'},
      ),
    );
  }
}

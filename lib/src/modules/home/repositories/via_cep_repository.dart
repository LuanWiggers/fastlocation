import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../http/app_exception.dart';
import '../model/address_model.dart';

/// Comunicação com a API pública ViaCEP.
class ViaCepRepository {
  ViaCepRepository(this._dio);

  final Dio _dio;

  /// Consulta endereço por CEP (8 dígitos). Retorna null se não encontrado.
  Future<AddressModel?> getByCep(String cep) async {
    try {
      final response = await _dio.get<dynamic>('/$cep/json/');
      final data = _decode(response.data);
      if (data is! Map) return null;
      if (data['erro'] == true || data['erro'] == 'true') return null;
      return AddressModel.fromJson(Map<String, dynamic>.from(data));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) return null; // CEP em formato inválido
      throw _toAppException(e);
    }
  }

  /// Busca CEPs por endereço completo ou parcial (UF, cidade e logradouro).
  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final path = '/${Uri.encodeComponent(uf)}'
        '/${Uri.encodeComponent(city)}'
        '/${Uri.encodeComponent(street)}/json/';
    try {
      final response = await _dio.get<dynamic>(path);
      final data = _decode(response.data);
      if (data is! List) return [];
      return data
          .whereType<Map>()
          .map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) return [];
      throw _toAppException(e);
    }
  }

  dynamic _decode(dynamic data) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return null;
      }
    }
    return data;
  }

  AppException _toAppException(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return const AppException(
            'O serviço demorou para responder. Tente novamente.');
      default:
        return const AppException(
            'Sem conexão com a internet ou serviço indisponível.');
    }
  }
}

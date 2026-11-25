import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_launcher/map_launcher.dart';

import '../../../http/app_exception.dart';
import '../model/address_model.dart';
import '../repositories/local_address_repository.dart';
import '../repositories/via_cep_repository.dart';

/// Regras de negócio do módulo Home.
class HomeService {
  HomeService(this._api, this._local);

  final ViaCepRepository _api;
  final LocalAddressRepository _local;

  /// Consulta por CEP. Se estiver sem internet, tenta o armazenamento local.
  Future<AddressModel?> consultCep(String cep) async {
    final digits = cep.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) {
      throw const AppException('Informe um CEP com 8 dígitos.');
    }

    try {
      final remote = await _api.getByCep(digits);
      if (remote == null) return null;
      return await _local.save(remote);
    } on AppException {
      final cached = await _local.findByCep(digits);
      if (cached != null) return _local.save(cached);
      rethrow;
    }
  }

  /// Busca CEPs por endereço completo ou parcial.
  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final cleanUf = uf.trim();
    final cleanCity = city.trim();
    final cleanStreet = street.trim();

    if (cleanUf.length != 2) {
      throw const AppException('Informe a UF com 2 letras (ex.: SC).');
    }
    if (cleanCity.length < 3) {
      throw const AppException('Informe a cidade (mínimo 3 letras).');
    }
    if (cleanStreet.length < 3) {
      throw const AppException('Informe o logradouro (mínimo 3 letras).');
    }

    return _api.searchByAddress(
      uf: cleanUf,
      city: cleanCity,
      street: cleanStreet,
    );
  }

  Future<AddressModel> saveAddress(AddressModel address) =>
      _local.save(address);

  Future<AddressModel?> getLastAddress() => _local.getLast();

  /// Abre o app de mapas traçando a rota da localização atual até o endereço.
  Future<void> openRoute(AddressModel address) async {
    final coords = await _findCoords(address);
    if (coords == null) {
      throw const AppException(
          'Não foi possível localizar este endereço no mapa.');
    }

    final maps = await MapLauncher.installedMaps;
    if (maps.isEmpty) {
      throw const AppException('Nenhum aplicativo de mapas instalado.');
    }

    final map = maps.firstWhere(
      (m) => m.mapType == MapType.google,
      orElse: () => maps.first,
    );

    // Sem "origin", o app de mapas usa a localização atual do dispositivo.
    await map.showDirections(
      destination: Coords(coords[0], coords[1]),
      destinationTitle: address.title,
    );
  }

  /// Retorna [latitude, longitude] ou null se não achar.
  Future<List<double>?> _findCoords(AddressModel address) async {
    try {
      await geo.setLocaleIdentifier('pt_BR');
    } catch (_) {}

    final queries = <String>[
      if (address.logradouro.isNotEmpty)
        '${address.logradouro}, ${address.bairro}, '
            '${address.localidade} - ${address.uf}, Brasil',
      '${address.formattedCep}, ${address.localidade} - ${address.uf}, Brasil',
      '${address.localidade} - ${address.uf}, Brasil',
    ];

    for (final query in queries) {
      try {
        final result = await geo.locationFromAddress(query);
        if (result.isNotEmpty) {
          return [result.first.latitude, result.first.longitude];
        }
      } catch (_) {
        // tenta a próxima consulta
      }
    }
    return null;
  }
}

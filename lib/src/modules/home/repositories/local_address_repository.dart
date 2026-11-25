import 'package:hive/hive.dart';

import '../model/address_model.dart';

/// Comunicação com o armazenamento local (Hive).
class LocalAddressRepository {
  LocalAddressRepository(this._box);

  final Box<AddressModel> _box;

  String _key(AddressModel address) =>
      address.cepDigits.isNotEmpty ? address.cepDigits : address.toString();

  /// Salva (ou atualiza) o endereço consultado com a data/hora atual.
  Future<AddressModel> save(AddressModel address) async {
    final saved = address.copyWith(consultedAt: DateTime.now());
    await _box.put(_key(saved), saved);
    return saved;
  }

  Future<AddressModel?> findByCep(String cepDigits) async =>
      _box.get(cepDigits);

  /// Histórico ordenado do mais recente para o mais antigo.
  Future<List<AddressModel>> getAll() async {
    final list = _box.values.toList()
      ..sort((a, b) => b.consultedAt.compareTo(a.consultedAt));
    return list;
  }

  Future<AddressModel?> getLast() async {
    final all = await getAll();
    return all.isEmpty ? null : all.first;
  }
}

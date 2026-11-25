import 'package:hive/hive.dart';

part 'address_model.g.dart';

/// Endereço retornado pela API ViaCEP (https://viacep.com.br/ws).
@HiveType(typeId: 0)
class AddressModel {
  const AddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ddd,
    required this.consultedAt,
  });

  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String logradouro;

  @HiveField(2)
  final String complemento;

  @HiveField(3)
  final String bairro;

  @HiveField(4)
  final String localidade;

  @HiveField(5)
  final String uf;

  @HiveField(6)
  final String ddd;

  @HiveField(7)
  final DateTime consultedAt;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    String read(String key) => (json[key]?.toString() ?? '').trim();

    return AddressModel(
      cep: read('cep'),
      logradouro: read('logradouro'),
      complemento: read('complemento'),
      bairro: read('bairro'),
      localidade: read('localidade'),
      uf: read('uf'),
      ddd: read('ddd'),
      consultedAt: DateTime.now(),
    );
  }

  AddressModel copyWith({DateTime? consultedAt}) {
    return AddressModel(
      cep: cep,
      logradouro: logradouro,
      complemento: complemento,
      bairro: bairro,
      localidade: localidade,
      uf: uf,
      ddd: ddd,
      consultedAt: consultedAt ?? this.consultedAt,
    );
  }

  String get cepDigits => cep.replaceAll(RegExp(r'\D'), '');

  String get formattedCep {
    final digits = cepDigits;
    if (digits.length != 8) return cep;
    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }

  /// Título para listas: rua ou, na falta dela, a cidade.
  String get title => logradouro.isNotEmpty ? logradouro : localidade;

  String get subtitle {
    final parts = <String>[
      if (bairro.isNotEmpty) bairro,
      if (localidade.isNotEmpty) '$localidade/$uf',
    ];
    return parts.join(' • ');
  }

  @override
  String toString() => '$title - $subtitle (CEP $formattedCep)';
}

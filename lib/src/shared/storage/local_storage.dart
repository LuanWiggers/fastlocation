import 'package:hive_flutter/hive_flutter.dart';

import '../../modules/home/model/address_model.dart';

/// Configuração do armazenamento local (Hive).
class LocalStorage {
  LocalStorage._();

  static const String addressBoxName = 'addresses';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(AddressModelAdapter().typeId)) {
      Hive.registerAdapter(AddressModelAdapter());
    }
    await Hive.openBox<AddressModel>(addressBoxName);
  }

  static Box<AddressModel> get addressBox =>
      Hive.box<AddressModel>(addressBoxName);
}

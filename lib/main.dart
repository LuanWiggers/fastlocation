import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/shared/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const FastLocationApp());
}

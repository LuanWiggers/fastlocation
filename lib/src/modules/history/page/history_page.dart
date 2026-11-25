import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/components/app_loading.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../../shared/storage/local_storage.dart';
import '../../home/components/address_list_component.dart';
import '../../home/components/empty_search_component.dart';
import '../../home/repositories/local_address_repository.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController(
      LocalAddressRepository(LocalStorage.addressBox),
    );
    // Carregamento automático dos dados ao acessar a página
    _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de consultas')),
      body: Observer(
        builder: (_) {
          if (_controller.isLoading) {
            return const AppLoading(message: 'Carregando histórico...');
          }

          if (_controller.addresses.isEmpty) {
            return const EmptySearchComponent(
              title: 'Nenhuma consulta realizada',
              message: 'Os endereços que você consultar aparecerão aqui.',
              icon: Icons.history,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppMetrics.md),
            child: AddressListComponent(
              addresses: _controller.addresses.toList(),
              showDate: true,
              scrollable: true,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../http/http_client.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/app_loading.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../../shared/storage/local_storage.dart';
import '../components/address_list_component.dart';
import '../components/empty_search_component.dart';
import '../components/last_address_component.dart';
import '../components/search_form_component.dart';
import '../controller/home_controller.dart';
import '../repositories/local_address_repository.dart';
import '../repositories/via_cep_repository.dart';
import '../service/home_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  late final ReactionDisposer _errorReaction;

  final _cepController = TextEditingController();
  final _ufController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  SearchMode _mode = SearchMode.cep;

  @override
  void initState() {
    super.initState();

    _controller = HomeController(
      HomeService(
        ViaCepRepository(HttpClient.create()),
        LocalAddressRepository(LocalStorage.addressBox),
      ),
    );

    _controller.loadLastAddress();

    // Reação do MobX: mostra um aviso sempre que ocorrer erro numa consulta.
    _errorReaction = reaction<String?>(
      (_) => _controller.errorMessage,
      (message) {
        if (message == null || !mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
      },
    );
  }

  @override
  void dispose() {
    _errorReaction();
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    if (_mode == SearchMode.cep) {
      _controller.searchByCep(_cepController.text);
    } else {
      _controller.searchByAddress(
        _ufController.text,
        _cityController.text,
        _streetController.text,
      );
    }
  }

  void _newQuery() {
    _cepController.clear();
    _ufController.clear();
    _cityController.clear();
    _streetController.clear();
    _controller.newQuery();
  }

  void _openHistory() {
    Navigator.of(context).pushNamed(AppRoutes.history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            tooltip: 'Histórico de consultas',
            icon: const Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppMetrics.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Observer(
                    builder: (_) => SearchFormComponent(
                      mode: _mode,
                      onModeChanged: (mode) => setState(() => _mode = mode),
                      cepController: _cepController,
                      ufController: _ufController,
                      cityController: _cityController,
                      streetController: _streetController,
                      onSearch: _search,
                      isLoading: _controller.isLoading,
                    ),
                  ),
                  const SizedBox(height: AppMetrics.lg),
                  Observer(builder: (_) => _buildResult()),
                  const SizedBox(height: AppMetrics.sm),
                  TextButton.icon(
                    onPressed: _openHistory,
                    icon: const Icon(Icons.history),
                    label: const Text('Ver histórico de consultas'),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) =>
                _controller.isLoading ? const AppLoading() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_controller.notFound) {
      return const EmptySearchComponent();
    }

    if (_controller.results.isNotEmpty) {
      return AddressListComponent(
        title: 'Selecione um endereço',
        addresses: _controller.results.toList(),
        onTap: _controller.selectAddress,
      );
    }

    final last = _controller.lastAddress;
    if (last != null) {
      return LastAddressComponent(
        address: last,
        onRoute: _controller.traceRoute,
        onNewQuery: _newQuery,
      );
    }

    return const Padding(
      padding: EdgeInsets.all(AppMetrics.md),
      child: Text(
        'Informe um CEP ou busque pelo endereço para começar.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

import 'package:mobx/mobx.dart';

import '../../../http/app_exception.dart';
import '../model/address_model.dart';
import '../service/home_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase(this._service);

  final HomeService _service;

  @observable
  bool isLoading = false;

  /// Consulta realizada, mas sem nenhum resultado.
  @observable
  bool notFound = false;

  @observable
  String? errorMessage;

  /// Último endereço consultado.
  @observable
  AddressModel? lastAddress;

  /// Resultados da busca por endereço (o usuário escolhe um deles).
  final ObservableList<AddressModel> results = ObservableList<AddressModel>();

  @action
  Future<void> loadLastAddress() async {
    final last = await _service.getLastAddress();
    lastAddress = last;
  }

  @action
  Future<void> searchByCep(String cep) async {
    isLoading = true;
    errorMessage = null;
    notFound = false;
    results.clear();
    try {
      final address = await _service.consultCep(cep);
      if (address == null) {
        notFound = true;
      } else {
        lastAddress = address;
      }
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Não foi possível concluir a consulta. Tente novamente.';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> searchByAddress(String uf, String city, String street) async {
    isLoading = true;
    errorMessage = null;
    notFound = false;
    results.clear();
    try {
      final found = await _service.searchByAddress(
        uf: uf,
        city: city,
        street: street,
      );
      if (found.isEmpty) {
        notFound = true;
      } else {
        results.addAll(found);
      }
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Não foi possível concluir a busca. Tente novamente.';
    } finally {
      isLoading = false;
    }
  }

  /// Escolhe um dos resultados da busca por endereço.
  @action
  Future<void> selectAddress(AddressModel address) async {
    try {
      final saved = await _service.saveAddress(address);
      lastAddress = saved;
      results.clear();
      notFound = false;
    } catch (_) {
      errorMessage = 'Não foi possível salvar o endereço escolhido.';
    }
  }

  /// Traça a rota da localização atual até o último endereço consultado.
  @action
  Future<void> traceRoute() async {
    final address = lastAddress;
    if (address == null) return;

    isLoading = true;
    errorMessage = null;
    try {
      await _service.openRoute(address);
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Não foi possível abrir o aplicativo de mapas.';
    } finally {
      isLoading = false;
    }
  }

  /// Limpa a tela para uma nova consulta.
  @action
  void newQuery() {
    results.clear();
    notFound = false;
    errorMessage = null;
    lastAddress = null;
  }
}

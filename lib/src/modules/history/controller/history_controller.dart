import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/repositories/local_address_repository.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  _HistoryControllerBase(this._repository);

  final LocalAddressRepository _repository;

  @observable
  bool isLoading = false;

  /// Endereços consultados, do mais recente para o mais antigo.
  final ObservableList<AddressModel> addresses = ObservableList<AddressModel>();

  @action
  Future<void> load() async {
    isLoading = true;
    try {
      final all = await _repository.getAll();
      addresses
        ..clear()
        ..addAll(all);
    } finally {
      isLoading = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/components/app_text_field.dart';
import '../../../shared/metrics/app_metrics.dart';

enum SearchMode { cep, address }

/// Campos de consulta: por CEP ou por endereço (UF, cidade e logradouro).
class SearchFormComponent extends StatelessWidget {
  const SearchFormComponent({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.cepController,
    required this.ufController,
    required this.cityController,
    required this.streetController,
    required this.onSearch,
    this.isLoading = false,
  });

  final SearchMode mode;
  final ValueChanged<SearchMode> onModeChanged;
  final TextEditingController cepController;
  final TextEditingController ufController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final VoidCallback onSearch;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isCep = mode == SearchMode.cep;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppMetrics.xs,
          children: [
            ChoiceChip(
              label: const Text('Buscar por CEP'),
              selected: isCep,
              onSelected: (_) => onModeChanged(SearchMode.cep),
            ),
            ChoiceChip(
              label: const Text('Buscar por endereço'),
              selected: !isCep,
              onSelected: (_) => onModeChanged(SearchMode.address),
            ),
          ],
        ),
        const SizedBox(height: AppMetrics.md),
        if (isCep)
          AppTextField(
            controller: cepController,
            label: 'CEP',
            hint: 'Somente números (8 dígitos)',
            icon: Icons.pin_drop,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
          )
        else ...[
          AppTextField(
            controller: ufController,
            label: 'UF',
            hint: 'Ex.: SC',
            icon: Icons.map,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              LengthLimitingTextInputFormatter(2),
            ],
          ),
          const SizedBox(height: AppMetrics.sm),
          AppTextField(
            controller: cityController,
            label: 'Cidade',
            hint: 'Ex.: Joinville',
            icon: Icons.location_city,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppMetrics.sm),
          AppTextField(
            controller: streetController,
            label: 'Logradouro (completo ou parcial)',
            hint: 'Ex.: Rua XV de Novembro',
            icon: Icons.signpost,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
          ),
        ],
        const SizedBox(height: AppMetrics.md),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onSearch,
          icon: const Icon(Icons.search),
          label: Text(isCep ? 'Consultar CEP' : 'Buscar CEP'),
        ),
      ],
    );
  }
}

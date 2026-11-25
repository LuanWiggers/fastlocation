import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

/// Mostra o último endereço consultado, com ações de rota e nova consulta.
class LastAddressComponent extends StatelessWidget {
  const LastAddressComponent({
    super.key,
    required this.address,
    required this.onRoute,
    required this.onNewQuery,
  });

  final AddressModel address;
  final VoidCallback onRoute;
  final VoidCallback onNewQuery;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Último endereço consultado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppMetrics.sm),
            Text(
              address.formattedCep,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppMetrics.sm),
            _InfoRow(label: 'Logradouro', value: address.logradouro),
            _InfoRow(label: 'Complemento', value: address.complemento),
            _InfoRow(label: 'Bairro', value: address.bairro),
            _InfoRow(label: 'Cidade/UF', value: '${address.localidade}/${address.uf}'),
            _InfoRow(label: 'DDD', value: address.ddd),
            const SizedBox(height: AppMetrics.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRoute,
                    icon: const Icon(Icons.directions),
                    label: const Text('Traçar rota'),
                  ),
                ),
                const SizedBox(width: AppMetrics.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onNewQuery,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nova consulta'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

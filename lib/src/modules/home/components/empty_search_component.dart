import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';

/// Exibido quando a busca não retorna nenhum endereço.
class EmptySearchComponent extends StatelessWidget {
  const EmptySearchComponent({
    super.key,
    this.title = 'Nenhum endereço encontrado',
    this.message = 'Confira o CEP ou os dados do endereço e tente novamente.',
    this.icon = Icons.search_off,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.textSecondary),
            const SizedBox(height: AppMetrics.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppMetrics.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

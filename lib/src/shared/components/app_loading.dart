import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

/// Tela de loading (sobreposta) exibida durante consultas externas.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message = 'Aguarde...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AbsorbPointer(
        child: ColoredBox(
          color: AppColors.scrim,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppMetrics.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppMetrics.md),
                    Text(message),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

/// Lista de endereços (resultados da busca ou histórico de consultas).
class AddressListComponent extends StatelessWidget {
  const AddressListComponent({
    super.key,
    required this.addresses,
    this.title,
    this.onTap,
    this.showDate = false,
    this.scrollable = false,
  });

  final List<AddressModel> addresses;
  final String? title;
  final ValueChanged<AddressModel>? onTap;
  final bool showDate;

  /// true: a lista rola sozinha (ex.: página de histórico).
  /// false: a lista se adapta ao conteúdo (ex.: dentro de outro scroll).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      shrinkWrap: !scrollable,
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final address = addresses[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.location_on, color: Colors.white),
          ),
          title: Text(address.title),
          subtitle: Text(_subtitle(address)),
          trailing: onTap == null ? null : const Icon(Icons.chevron_right),
          onTap: onTap == null ? null : () => onTap!(address),
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppMetrics.xs),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        if (scrollable)
          Expanded(child: Card(child: list))
        else
          Card(child: list),
      ],
    );
  }

  String _subtitle(AddressModel address) {
    final lines = <String>[
      if (address.subtitle.isNotEmpty) address.subtitle,
      'CEP ${address.formattedCep}',
      if (showDate) _formatDate(address.consultedAt),
    ];
    return lines.join('\n');
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return 'Consultado em ${two(d.day)}/${two(d.month)}/${d.year} '
        'às ${two(d.hour)}:${two(d.minute)}';
  }
}

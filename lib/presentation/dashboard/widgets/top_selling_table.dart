import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Adaptive Top Selling items presentation: DataTable on desktop, ListTile on mobile.
class TopSellingTable extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const TopSellingTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.topSellingProductsAndServices,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            isDesktop ? _buildDesktopTable(l10n) : _buildMobileList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.sku)),
          DataColumn(label: Text(l10n.productName)),
          DataColumn(label: Text(l10n.category)),
          DataColumn(
            label: Text(l10n.tableHeaderUnitsSold),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderRevenue),
            numeric: true,
          ),
        ],
        rows: items.map((item) {
          final total = ((item['total'] ?? item['revenue'] ?? 0.0) as num)
              .toDouble();
          return DataRow(
            cells: [
              DataCell(Text(item['sku'] as String)),
              DataCell(Text(item['name'] as String)),
              DataCell(Text(item['category'] as String)),
              DataCell(Text('${item['units']}')),
              DataCell(Text('\$${total.toStringAsFixed(2)}')),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: items.map((item) {
        final total = ((item['total'] ?? item['revenue'] ?? 0.0) as num)
            .toDouble();
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            item['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${item['category']} • ${item['units']}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Chip(
            label: Text('\$${total.toStringAsFixed(2)}'),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        );
      }).toList(),
    );
  }
}

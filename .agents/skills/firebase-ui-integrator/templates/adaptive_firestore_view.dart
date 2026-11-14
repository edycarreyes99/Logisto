import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

/// Item representation for demonstration in adaptive catalogs.
class DemoCatalogItem {
  final String id;
  final String name;
  final String category;
  final String status;
  final double metricValue;

  const DemoCatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.metricValue,
  });
}

/// Adaptive presentation view consuming [FirestoreQueryBuilder] headlessly.
/// Renders a Material 3 [DataTable] on desktop/laptop displays (>=992px), a 2-column [Card]
/// grid on tablets (768px-991px), and a touch-friendly [ListTile] list on mobile
/// phones (<768px), adhering to RULE-UI-007 and RULE-UI-006.
class AdaptiveFirestoreView extends StatelessWidget {
  final Query<DemoCatalogItem> query;
  final ValueChanged<DemoCatalogItem> onItemTap;

  const AdaptiveFirestoreView({
    super.key,
    required this.query,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<DemoCatalogItem>(
      query: query,
      pageSize: 25,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching && snapshot.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Data query failed: ${snapshot.error}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No records available',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            if (width >= BsBreakpoints.lg) {
              return _buildDesktopTable(context, snapshot);
            }

            if (width >= BsBreakpoints.md) {
              return _buildTabletGrid(context, snapshot);
            }

            return _buildMobileList(context, snapshot);
          },
        );
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<DemoCatalogItem> snapshot,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Catalog', style: theme.textTheme.titleMedium),
                Chip(label: Text('${snapshot.docs.length} items loaded')),
              ],
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: snapshot.docs.map((doc) {
                final item = doc.data();
                return DataRow(
                  cells: [
                    DataCell(Text(item.id)),
                    DataCell(Text(item.name)),
                    DataCell(Text(item.category)),
                    DataCell(Chip(label: Text(item.status))),
                    DataCell(
                      FilledButton.tonal(
                        onPressed: () => onItemTap(item),
                        child: const Text('View'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletGrid(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<DemoCatalogItem> snapshot,
  ) {
    final theme = Theme.of(context);

    return BsRow(
      children: snapshot.docs.map((doc) {
        final item = doc.data();
        return BsCol(
          config: const BsColConfig(xs: 12, md: 6),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Chip(label: Text(item.status)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${item.category}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: () => onItemTap(item),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    FirestoreQueryBuilderSnapshot<DemoCatalogItem> snapshot,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final item = snapshot.docs[index].data();
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.category),
            trailing: Chip(label: Text(item.status)),
            onTap: () => onItemTap(item),
          ),
        );
      },
    );
  }
}

import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'generic_feature_grid_item.dart';
import 'generic_item_model.dart';

/// Decomposed 12-column responsive grid layout for feature items.
class GenericFeatureGrid extends StatelessWidget {
  /// The collection of generic items to render.
  final List<GenericItemModel> items;

  /// Callback executed when an item deletion is requested.
  final ValueChanged<GenericItemModel> onDeleteItem;

  /// Localized delete button tooltip.
  final String deleteTooltip;

  /// Creates an immutable [GenericFeatureGrid] instance.
  const GenericFeatureGrid({
    super.key,
    required this.items,
    required this.onDeleteItem,
    required this.deleteTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: [
        for (final item in items)
          BsCol(
            sizes: const ColSize(xs: 12, sm: 6, md: 4, lg: 3),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GenericFeatureGridItem(
                item: item,
                onDelete: () => onDeleteItem(item),
                deleteTooltip: deleteTooltip,
              ),
            ),
          ),
      ],
    );
  }
}

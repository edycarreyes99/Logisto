import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';

/// Decomposed header widget containing responsive search and create actions.
class GenericFeatureHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreatePressed;
  final String searchPlaceholder;
  final String createButtonText;

  const GenericFeatureHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onCreatePressed,
    required this.searchPlaceholder,
    required this.createButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: [
        BsCol(
          sizes: const ColSize(xs: 12, md: 8, lg: 9),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchPlaceholder,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        BsCol(
          sizes: const ColSize(xs: 12, md: 4, lg: 3),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: onCreatePressed,
              icon: const Icon(Icons.add),
              label: Text(createButtonText),
            ),
          ),
        ),
      ],
    );
  }
}

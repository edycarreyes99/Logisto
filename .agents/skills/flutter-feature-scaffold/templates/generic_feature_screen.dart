import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'generic_feature_grid.dart';
import 'generic_feature_header.dart';
import 'generic_feature_provider.dart';

/// Primary feature screen assembling decomposed sub-widgets within a responsive Bootstrap container.
class GenericFeatureScreen extends StatefulWidget {
  final GenericFeatureProvider provider;
  final VoidCallback onCreatePressed;
  final String searchPlaceholder;
  final String createButtonText;
  final String emptyMessage;
  final String deleteTooltip;

  const GenericFeatureScreen({
    super.key,
    required this.provider,
    required this.onCreatePressed,
    required this.searchPlaceholder,
    required this.createButtonText,
    required this.emptyMessage,
    required this.deleteTooltip,
  });

  @override
  State<GenericFeatureScreen> createState() => _GenericFeatureScreenState();
}

class _GenericFeatureScreenState extends State<GenericFeatureScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BsContainer(
            fluid: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GenericFeatureHeader(
                  searchController: _searchController,
                  onSearchChanged: widget.provider.updateSearchQuery,
                  onCreatePressed: widget.onCreatePressed,
                  searchPlaceholder: widget.searchPlaceholder,
                  createButtonText: widget.createButtonText,
                ),
                const SizedBox(height: 24.0),
                AnimatedBuilder(
                  animation: widget.provider,
                  builder: (context, _) => _buildContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final status = widget.provider.status;
    if (status.isLoading && widget.provider.items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (status.isError && widget.provider.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Error loading items',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
    final items = widget.provider.filteredItems;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(widget.emptyMessage),
        ),
      );
    }
    return GenericFeatureGrid(
      items: items,
      onDeleteItem: (item) => widget.provider.deleteItem(item.id),
      deleteTooltip: widget.deleteTooltip,
    );
  }
}

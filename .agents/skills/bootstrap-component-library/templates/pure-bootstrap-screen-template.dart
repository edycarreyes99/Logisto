import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';

/// Screen Template with Material Design 3 Visuals and Bootstrap Responsive Grid.
/// Conforms to RULE-UI-006 (Material 3 Visuals, Bootstrap Grid Only) and RULE-UI-002 (12-Column Grid).
/// Prioritizes laptop viewports (1280x720+) while guaranteeing responsive adaptation for tablets and mobile.
class PureBootstrapScreenTemplate extends StatefulWidget {
  final String title;

  const PureBootstrapScreenTemplate({
    super.key,
    required this.title,
  });

  @override
  State<PureBootstrapScreenTemplate> createState() =>
      _PureBootstrapScreenTemplateState();
}

class _PureBootstrapScreenTemplateState
    extends State<PureBootstrapScreenTemplate> {
  int _counter = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Operation Details'),
        content: Text('Current action counter is at $_counter clicks.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Information',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BsRow(
            children: [
              BsCol(
                config: const BsColConfig(xs: 12, md: 6, xl: 4),
                child: _buildControlCard(),
              ),
              BsCol(
                config: const BsColConfig(xs: 12, md: 6, xl: 4),
                child: _buildTelemetryCard(),
              ),
              BsCol(
                config: const BsColConfig(xs: 12, md: 12, xl: 4),
                child: _buildDataCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlCard() {
    final theme = Theme.of(context);
    return Card(
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
            Text('Control Panel', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search operations...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _increment,
              icon: const Icon(Icons.add),
              label: const Text('Increment Action'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryCard() {
    final theme = Theme.of(context);
    return Card(
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
            Text('Telemetry & Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Executions:', style: theme.textTheme.bodyMedium),
                Chip(label: Text('$_counter')),
              ],
            ),
            const SizedBox(height: 12),
            const LinearProgressIndicator(value: 0.65),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    final theme = Theme.of(context);
    return Card(
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
            Text('Event Log', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Core Service Active'),
              subtitle: Text('Target: Desktop / Web'),
            ),
          ],
        ),
      ),
    );
  }
}

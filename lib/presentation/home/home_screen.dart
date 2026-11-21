import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../common/logisto_app_bar.dart';
import 'widgets/control_panel_card.dart';
import 'widgets/log_table_card.dart';
import 'widgets/telemetry_metrics_card.dart';

/// Primary operational screen constructed with Material Design 3 and Bootstrap responsive grid.
/// Conforms to RULE-UI-006, RULE-UI-002, and RULE-UI-001.
/// Prioritizes laptop viewports (1280x720+) while adapting across tablets and mobile.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _increment() => setState(() => _counter++);
  void _reset() => setState(() => _counter = 0);

  void _showInfoModal() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.systemInformation),
        content: Text(l10n.telemetryTasksProcessed(_counter)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.dismiss),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    return Scaffold(
      appBar: LogistoAppBar(
        title: 'Logisto',
        actions: [
          if (isDesktop)
            TextButton.icon(
              onPressed: _showInfoModal,
              icon: const Icon(Icons.info_outline, size: 16),
              label: Text(l10n.systemInfo),
            )
          else
            IconButton(
              onPressed: _showInfoModal,
              icon: const Icon(Icons.info_outline, size: 20),
              tooltip: l10n.systemInfo,
            ),
        ],
      ),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildDashboardGrid(),
        ),
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return BsRow(
      children: [
        BsCol(
          config: const BsColConfig(xs: 12, sm: 12, md: 6, lg: 5, xl: 4),
          child: ControlPanelCard(
            searchController: _searchController,
            onIncrement: _increment,
            onReset: _reset,
          ),
        ),
        BsCol(
          config: const BsColConfig(xs: 12, sm: 12, md: 6, lg: 7, xl: 4),
          child: TelemetryMetricsCard(counter: _counter),
        ),
        const BsCol(
          config: BsColConfig(xs: 12, sm: 12, md: 12, lg: 12, xl: 4),
          child: LogTableCard(),
        ),
      ],
    );
  }
}

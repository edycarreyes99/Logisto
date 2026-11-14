import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/table_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../domain/models/billiard_table_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../context/business_context_provider.dart';
import 'billiard_provider.dart';
import 'widgets/billiard_table_card.dart';
import 'widgets/transfer_table_modal.dart';

/// Real-time floor plan screen for monitoring and controlling billiard tables,
/// rental timers, accrued revenue, and station transfers.
class BilliardFloorPlanScreen extends StatefulWidget {
  const BilliardFloorPlanScreen({super.key});

  @override
  State<BilliardFloorPlanScreen> createState() =>
      _BilliardFloorPlanScreenState();
}

class _BilliardFloorPlanScreenState extends State<BilliardFloorPlanScreen> {
  late final BilliardProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<BilliardProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    final buId =
        _contextProvider.activeBusinessUnit?.id ??
        DatabaseSeeder.defaultBuCentralId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadTables(orgId: orgId, buId: buId);
    });
  }

  void _showStartModal(BilliardTableModel table) {
    final l10n = AppLocalizations.of(context)!;
    final customerCtrl = TextEditingController();
    bool isStarting = false;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.startTableNamed(table.name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.enterCustomerPrompt),
              const SizedBox(height: 12),
              TextField(
                controller: customerCtrl,
                decoration: InputDecoration(
                  labelText: l10n.tableCustomerAliasPlaceholder,
                  hintText: l10n.tableCustomerAliasPlaceholder,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isStarting ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              icon: isStarting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow, size: 16),
              onPressed: isStarting
                  ? null
                  : () async {
                      setModalState(() => isStarting = true);
                      await _provider.startSession(
                        tableId: table.id,
                        customerName: customerCtrl.text,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Sesión iniciada en ${table.name}',
                        );
                      }
                    },
              label: Text(l10n.startSessionAction),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferModal(BilliardTableModel table) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) =>
          TransferTableModal(sourceTable: table, provider: _provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildHeader(l10n),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) {
              if (_provider.status == FeatureStatusEnum.loading) {
                return const AppSkeletonKpiGrid(cardCount: 6);
              }
              return _buildTableGrid();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n) {
    final occupied = _provider.tables
        .where((t) => t.status == TableStatusEnum.occupied)
        .length;
    return AppBar(
      title: Text(
        l10n.billiardFloorPlanTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Chip(
            label: Text(
              '$occupied / ${_provider.tables.length} ${l10n.tableStatusOccupied}',
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  Widget _buildTableGrid() {
    return BsRow(
      children: _provider.tables.map((table) {
        return BsCol(
          config: const BsColConfig(xs: 12, sm: 6, md: 6, lg: 3),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: BilliardTableCard(
              table: table,
              provider: _provider,
              onStart: () => _showStartModal(table),
              onTransfer: () => _showTransferModal(table),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'cash_shift_provider.dart';
import 'widgets/close_shift_blind_drop_modal.dart';
import 'widgets/shift_summary_card.dart';

/// Cash drawer shifts screen managing openings, cash movements,
/// and blind drop reconciliation (Corte Z).
class CashShiftScreen extends StatefulWidget {
  const CashShiftScreen({super.key});

  @override
  State<CashShiftScreen> createState() => _CashShiftScreenState();
}

class _CashShiftScreenState extends State<CashShiftScreen> {
  late final CashShiftProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<CashShiftProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadShifts(orgId: orgId, buId: buId);
      });
    }
  }

  void _showOpenShiftModal(AppLocalizations l10n) {
    final floatCtrl = TextEditingController(text: '100.00');
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.openCashShiftRegister(1)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.openingFloatPrompt),
              const SizedBox(height: 12),
              TextField(
                controller: floatCtrl,
                decoration: const InputDecoration(
                  hintText: '100.00',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(l10n.openShift),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final buId = _contextProvider.activeBusinessUnit?.id ?? '';
                      final float = double.tryParse(floatCtrl.text) ?? 100.0;
                      await _provider.openNewShift(
                        buId: buId,
                        registerNumber: 1,
                        openingBalance: float,
                        cashierId: 'usr_cashier_1',
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Turno de caja abierto con \$${float.toStringAsFixed(2)}',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _showMovementModal(AppLocalizations l10n) {
    final amtCtrl = TextEditingController();
    bool isSavingWithdraw = false;
    bool isSavingDeposit = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSavingWithdraw && !isSavingDeposit,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.recordCashMovement),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amtCtrl,
                decoration: InputDecoration(
                  hintText: l10n.amountPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: isSavingWithdraw
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_upward_rounded, size: 16),
                      label: Text(l10n.withdrawalSangria),
                      onPressed: (isSavingWithdraw || isSavingDeposit)
                          ? null
                          : () async {
                              setModalState(() => isSavingWithdraw = true);
                              final val = double.tryParse(amtCtrl.text) ?? 0.0;
                              await _provider.recordCashMovement(
                                amount: val,
                                isWithdrawal: true,
                              );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (mounted) {
                                AppFeedback.showWarning(
                                  context,
                                  'Retiro de efectivo por \$${val.toStringAsFixed(2)} registrado',
                                );
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      icon: isSavingDeposit
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_downward_rounded, size: 16),
                      label: Text(l10n.cashInflow),
                      onPressed: (isSavingWithdraw || isSavingDeposit)
                          ? null
                          : () async {
                              setModalState(() => isSavingDeposit = true);
                              final val = double.tryParse(amtCtrl.text) ?? 0.0;
                              await _provider.recordCashMovement(
                                amount: val,
                                isWithdrawal: false,
                              );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (mounted) {
                                AppFeedback.showSuccess(
                                  context,
                                  'Ingreso de efectivo por \$${val.toStringAsFixed(2)} registrado',
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (isSavingWithdraw || isSavingDeposit)
                  ? null
                  : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  void _showCloseShiftModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => CloseShiftBlindDropModal(provider: _provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final canOpenShift = !_provider.hasActiveShift;

    return LogistoScaffold(
      title: l10n.cashShiftsTitle,
      actions: isDesktop && canOpenShift
          ? [
              FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.openNewShift),
                onPressed: () => _showOpenShiftModal(l10n),
              ),
            ]
          : null,
      floatingActionButton: !isDesktop && canOpenShift
          ? FloatingActionButton.extended(
              onPressed: () => _showOpenShiftModal(l10n),
              icon: const Icon(Icons.add),
              label: Text(l10n.openNewShift),
            )
          : null,
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) {
              if (_provider.status == FeatureStatusEnum.loading) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSkeletonKpiGrid(cardCount: 4),
                    SizedBox(height: 20),
                    AppSkeletonTable(rowCount: 4, columnCount: 4),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_provider.hasActiveShift)
                    ShiftSummaryCard(
                      shift: _provider.activeShift!,
                      onAddMovement: () => _showMovementModal(l10n),
                      onCloseShift: _showCloseShiftModal,
                    )
                  else
                    _buildNoShiftBanner(l10n),
                  const SizedBox(height: 20),
                  _buildHistoryTable(l10n),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoShiftBanner(AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(l10n.noActiveShiftPrompt),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _showOpenShiftModal(l10n),
              child: Text(l10n.openShiftInitialFloat),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTable(AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.closedShiftHistoryTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(l10n.tableHeaderRegister)),
                  DataColumn(label: Text(l10n.tableHeaderCashier)),
                  DataColumn(
                    label: Text(l10n.tableHeaderExpected),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(l10n.tableHeaderCounted),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(l10n.tableHeaderVariance),
                    numeric: true,
                  ),
                  DataColumn(label: Text(l10n.tableHeaderStatus)),
                ],
                rows: _provider.pastShifts.map((s) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${s.cashRegisterNumber}')),
                      DataCell(Text(s.cashierUserId)),
                      DataCell(
                        Text('\$${s.expectedCashBalance.toStringAsFixed(2)}'),
                      ),
                      DataCell(
                        Text(
                          '\$${(s.actualCashCounted ?? 0.0).toStringAsFixed(2)}',
                        ),
                      ),
                      DataCell(
                        Text(
                          '${(s.difference ?? 0) >= 0 ? "+" : ""}\$${(s.difference ?? 0.0).toStringAsFixed(2)}',
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(
                            s.discrepancyStatus.storageKey.toUpperCase(),
                            style: const TextStyle(fontSize: 11),
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/kds_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../context/business_context_provider.dart';
import 'kitchen_provider.dart';
import 'widgets/kds_order_card.dart';

/// Kitchen Display System (KDS) screen displaying real-time preparation tickets
/// and order lifecycle status.
class KitchenDisplayScreen extends StatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  State<KitchenDisplayScreen> createState() => _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends State<KitchenDisplayScreen> {
  late final KitchenProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<KitchenProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    final buId =
        _contextProvider.activeBusinessUnit?.id ??
        DatabaseSeeder.defaultBuCentralId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadOrders(orgId: orgId, buId: buId);
    });
  }

  void _refresh() {
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    final buId =
        _contextProvider.activeBusinessUnit?.id ??
        DatabaseSeeder.defaultBuCentralId;
    _provider.loadOrders(orgId: orgId, buId: buId);
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showInfo(context, l10n.refresh);
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
            builder: (context, _) => _buildOrdersGrid(l10n),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.kitchenKdsTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.refresh,
          onPressed: _refresh,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildFilterBtn(l10n.allFilter, null),
              _buildFilterBtn(l10n.pendingFilter, KdsStatusEnum.pending),
              _buildFilterBtn(l10n.inPrepFilter, KdsStatusEnum.preparing),
              _buildFilterBtn(l10n.readyFilter, KdsStatusEnum.ready),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBtn(String label, KdsStatusEnum? status) {
    final isSel = _provider.filterStatus == status;
    return isSel
        ? FilledButton(
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () => _provider.setFilterStatus(status),
            child: Text(label),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () => _provider.setFilterStatus(status),
            child: Text(label),
          );
  }

  Widget _buildOrdersGrid(AppLocalizations l10n) {
    if (_provider.status == FeatureStatusEnum.loading &&
        _provider.filteredOrders.isEmpty) {
      return const AppSkeletonList(itemCount: 4);
    }

    final list = _provider.filteredOrders;
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: Text(l10n.noOrdersInQueue)),
      );
    }

    return BsRow(
      children: list.map((order) {
        return BsCol(
          config: const BsColConfig(xs: 12, sm: 6, md: 6, lg: 4),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: KdsOrderCard(
              order: order,
              onAdvance: () async {
                await _provider.advanceStatus(order);
                if (mounted) {
                  AppFeedback.showSuccess(
                    context,
                    '${order.orderCode} - ${order.tableOrTabName}',
                  );
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

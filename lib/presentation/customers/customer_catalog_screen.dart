import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../data/firestore/database_seeder.dart';
import '../../domain/models/customer_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../context/business_context_provider.dart';
import 'customer_catalog_provider.dart';
import 'widgets/customer_list_mobile.dart';
import 'widgets/customer_table_desktop.dart';

/// Customer catalog and accounts receivable credit limit directory screen.
class CustomerCatalogScreen extends StatefulWidget {
  const CustomerCatalogScreen({super.key});

  @override
  State<CustomerCatalogScreen> createState() => _CustomerCatalogScreenState();
}

class _CustomerCatalogScreenState extends State<CustomerCatalogScreen> {
  late final CustomerCatalogProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<CustomerCatalogProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadCustomers(orgId);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showCustomerModal([CustomerModel? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final firstCtrl = TextEditingController(text: existing?.firstName ?? '');
    final lastCtrl = TextEditingController(text: existing?.lastName ?? '');
    final taxCtrl = TextEditingController(text: existing?.taxId ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final limitCtrl = TextEditingController(
      text: existing != null ? existing.creditLimit.toStringAsFixed(2) : '0.00',
    );

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(
          existing == null ? l10n.registerCustomer : l10n.editCustomer,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstCtrl,
                decoration: InputDecoration(
                  labelText: l10n.placeholderFirstName,
                  hintText: l10n.placeholderFirstName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastCtrl,
                decoration: InputDecoration(
                  labelText: l10n.placeholderLastName,
                  hintText: l10n.placeholderLastName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: taxCtrl,
                decoration: InputDecoration(
                  labelText: l10n.placeholderTaxId,
                  hintText: l10n.placeholderTaxId,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(
                  labelText: l10n.placeholderPhone,
                  hintText: l10n.placeholderPhone,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limitCtrl,
                decoration: InputDecoration(
                  labelText: l10n.placeholderCreditLimit,
                  hintText: l10n.placeholderCreditLimit,
                  border: const OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final orgId =
                  _contextProvider.activeOrganization?.id ??
                  DatabaseSeeder.defaultOrgId;
              final limit = double.tryParse(limitCtrl.text) ?? 0.0;
              final cust = CustomerModel(
                id:
                    existing?.id ??
                    'cust_${DateTime.now().millisecondsSinceEpoch}',
                orgId: orgId,
                taxId: taxCtrl.text.isEmpty
                    ? '001-000000-0000U'
                    : taxCtrl.text,
                firstName: firstCtrl.text.isEmpty
                    ? l10n.defaultCustomerFirstName
                    : firstCtrl.text,
                lastName: lastCtrl.text.isEmpty
                    ? l10n.defaultCustomerLastName
                    : lastCtrl.text,
                phone: phoneCtrl.text.isEmpty ? 'N/A' : phoneCtrl.text,
                creditLimit: limit,
                currentDebtBalance: existing?.currentDebtBalance ?? 0.0,
                isCreditBlocked: existing?.isCreditBlocked ?? false,
                createdAt: existing?.createdAt ?? DateTime.now(),
              );
              _provider.saveCustomer(orgId: orgId, customer: cust);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.saveCustomer),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.customers,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.person_add, size: 18),
              label: Text(l10n.registerCustomer),
              onPressed: () => _showCustomerModal(),
            ),
          ),
        ],
      ),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildBody(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final customers = _provider.filteredCustomers;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: l10n.searchPlaceholder,
              prefixIcon: const Icon(Icons.search, size: 20),
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onChanged: _provider.setSearchQuery,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: customers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        l10n.noCustomersFound,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : (isDesktop
                    ? CustomerTableDesktop(
                        customers: customers,
                        onEdit: _showCustomerModal,
                        onToggleBlock: _provider.toggleCreditBlock,
                      )
                    : CustomerListMobile(
                        customers: customers,
                        onEdit: _showCustomerModal,
                      )),
          ),
        ),
      ],
    );
  }
}

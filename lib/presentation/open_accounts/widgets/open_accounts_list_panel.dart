import 'package:flutter/material.dart';
import '../../../domain/models/open_account_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../open_accounts_provider.dart';

/// Left panel displaying the search bar, active order count, and list of open accounts/tabs.
class OpenAccountsListPanel extends StatefulWidget {
  final OpenAccountsProvider provider;
  final VoidCallback onNewTab;

  const OpenAccountsListPanel({
    super.key,
    required this.provider,
    required this.onNewTab,
  });

  @override
  State<OpenAccountsListPanel> createState() => _OpenAccountsListPanelState();
}

class _OpenAccountsListPanelState extends State<OpenAccountsListPanel> {
  final _searchCtrl = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accounts = _getFilteredAccounts();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(l10n, theme),
            const SizedBox(height: 8),
            _buildSearchBar(l10n),
            const SizedBox(height: 12),
            if (accounts.isEmpty)
              _buildEmptyView(l10n, theme)
            else
              _buildAccountsList(accounts, theme),
          ],
        ),
      ),
    );
  }

  List<OpenAccountModel> _getFilteredAccounts() {
    if (_filter.isEmpty) return widget.provider.accounts;
    final query = _filter.toLowerCase();
    return widget.provider.accounts.where((a) {
      return a.code.toLowerCase().contains(query) ||
          a.customerDisplayName.toLowerCase().contains(query) ||
          (a.tableName != null && a.tableName!.toLowerCase().contains(query));
    }).toList();
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              l10n.openAccountsListTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Badge.count(
              count: widget.provider.accounts.length,
              backgroundColor: theme.colorScheme.primaryContainer,
              textColor: theme.colorScheme.onPrimaryContainer,
            ),
          ],
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add, size: 18),
          tooltip: l10n.newTab,
          visualDensity: VisualDensity.compact,
          onPressed: widget.onNewTab,
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return TextField(
      controller: _searchCtrl,
      onChanged: (val) => setState(() => _filter = val.trim()),
      decoration: InputDecoration(
        hintText: l10n.searchAccountsPlaceholder,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _filter.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _filter = '');
                },
              )
            : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildAccountsList(List<OpenAccountModel> accounts, ThemeData theme) {
    final selectedId = widget.provider.selectedAccount?.id;

    return Column(
      children: [
        for (int i = 0; i < accounts.length; i++) ...[
          if (i > 0) const SizedBox(height: 6),
          _buildAccountCard(accounts[i], accounts[i].id == selectedId, theme),
        ],
      ],
    );
  }

  Widget _buildAccountCard(OpenAccountModel acc, bool isSelected, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => widget.provider.selectAccount(acc.id),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : AppColors.borderOf(context).withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    acc.code,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                ),
                Text(
                  '\$${acc.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    acc.customerDisplayName,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  l10n.itemsInOrder(acc.items.length),
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 36, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(
              l10n.noOpenAccountsFound,
              style: TextStyle(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: Text(l10n.openTabAction),
              onPressed: widget.onNewTab,
            ),
          ],
        ),
      ),
    );
  }
}

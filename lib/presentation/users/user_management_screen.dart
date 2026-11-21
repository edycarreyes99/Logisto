import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/user_profile_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'user_management_provider.dart';
import 'widgets/edit_user_role_modal.dart';
import 'widgets/invite_user_modal.dart';
import 'widgets/user_list_mobile.dart';
import 'widgets/user_table_desktop.dart';

/// Screen for managing corporate employees, role assignments per business unit,
/// and terminal security.
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late final UserManagementProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<UserManagementProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.startListening(orgId);
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showInviteModal() {
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    showDialog<void>(
      context: context,
      builder: (ctx) => InviteUserModal(
        orgId: orgId,
        provider: _provider,
      ),
    );
  }

  void _showRoleModal(UserProfileModel user) {
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    showDialog<void>(
      context: context,
      builder: (ctx) =>
          EditUserRoleModal(user: user, activeBuId: buId, provider: _provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return LogistoScaffold(
      title: l10n.usersAndStaff,
      actions: isDesktop
          ? [
              SizedBox(
                width: 240,
                height: 40,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.searchPlaceholder,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _provider.setSearchQuery,
                ),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: Text(l10n.inviteEmployee),
                onPressed: _showInviteModal,
              ),
            ]
          : null,
      floatingActionButton: !isDesktop
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.person_add_outlined),
              label: Text(l10n.inviteEmployee),
              onPressed: _showInviteModal,
            )
          : null,
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) {
              if (_provider.status == FeatureStatusEnum.loading &&
                  _provider.users.isEmpty) {
                return isDesktop
                    ? const AppSkeletonTable(rowCount: 5, columnCount: 4)
                    : const AppSkeletonList(itemCount: 4);
              }
              return isDesktop
                  ? UserTableDesktop(
                      users: _provider.filteredUsers,
                      onEditRole: _showRoleModal,
                    )
                  : _buildMobileContent(l10n);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: l10n.searchPlaceholder,
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _provider.setSearchQuery,
        ),
        const SizedBox(height: 12),
        UserListMobile(
          users: _provider.filteredUsers,
          onEditRole: _showRoleModal,
        ),
      ],
    );
  }
}

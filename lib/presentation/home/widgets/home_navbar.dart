import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../../navigation/navigation_shell.dart';

/// Top navigation bar using Flutter Material Design 3.
/// Conforms to RULE-UI-006 and RULE-UI-001 (<40 LOC build method).
class HomeNavbar extends StatelessWidget {
  final VoidCallback onInfoPressed;

  const HomeNavbar({super.key, required this.onInfoPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Logisto',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (isDesktop) ..._buildNavLinks(context, l10n, theme),
          _buildInfoButton(l10n),
        ],
      ),
    );
  }

  List<Widget> _buildNavLinks(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return [
      const SizedBox(width: 16),
      TextButton(
        onPressed: () {
          AppFeedback.showInfo(
            context,
            '${l10n.overview}: Vista general del sistema',
          );
        },
        child: Text(
          l10n.overview,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          AppFeedback.showInfo(
            context,
            '${l10n.metrics}: Métricas de rendimiento activas',
          );
        },
        child: Text(l10n.metrics),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, _, _) => const NavigationShell(),
            ),
          );
        },
        child: Text(l10n.erpSuite),
      ),
      const Spacer(),
    ];
  }

  Widget _buildInfoButton(AppLocalizations l10n) {
    return Flexible(
      child: TextButton.icon(
        onPressed: onInfoPressed,
        icon: const Icon(Icons.info_outline, size: 16),
        label: Text(l10n.systemInfo, overflow: TextOverflow.ellipsis),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

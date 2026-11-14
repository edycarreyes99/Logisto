import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../navigation/navigation_provider.dart';

/// Enterprise unified [AppBar] for all Logisto modules.
///
/// Features:
/// - Same background color as body (`Theme.of(context).scaffoldBackgroundColor`) with zero elevation.
/// - Bold, standardized module title typography.
/// - Adaptive leading icon:
///   - If child view (`isChild == true` or auto-detected via [ModalRoute.canPop]): shows [Icons.arrow_back_rounded] to pop route.
///   - If parent view (`!isChild`):
///     - On mobile (`!isDesktop`): shows [Icons.menu_rounded] which opens the module drawer on the enclosing [Scaffold].
///     - On desktop (`isDesktop`): hides hamburger menu (sidebar is permanently visible).
/// - Extensible [actions] slot for module-specific buttons (refresh, filters, create).
class LogistoAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Primary module or screen title.
  final String? title;

  /// Optional custom title widget overriding [title].
  final Widget? titleWidget;

  /// Explicit flag denoting whether this view is a child screen in a workflow.
  /// When `null`, automatically determined via [ModalRoute.of(context).canPop].
  final bool? isChild;

  /// Custom callback triggered when the back button is tapped in a child view.
  /// Defaults to `Navigator.of(context).maybePop()`.
  final VoidCallback? onBack;

  /// Module-specific action buttons displayed at the trailing end.
  final List<Widget>? actions;

  /// Optional bottom widget (e.g. [TabBar]).
  final PreferredSizeWidget? bottom;

  /// Background color overriding the default `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// App bar elevation. Defaults to `0.0`.
  final double elevation;

  /// Center title alignment. Defaults to `false` conforming to Material 3.
  final bool centerTitle;

  const LogistoAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.isChild,
    this.onBack,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.elevation = 0.0,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final effectiveBg = backgroundColor ?? theme.scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: effectiveBg,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: 0.0,
      centerTitle: centerTitle,
      leading: _buildLeading(context, isDesktop),
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null),
      actions: actions != null && actions!.isNotEmpty
          ? [
              ...actions!,
              const SizedBox(width: 8.0),
            ]
          : null,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context, bool isDesktop) {
    final bool effectiveIsChild =
        isChild ?? (ModalRoute.of(context)?.canPop ?? false);

    if (effectiveIsChild) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      );
    }

    // Root/Parent view
    if (isDesktop) {
      return null;
    }

    return Builder(
      builder: (btnContext) => IconButton(
        icon: const Icon(Icons.menu_rounded),
        tooltip: MaterialLocalizations.of(btnContext).openAppDrawerTooltip,
        onPressed: () {
          final scaffold = Scaffold.maybeOf(btnContext);
          if (scaffold != null && scaffold.hasDrawer) {
            scaffold.openDrawer();
          } else if (locator.isRegistered<NavigationProvider>()) {
            locator<NavigationProvider>().toggleDrawer();
          }
        },
      ),
    );
  }
}

import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../context/business_context_provider.dart';
import '../navigation/navigation_drawer.dart';
import '../navigation/navigation_provider.dart';
import 'logisto_app_bar.dart';

/// Enterprise [Scaffold] pairing screen content with the unified [LogistoAppBar]
/// and adaptive [AppNavigationDrawer] on mobile devices.
class LogistoScaffold extends StatelessWidget {
  /// Primary module or screen title.
  final String? title;

  /// Optional custom title widget overriding [title].
  final Widget? titleWidget;

  /// Explicit flag denoting whether this view is a child screen in a workflow.
  final bool? isChild;

  /// Custom callback triggered when the back button is tapped in a child view.
  final VoidCallback? onBack;

  /// Module-specific action buttons displayed in the app bar.
  final List<Widget>? actions;

  /// Optional bottom widget for the app bar (e.g. [TabBar]).
  final PreferredSizeWidget? bottom;

  /// Custom app bar completely replacing the default [LogistoAppBar].
  final PreferredSizeWidget? customAppBar;

  /// Primary screen body content.
  final Widget body;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional bottom sheet.
  final Widget? bottomSheet;

  /// Background color of the scaffold. Defaults to theme scaffoldBackgroundColor.
  final Color? backgroundColor;

  /// Optional custom drawer overriding default [AppNavigationDrawer].
  final Widget? customDrawer;

  /// Explicit flag denoting whether drawer navigation is permitted.
  /// When `false`, suppresses the drawer and hides the hamburger menu icon.
  final bool showDrawer;

  const LogistoScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.isChild,
    this.onBack,
    this.actions,
    this.bottom,
    this.customAppBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.backgroundColor,
    this.customDrawer,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final navProvider = locator.isRegistered<NavigationProvider>()
        ? locator<NavigationProvider>()
        : null;
    final contextProvider = locator.isRegistered<BusinessContextProvider>()
        ? locator<BusinessContextProvider>()
        : null;

    final Widget? effectiveDrawer;
    if (!showDrawer) {
      effectiveDrawer = null;
    } else if (customDrawer != null) {
      effectiveDrawer = customDrawer;
    } else if (isDesktop || navProvider == null || contextProvider == null) {
      effectiveDrawer = null;
    } else {
      effectiveDrawer = Drawer(
        width: 310.0,
        child: AppNavigationDrawer(
          navProvider: navProvider,
          contextProvider: contextProvider,
          onNavigate: () => Navigator.of(context).maybePop(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      drawer: effectiveDrawer,
      appBar: customAppBar ??
          LogistoAppBar(
            title: title,
            titleWidget: titleWidget,
            isChild: isChild,
            onBack: onBack,
            actions: actions,
            bottom: bottom,
            backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
            showDrawer: showDrawer,
          ),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomSheet: bottomSheet,
    );
  }
}

import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/widgets.dart';

/// Top navigation bar using exclusive bootstrap_ui_flutter components.
/// Conforms to RULE-UI-006 and RULE-UI-001 (<40 LOC build method).
class HomeNavbar extends StatelessWidget {
  final VoidCallback onInfoPressed;

  const HomeNavbar({super.key, required this.onInfoPressed});

  @override
  Widget build(BuildContext context) {
    return BsNavbar(
      expand: BsNavbarExpand.lg,
      brand: const BsNavbarBrand(child: Text('Logisto')),
      collapse: BsNavbarCollapse(
        children: [
          BsNavbarNav(
            children: [
              BsNavbarLink(label: 'Overview', active: true, onPressed: () {}),
              BsNavbarLink(label: 'Metrics', onPressed: () {}),
            ],
          ),
          const SizedBox(width: 16),
          BsButton(
            label: 'System Info',
            icon: BsIcons.infoCircle,
            variant: BsButtonVariant.primary,
            outline: true,
            size: BsButtonSize.sm,
            onPressed: onInfoPressed,
          ),
        ],
      ),
    );
  }
}

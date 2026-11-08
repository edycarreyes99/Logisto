import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/widgets.dart';

/// Interactive operations card built exclusively with bootstrap_ui_flutter.
/// Conforms to RULE-UI-006 and RULE-UI-001.
class ControlPanelCard extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const ControlPanelCard({
    super.key,
    required this.searchController,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return BsCard(
      header: const BsCardHeader(child: Text('Operational Controls')),
      body: BsCardBody(
        children: [
          BsInput(
            controller: searchController,
            placeholder: 'Filter logs or telemetry...',
            size: BsInputSize.md,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BsButton(
                label: 'Increment',
                icon: BsIcons.plusLg,
                variant: BsButtonVariant.primary,
                size: BsButtonSize.md,
                onPressed: onIncrement,
              ),
              BsButton(
                label: 'Reset',
                variant: BsButtonVariant.danger,
                outline: true,
                size: BsButtonSize.md,
                onPressed: onReset,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

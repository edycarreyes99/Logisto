import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/widgets.dart';

/// Telemetry metrics display card built exclusively with bootstrap_ui_flutter.
/// Conforms to RULE-UI-006 and RULE-UI-001.
class TelemetryMetricsCard extends StatelessWidget {
  final int counter;

  const TelemetryMetricsCard({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return BsCard(
      header: const BsCardHeader(child: Text('Telemetry & Status')),
      body: BsCardBody(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Processed Tasks:'),
              BsBadge(
                label: '$counter',
                variant: BsVariant.success,
                isPill: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const BsAlert(
            variant: BsVariant.info,
            icon: BsIcons.checkCircleFill,
            child: Text('Multiplatform node operational on current target.'),
          ),
        ],
      ),
    );
  }
}

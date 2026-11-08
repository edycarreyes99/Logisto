import 'package:flutter/widgets.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';

/// Pure Bootstrap UI Screen Template.
/// Conforms to RULE-UI-006 (Zero Material, Zero Cupertino) and RULE-UI-002 (12-Column Grid).
/// Prioritizes laptop viewports (1280x720+) while guaranteeing responsive adaptation for tablets and mobile.
class PureBootstrapScreenTemplate extends StatefulWidget {
  final String title;

  const PureBootstrapScreenTemplate({
    super.key,
    required this.title,
  });

  @override
  State<PureBootstrapScreenTemplate> createState() =>
      _PureBootstrapScreenTemplateState();
}

class _PureBootstrapScreenTemplateState
    extends State<PureBootstrapScreenTemplate> {
  int _counter = 0;
  final bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _showInfoModal() {
    showBsModal(
      context: context,
      backdrop: BsBackdrop.enabled,
      keyboard: true,
      centered: true,
      builder: (ctx) => BsModal(
        size: BsModalSize.md,
        header: const BsModalHeader(
          child: Text('Operation Details'),
        ),
        body: BsModalBody(
          child: Text('Current action counter is at $_counter clicks.'),
        ),
        footer: BsModalFooter(
          children: [
            BsButton(
              label: 'Close',
              variant: BsButtonVariant.secondary,
              size: BsButtonSize.sm,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BsContainer.fluid(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Application Navigation Bar Header (Replaces AppBar)
          BsNavbar(
            expand: BsNavbarExpand.lg,
            brand: BsNavbarBrand(
              child: Text(widget.title),
            ),
            collapse: BsNavbarCollapse(
              children: [
                BsNavbarNav(
                  children: [
                    BsNavbarLink(
                      label: 'Dashboard',
                      active: true,
                      onPressed: () {},
                    ),
                    BsNavbarLink(
                      label: 'Analytics',
                      onPressed: () {},
                    ),
                  ],
                ),
                const BsNavbarSpacer(),
                BsButton(
                  label: 'Info',
                  icon: BsIcons.infoCircle,
                  variant: BsButtonVariant.primary,
                  outline: true,
                  size: BsButtonSize.sm,
                  onPressed: _showInfoModal,
                ),
              ],
            ),
          ),

          // Main Responsive Content Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: BsRow(
                children: [
                  // Form and Action Controls Column: 12 on mobile, 5 on laptop (xl: 5)
                  BsCol(
                    config: const BsColConfig(xs: 12, sm: 12, md: 6, lg: 5, xl: 4),
                    child: BsCard(
                      header: const BsCardHeader(
                        child: Text('Interactive Control Panel'),
                      ),
                      body: BsCardBody(
                        children: [
                          BsInput(
                            controller: _searchController,
                            placeholder: 'Search stations or logs...',
                            size: BsInputSize.md,
                          ),
                          const SizedBox(height: 12),
                          BsHStack(
                            gap: 8,
                            children: [
                              BsButton(
                                label: 'Increment',
                                icon: BsIcons.plusLg,
                                variant: BsButtonVariant.primary,
                                size: BsButtonSize.md,
                                onPressed: _increment,
                              ),
                              BsButton(
                                label: 'Reset',
                                variant: BsButtonVariant.danger,
                                outline: true,
                                size: BsButtonSize.md,
                                onPressed: () => setState(() => _counter = 0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Data Metrics and Status Column: 12 on mobile, 7 on laptop (xl: 8)
                  BsCol(
                    config: const BsColConfig(xs: 12, sm: 12, md: 6, lg: 7, xl: 8),
                    child: BsCard(
                      header: const BsCardHeader(
                        child: Text('Telemetry and State'),
                      ),
                      body: BsCardBody(
                        children: [
                          BsHStack(
                            gap: 12,
                            children: [
                              const Text('Active Counter:'),
                              BsBadge(
                                label: '$_counter',
                                variant: BsVariant.success,
                                isPill: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_isLoading)
                            const BsSpinner.border(
                              variant: BsVariant.primary,
                              size: BsSpinnerSize.sm,
                            )
                          else
                            const BsAlert(
                              variant: BsVariant.info,
                              icon: BsIcons.checkCircleFill,
                              child: Text('System telemetry operating within normal parameters.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

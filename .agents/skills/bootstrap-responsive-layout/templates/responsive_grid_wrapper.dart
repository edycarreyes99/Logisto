import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/widgets.dart';

/// Responsive wrapper demonstrating standard 12-column layout with bootstrap_ui_flutter across all breakpoints.
/// Prioritizes laptop viewports (1280x720+) while gracefully adapting across mobile and tablet form factors.
class ResponsiveGridWrapper extends StatelessWidget {
  /// Child list items to arrange responsively.
  final List<Widget> children;

  /// Creates an immutable [ResponsiveGridWrapper] instance.
  ///
  /// - [children]: Child widgets to distribute responsively.
  const ResponsiveGridWrapper({super.key, required this.children});

  @override
  /// Builds the widget layout according to theme and styling configurations.
  ///
  /// - [context]: Build context to resolve theme, dimensions, and localization.
  /// Returns the assembled [Widget] tree.
  Widget build(BuildContext context) {
    return BsContainer.fluid(
      padding: const EdgeInsets.all(16),
      child: BsRow(
        children: children.map((child) {
          return BsCol(
            config: const BsColConfig(
              xs: 12, // 1 column on mobile phones (<576px)
              sm: 6,  // 2 columns on small tablets / landscape (>=576px)
              md: 4,  // 3 columns on standard tablets (>=768px)
              lg: 3,  // 4 columns on small laptops / desktop (>=992px)
              xl: 3,  // 4 columns on standard laptops 1280x720+ (>=1200px)
              xxl: 2, // 6 columns on ultra-wide screens (>=1400px)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

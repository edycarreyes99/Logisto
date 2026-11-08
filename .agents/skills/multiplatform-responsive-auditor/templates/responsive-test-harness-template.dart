import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reusable responsive test harness for pumping any widget across all 6 Bootstrap
/// breakpoints in both portrait and landscape orientations.
/// Conforms to RULE-QUAL-002 and RULE-UI-002.
///
/// Priority Target: Laptops from 1280x720 upwards are the primary deployment target,
/// while maintaining 100% responsive fluid adaptation across mobile handsets and tablets.
class ResponsiveTestHarness {
  static const Map<String, Size> standardViewportMatrix = {
    'xs_mobile_portrait': Size(360, 800),
    'sm_mobile_landscape': Size(800, 360),
    'md_tablet_portrait': Size(768, 1024),
    'lg_tablet_landscape': Size(1024, 768),
    'xl_laptop_primary_720': Size(
      1280,
      720,
    ), // Primary target: benchmark laptop
    'xl_laptop_standard_800': Size(1280, 800), // Standard 16:10 laptop
    'xl_laptop_wide_768': Size(1366, 768), // Common 1366x768 laptop
    'xxl_desktop_workstation': Size(1920, 1080), // 1080p desktop display
  };

  /// Runs the target widget through every viewport dimension in the matrix,
  /// asserting zero uncaught exceptions and zero RenderFlex overflow glitches.
  static void runResponsiveMatrix({
    required String screenName,
    required Widget Function(BuildContext context) widgetBuilder,
    Map<String, Size> customMatrix = standardViewportMatrix,
  }) {
    for (final entry in customMatrix.entries) {
      testWidgets(
        '$screenName adapts flawlessly on ${entry.key} (${entry.value.width.toInt()}x${entry.value.height.toInt()})',
        (WidgetTester tester) async {
          // Set virtual physical size and device pixel ratio
          tester.view.physicalSize = entry.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            WidgetsApp(
              color: const Color(0xFF0D6EFD),
              builder: (context, _) => widgetBuilder(context),
            ),
          );
          await tester.pumpAndSettle();

          // Assert zero exceptions and zero RenderFlex overflow
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

---
id: RULE-QUAL-002
title: Universal Multiplatform Execution & 100% Responsive Orientation Verification
category: quality
severity: blocking
scope:
  include:
    - "lib/**"
    - "test/**"
    - "tool/**"
  exclude: []
---

# Universal Multiplatform Execution & 100% Responsive Orientation Verification

> Rule ID: RULE-QUAL-002  
> Severity: blocking  
> Target Scope: lib/**, test/**, tool/**  
> Category: quality  

---

## 1. Architectural Invariant

The application architecture MUST compile, run, and maintain operational stability across all 5 official Flutter target platforms: **Web, Windows, macOS (Intel x86_64 and Apple Silicon arm64), Android (API 21+), and iOS (iOS 13.0+)**.

Furthermore, every user interface screen MUST be **100% responsive**, dynamically adapting content across all 6 canonical Bootstrap 5.3 breakpoints in both **Portrait** and **Landscape** orientations without layout clipping or `RenderFlex` overflow exceptions.

### 1.1. Multiplatform Platform Target Matrix:
1. **Web:** Compiles cleanly to JavaScript / WASM. Must adapt to browser viewport resizes, preserve session state in IndexedDB, and avoid platform-restricted IO plugins (`dart:io` without conditional imports).
2. **Windows:** Compiles as a 64-bit desktop application (`windows/`). Supports dynamic desktop window resizing, DPI scaling, and physical mouse/keyboard interactions.
3. **macOS:** Supports universal binaries for both **Apple Silicon (arm64)** and **Intel (x86_64)**. Adheres to macOS desktop window framing and native keyboard shortcuts.
4. **Android:** Minimum SDK version `minSdkVersion 21`. Operates seamlessly across mobile handsets, foldables, and large-screen tablets in both portrait and landscape modes.
5. **iOS:** Minimum deployment target iOS 13.0. Operates seamlessly across iPhones and iPads, respecting system safe areas (Notch, Dynamic Island, Home Indicator) in both portrait and landscape modes.

### 1.2. Laptop Priority & Form Factor Hierarchy:
While the application architecture operates seamlessly across mobile handsets, tablets, laptops, and desktops, **laptops from 1280x720 and above are designated as the PRIMARY operational target**. Layouts, typography, touch/mouse affordances, and content density must be designed primarily for laptop viewports (1280x720, 1280x800, 1366x768, 1440x900, 1536x864, 1920x1080), while guaranteeing 100% responsive fluid adaptation across mobile handsets and tablets in both portrait and landscape.

### 1.3. 100% Responsive & Dual-Orientation Invariant:
1. All responsive views MUST be built with `bootstrap_ui_flutter` (`BsContainer`, `BsRow`, `BsCol`, `BsColConfig`) adapting across all 6 standard breakpoints:
   - `xs` (<576px): Single-column mobile portrait layouts (`BsColConfig(xs: 12)`).
   - `sm` (>=576px): Two-column mobile landscape / small tablet layouts (`BsColConfig(sm: 6)`).
   - `md` (>=768px): Tablet portrait / medium display layouts (`BsColConfig(md: 6)`).
   - `lg` (>=992px): Desktop / tablet landscape / compact laptop layouts (`BsColConfig(lg: 4)`).
   - `xl` (>=1200px): **Primary Laptop Target (1280x720+)** and standard desktop layouts (`BsColConfig(xl: 3)` or `xl: 4`).
   - `xxl` (>=1400px): Ultra-wide workstation monitor layouts (`BsColConfig(xxl: 2)` or `xxl: 3`).
2. Under no circumstances shall any view:
   - Throw a `RenderFlex overflowed by ... pixels` exception under any viewport width from 320px to 3840px.
   - Break when transitioning between Portrait (height > width) and Landscape (width > height) orientations.
   - Lock screen orientation unless explicitly mandated by system specification.
3. Every presentation screen MUST be verified via automated multi-breakpoint responsive widget tests in `test/presentation/responsive/`, including the 1280x720 laptop benchmark.

---

## 2. Rationale & Failure Impact

- **True Universal Multiplatform Delivery:** Modern enterprise solutions cannot fail when launched on desktop, web, or tablet form factors. Operating system incompatibilities or missing platform guards break onboarding and crash production clients.
- **Orientation Resilience:** Mobile and tablet users frequently rotate devices or operate in split-screen multitasking. Applications that only test mobile portrait break when rotated to landscape, causing clipped text, unclickable action buttons, and severe overflow crashes.
- **Failure Impact:** A single `RenderFlex` overflow in production obscures content, blocks user form submissions, and degrades app store ratings and user trust.

---

## 3. Compliant Pattern (DO)

Automated multi-breakpoint and dual-orientation test verification:

```dart
// test/presentation/responsive/stations_screen_responsive_test.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:logisto/presentation/stations/stations_screen.dart';

void main() {
  const testBreakpoints = <String, Size>{
    'mobile_portrait_xs': Size(360, 800),
    'mobile_landscape_sm': Size(800, 360),
    'tablet_portrait_md': Size(768, 1024),
    'tablet_landscape_lg': Size(1024, 768),
    'laptop_primary_720': Size(1280, 720), // Primary target: benchmark laptop
    'laptop_standard_800': Size(1280, 800),
    'ultrawide_xxl': Size(1920, 1080),
  };

  for (final entry in testBreakpoints.entries) {
    testWidgets('StationsScreen renders without overflow on ${entry.key}', (tester) async {
      // Configure virtual surface to target size
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF0D6EFD),
          builder: (context, _) => StationsScreen(
            stations: const [],
            onRefresh: () {},
            onSearch: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // INVARIANT: Zero uncaught exceptions and zero RenderFlex overflow
      expect(tester.takeException(), isNull);
    });
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Assuming fixed device dimensions or neglecting landscape orientation:

```dart
// BAD: Fixed layout height with no scroll view or orientation awareness
class BadFixedScreen extends StatelessWidget {
  const BadFixedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // VIOLATION: Hardcoded height of 700px will overflow in landscape mode (height 360px)
    return Container(
      height: 700,
      child: Column(
        children: [
          Container(height: 300, child: Text('Header')),
          Container(height: 400, child: Text('Body')), // OVERFLOW in landscape!
        ],
      ),
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Execute multiplatform compilation checks and the automated responsive test matrix:

```bash
# 1. Run all unit and responsive widget test matrices
flutter test test/presentation/responsive/

# 2. Audit for layout overflow assertions across all tests
flutter test --reporter expanded | grep -E "(RenderFlex overflowed|EXCEPTION CAUGHT)"

# 3. Verify clean multiplatform analysis
flutter analyze

# 4. Verify web compilation bundle
flutter build web --wasm-dry-run
```

Any overflow exception or unmanaged platform error will immediately fail the quality audit.


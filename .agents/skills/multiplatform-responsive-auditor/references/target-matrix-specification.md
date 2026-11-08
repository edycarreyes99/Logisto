# Universal Multiplatform & Responsive Verification Target Matrix

> Standard: Production Quality & Verification Specification  
> Scope: Universal multiplatform execution & responsive layout verification  
> Rule Conformance: RULE-QUAL-002, RULE-ARCH-007, RULE-UI-002  
> Primary Form Factor Priority: Laptops from 1280x720 upwards  

---

## 1. Multiplatform Platform Target Matrix

The application must execute reliably across 5 official Flutter targets:

| Platform Target | Architecture / Engine | Target SDK / Requirements | Build / Verification Command |
| :--- | :--- | :--- | :--- |
| **Web** | WebAssembly / HTML / CanvasKit | Modern Browsers (Chrome, Edge, Firefox, Safari) | `flutter build web --wasm` or `flutter build web --wasm-dry-run` |
| **Windows** | Win32 C++ Desktop (x86_64) | Windows 10/11 64-bit | `flutter build windows` |
| **macOS (Apple Silicon)** | Darwin arm64 Native Desktop | macOS 10.15+ (Apple M1/M2/M3/M4) | `flutter build macos` |
| **macOS (Intel)** | Darwin x86_64 Native Desktop | macOS 10.15+ (Intel Core) | `flutter build macos` |
| **Android** | Android Runtime (ART) | `minSdkVersion 21`, API 34+ | `flutter build apk --debug` |
| **iOS** | Native iOS CocoaTouch | iOS 13.0+ (iPhone & iPad) | `flutter build ios --no-codesign` |

---

## 2. Form Factor Hierarchy & Laptop Priority Invariant

While the application supports smartphones, tablets, laptops, and desktop workstations, **laptops from 1280x720 upwards are designated as the PRIMARY operational target**. The design, layout density, controls, and information hierarchy must be optimized first and foremost for laptop screens (1280x720, 1280x800, 1366x768, 1440x900, 1536x864, 1920x1080), while guaranteeing 100% responsive fluid adaptation across mobile handsets and tablets in both portrait and landscape.

### Priority Hierarchy:
1. **Tier 1 (Primary Production Target): Laptops (1280x720 to 1920x1080)**
   - Viewport widths from 1280px and heights from 720px.
   - Comprehensive multi-column dashboard layouts (`BsCol` spans 3 to 4 columns).
   - High information density, fully expanded horizontal `BsNavbar`, sticky action controls, and complete data tables (`BsTable`).
2. **Tier 2 (Secondary Target): Tablets (768px to 1024px)**
   - iPad and Android tablets in both Portrait (768x1024) and Landscape (1024x768).
   - 2 to 3 column card distributions (`BsColConfig(md: 6, lg: 4)`).
   - Touch targets meeting minimum 44x44px boundaries.
3. **Tier 3 (Mobile Adaptation): Smartphones (360px to 800px)**
   - Compact devices in Portrait (360x800) and Landscape (800x360).
   - Single-column card stacking (`BsColConfig(xs: 12)`).
   - Collapsible hamburger navbar (`BsNavbarToggler` and `BsNavbarCollapse`).
   - Scrollable containers preventing vertical landscape clipping.

---

## 3. 100% Responsive Orientation & Breakpoint Matrix

All user interface screens must be systematically tested against all 6 Bootstrap 5.3 breakpoints in both **Portrait** and **Landscape** orientations:

| Breakpoint Tier | Dimensions (W x H) | Orientation | Form Factor Role | Expected Layout Behavior |
| :--- | :--- | :--- | :--- | :--- |
| **`xs` (Mobile Portrait)** | 360 x 800 | Portrait | Smartphone Mobile | Single column (`BsColConfig(xs: 12)`). Hamburger navbar toggler visible. |
| **`sm` (Mobile Landscape)** | 800 x 360 | Landscape | Rotated Mobile | 2-column wrapping (`BsColConfig(sm: 6)`). Scrollable body without vertical clipping. |
| **`md` (Tablet Portrait)** | 768 x 1024 | Portrait | iPad / Tablet Portrait | 2-column card grid (`BsColConfig(md: 6)`). Expanded navigation drawer or navbar. |
| **`lg` (Tablet Landscape)** | 1024 x 768 | Landscape | Rotated Tablet / Small Laptop | 3-column card grid (`BsColConfig(lg: 4)`). Fully expanded horizontal navbar. |
| **`xl` (Laptop Benchmark - Primary)** | 1280 x 720 | Landscape | **Primary Target: Benchmark Laptop** | 3 to 4 column card grid (`BsColConfig(xl: 3)` or `xl: 4`). Optimized layout density. |
| **`xl` (Standard Laptop)** | 1280 x 800 | Landscape | Standard 16:10 Laptop | 4-column card grid (`BsColConfig(xl: 3)`). Complete sidebar + content layout. |
| **`xl` (HD Laptop Display)** | 1366 x 768 | Landscape | Mainstream 1366x768 Laptop | 4-column card grid. Edge-to-edge fluid container with zero horizontal clipping. |
| **`xxl` (Ultra-wide Desktop)** | 1920 x 1080 | Landscape | Workstation Displays | 4 to 6 column card grid (`BsColConfig(xxl: 2)` or `xxl: 3`). Centered fluid container. |

---

## 4. Automated Overflow Detection Invariant

When running the responsive test suite, Flutter tests MUST assert:
1. `expect(tester.takeException(), isNull)`: Prohibits any unhandled layout or rendering exception.
2. Zero `A RenderFlex overflowed by ... pixels` messages printed to stdout or stderr.
3. No horizontal page clipping when scrolling vertically.
4. Smooth font and icon scaling across 1.0x to 2.5x device pixel ratios.

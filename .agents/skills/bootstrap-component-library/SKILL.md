---
name: bootstrap-component-library
description: |
  Comprehensive procedural guide and reference implementation framework for all components, helpers,
  and utilities in bootstrap_ui_flutter. Enforces 100% exclusive usage of Bootstrap UI components while
  strictly prohibiting Material Design and Cupertino visual widgets.
  Mandatory trigger conditions:
  - Trigger when constructing new UI screens, forms, modals, tables, or reusable widgets using bootstrap_ui_flutter.
  - Trigger when migrating or refactoring legacy Flutter views away from Material Design or Cupertino.
  - Trigger when selecting and implementing Bootstrap components, helpers (BsVStack, BsHStack, BsRatio), or utility extensions.
  Do NOT trigger when:
  - Do not trigger for headless backend data queries, repository streams, or pure domain modeling.
  - Do not trigger for localization translation synchronization alone.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Bootstrap UI Flutter Component Library and Architecture Specification

> Standard: Universal Multiplatform Design System Specification  
> Scope: Entire presentation layer (`lib/presentation/`, `lib/core/widgets/`)  
> Governance: Zero Emojis, 100% Technical English, Strict Automated Validation  
> Rule Conformance: RULE-UI-006 (Zero Material, Zero Cupertino), RULE-UI-002 (12-Column Grid)  
> Component Catalog: [references/component-reference-catalog.md](references/component-reference-catalog.md)  
> Screen Template: [templates/pure-bootstrap-screen-template.dart](templates/pure-bootstrap-screen-template.dart)  

---

## 1. Executive Summary & Objective

The `bootstrap_ui_flutter` framework provides a complete, modern design system natively built for Flutter, bringing the full breadth of Bootstrap 5.3 specifications to cross-platform desktop, mobile, and web applications.

This skill establishes the authoritative engineering workflow for authoring screens and reusable widgets using `bootstrap_ui_flutter`. It guarantees that all visual elements derive exclusively from this library and explicitly bans visual widgets from Flutter Material Design (`package:flutter/material.dart`) and Cupertino (`package:flutter/cupertino.dart`). By enforcing a unified component suite, the application achieves seamless responsive adaptation, robust accessibility, and absolute visual parity across all target platforms.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Constructing any presentation view, feature screen, layout body, card, table, or dashboard.
- Implementing user input forms using `BsInput`, `BsSelect`, `BsCheckbox`, `BsRadio`, `BsSwitch`, `BsRange`, or `BsInputGroup`.
- Displaying dialog prompts (`BsModal`), slide-over drawers (`BsOffcanvas`), toasts (`BsToast`), or alerts (`BsAlert`).
- Applying spacing, border, alignment, or typography extensions (`.p3()`, `.m2()`, `.fs4()`, `.fwBold()`, `.rounded()`).
- Refactoring legacy code containing `Scaffold`, `AppBar`, `ElevatedButton`, `TextField`, or Cupertino widgets.

### 2.2. When to Avoid This Skill
- Writing domain repositories, Firestore DTO serialization, or business use cases.
- Configuring dependency injection bindings in `lib/locator.dart`.
- Running headless integration tests without UI inspection.

---

## 3. Pre-Flight Verification (Step 0)

Execute pre-flight checks before authoring or modifying any presentation component:

```bash
# 1. Verify bootstrap_ui_flutter dependency in pubspec.yaml
grep 'bootstrap_ui_flutter' pubspec.yaml

# 2. Check for accidental Material or Cupertino imports in the target file
rg '\b(Scaffold|AppBar|ElevatedButton|CupertinoButton|TextField)\b' lib/presentation/

# 3. Ensure ThemeData provides BsThemeData extensions in lib/theme/
test -f lib/theme/app_theme.dart && echo "Theme system ready."
```

---

## 4. Canonical Specification & Standards

### 4.1. The 30 Core Component Suites

#### 1. Grid & Containers
- `BsContainer`: Root layout wrapper. Always use `BsContainer.fluid(child: ...)` or `BsContainer(type: BsContainerType.fluid, child: ...)` for responsive edge-to-edge layouts.
- `BsRow`: Flexbox row distributing columns along a 12-unit horizontal track with configurable gutters (`gutterX`, `gutterY`) and alignment (`justify`, `alignItems`).
- `BsCol`: Column child spanning fractional track widths specified via `config: BsColConfig(xs: 12, sm: 6, md: 4, lg: 3, xl: 3, xxl: 2)`.

#### 2. Navigation Bar (Replaces `AppBar` and `CupertinoNavigationBar`)
- `BsNavbar`: Universal header bar. Supports `expand: BsNavbarExpand.lg`, `dark: true`, `brand`, and `collapse: BsNavbarCollapse(...)`.
- `BsNavbarBrand` & `BsNavbarIconBrand`: Logo branding with optional network image support (`BsNavbarIconBrand.network`).
- `BsNavbarNav` & `BsNavbarLink`: Navigation link items supporting active (`active: true`) and disabled states.
- `BsNavbarSpacer`: Responsive flex spacer expanding on desktop and collapsing on mobile.
- `BsNavbarToggler` & `BsNavbarCollapse`: Mobile hamburger drawer menu toggled dynamically on small viewports.

#### 3. Buttons & Button Groups (Replaces `ElevatedButton`, `TextButton`, `CupertinoButton`)
- `BsButton`: Primary action control. Properties: `label`, `onPressed`, `variant: BsButtonVariant.primary`, `size: BsButtonSize.md`, `outline: true`, `icon: BsIcons.star`, `isLoading: bool`.
- `BsButtonGroup`: Arranges related buttons in a continuous horizontal or vertical group with merged borders.
- `BsCloseButton`: Standardized dismiss control for modals, alerts, and offcanvas panels (`white: true` for dark backgrounds).

#### 4. Cards & Containers (Replaces `Card`)
- `BsCard`: Structured content container supporting `header: BsCardHeader(child: ...)`, `body: BsCardBody(children: [...])`, and `footer: BsCardFooter(child: ...)`.
- `BsCardImage`: Image caps positioned at `BsCardImagePosition.top`, `bottom`, or `overlay`.
- `BsCardGroup`: Connected series of equal-height cards.

#### 5. Form Input Controls (Replaces `TextFormField`, `DropdownButtonFormField`, `Switch`)
- `BsInput`: Text input field natively integrating with Flutter's `Form` validation. Supports `size: BsInputSize.sm/md/lg`, `placeholder`, `disabled`, `validator`, `floatingLabel`, and `validationState`.
- `BsSelect<T>`: Dropdown selection menu with styled overlay list and keyboard traversal.
- `BsCheckbox`: Checkbox and toggle switch input (`isSwitch: true` for switches) with semantic variant color and label.
- `BsRadio<T>`: Mutually exclusive radio option controls.
- `BsRange`: Slider control for continuous numerical ranges.
- `BsInputGroup`: Prepends or appends addons (`BsInputGroupText`, `BsButton`) to inputs in a unified border box.
- `BsValidatedForm`: Wraps `Form` to show green valid or red invalid borders when `wasValidated: true`.
- `BsFormFeedback`: Contextual validation message display (`valid` and `invalid`).

#### 6. Modals & Dialogs (Replaces `showDialog`, `AlertDialog`, `CupertinoAlertDialog`)
- `BsModal` & `showBsModal`: Overlay dialog prompt.
  - Backdrop behaviors: `BsBackdrop.enabled` (dismissible), `BsBackdrop.static` (animated shake on click-away), `BsBackdrop.disabled`.
  - Sizes: `BsModalSize.sm` (300px), `md` (500px), `lg` (800px), `xl` (1140px), and `fullscreen`.
  - Structural sub-widgets: `BsModalHeader`, `BsModalBody`, `BsModalFooter`. Supports Escape key closing.

#### 7. Offcanvas Sidebars (Replaces `Drawer` and `EndDrawer`)
- `BsOffcanvas` & `showBsOffcanvas`: Sliding drawer panels from `BsOffcanvasPlacement.start`, `end`, `top`, or `bottom`. Ideal for responsive filter panels, shopping carts, and secondary navigation.

#### 8. Navs and Tabs (Replaces `BottomNavigationBar` and `TabBar`)
- `BsNav`: Versatile navigation bar supporting styles: `tabs`, `pills`, or `underline`.
- `BsTabContent` & `BsTabPane`: Tab content manager with smooth fade transitions between active panes.

#### 9. Feedback & Notifications (Replaces `SnackBar` and `Banner`)
- `BsAlert`: Contextual inline notification with variants (`success`, `danger`, `warning`, `info`), optional icon, and `dismissible: true`.
- `BsToast` & `showBsToast`: Desktop-style push notifications with `BsToastHeader`, icon, timestamp, and body message.
- `BsBadge`: Small status labels or count pills with `isPill: true`.

#### 10. Indicators & Loading (Replaces `CircularProgressIndicator` and `LinearProgressIndicator`)
- `BsSpinner`: Lightweight circular loader available as `BsSpinner.border()` or pulsing `BsSpinner.grow()`, with sizes `sm` and `md`.
- `BsProgress` & `BsProgressBar`: Progress bars with optional text labels, striped patterns, and animation.
- `BsPlaceholder` & `BsPlaceholderContainer`: Skeleton loading shimmer placeholders (`BsPlaceholderAnimation.glow` or `wave`).

#### 11. Tables, Lists & Media
- `BsTable`: Complete data table with `BsTableHead`, `BsTableBody`, `BsTableRow`, `BsTableCell`, hover effects, zebra striping, and horizontal scrolling.
- `BsListGroup` & `BsListGroupItem`: Clean lists for items, links, or actions.
- `BsBreadcrumb` & `BsBreadcrumbItem`: Hierarchical breadcrumb navigation trails.
- `BsPagination` & `BsPaginationItem`: Multi-page paging bars (`BsPagination.automatic`).
- `BsImage`: Responsive images with `fluid: true`, `thumbnail: true`, `rounded: true`, or `circle: true`.
- `BsFigure` & `BsFigureCaption`: Semantic HTML5 `<figure>` wrapper.
- `BsCarousel`: Rich media slideshow with indicators, controls, captions, and touch swipe gestures.

#### 12. Tooltips, Popovers & Collapse
- `BsTooltip`: Small floating hover labels positioned `top`, `bottom`, `start`, or `end`.
- `BsPopover`: Rich popups with title and interactive content triggered on click or hover.
- `BsCollapse`: Smooth vertical or horizontal expand/collapse animations.
- `BsScrollspy`: Automatically highlights active navigation links according to viewport scroll offset.

#### 13. Typography & Icons
- `BsHeading`: Semantic heading elements with levels `BsHeadingLevel.h1` through `h6`.
- `BsCode`, `BsKbd`, `BsBlockquote`: Semantic typography elements for code snippets and keyboard commands.
- `BsIcon` & `BsIcons`: Over 2000 native Bootstrap vector icons.

---

### 4.2. Helpers Suite
- `BsVStack(gap: 16, children: [...])`: Vertical layout stack enforcing strict uniform item spacing.
- `BsHStack(gap: 8, children: [...])`: Horizontal layout stack with uniform item spacing.
- `BsRatio(type: BsRatioType.ratio16x9, child: ...)`: Enforces strict aspect ratios (`1x1`, `4x3`, `16x9`, `21x9`).
- `BsVerticalRule`: Thin vertical divider element.
- `BsLink` & `BsIconLink`: Semantic clickable links with hover color changes.
- `Text(...).truncate()`: Extension method truncating long text strings with ellipses.

---

### 4.3. Utility Extensions Suite
The library provides fluent extension methods on widgets for rapid styling:
- **Spacing:** `.p0()` through `.p5()`, `.px()`, `.py()`, `.pt()`, `.pb()`, `.m0()` through `.m5()`, `.mx()`, `.my()`, `.mt()`, `.mb()`. Supports responsive breakpoint thresholds (e.g. `.p3(BsBreakpoints.md)`).
- **Borders & Rounding:** `.border()`, `.border0()`, `.rounded()`, `.roundedPill()`, `.roundedCircle()`.
- **Display & Alignment:** `.dNone(BsBreakpoints.lg)`, `.dBlock()`, `.dFlex()`, `.center()`, `.w100()`, `.h100()`.
- **Text:** `.fs1()` through `.fs6()`, `.fwBold()`, `.textPrimary()`, `.textCenter()`.

---

### 4.4. Theme Access via Context
Access Bootstrap theme colors and typography tokens directly from `BuildContext`:

```dart
final bs = context.bs;
final Color primaryColor = bs.primary;
final Color bodyBg = bs.bodyBg;
final Color bodyTextColor = bs.bodyColor;
```

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Establish Root Screen with BsContainer and BsNavbar
Replace `Scaffold` and `AppBar` with `BsContainer.fluid` and `BsNavbar`:

```dart
import 'package:flutter/widgets.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';

class CompliantScreen extends StatelessWidget {
  const CompliantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BsContainer.fluid(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsNavbar(
            expand: BsNavbarExpand.lg,
            brand: const BsNavbarBrand(child: Text('Logisto System')),
            collapse: BsNavbarCollapse(
              children: [
                BsNavbarNav(
                  children: [
                    BsNavbarLink(
                      label: 'Dashboard',
                      active: true,
                      onPressed: () {},
                    ),
                  ],
                ),
                const BsNavbarSpacer(),
                BsButton(
                  label: 'New Task',
                  icon: BsIcons.plusLg,
                  variant: BsButtonVariant.primary,
                  size: BsButtonSize.sm,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Expanded(child: ResponsiveBody()),
        ],
      ),
    );
  }
}
```

### Step 2: Structure 12-Column Responsive Content (Laptop Priority)
Implement layout bodies using `BsRow` and `BsCol` with explicit `BsColConfig` settings, optimizing for laptop viewports (1280x720+) while adapting across tablets and mobile:

```dart
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: BsRow(
        children: [
          // On laptop (xl: 1280x720+): 8 columns; on tablet: 12 or 8; on mobile: 12
          BsCol(
            config: const BsColConfig(xs: 12, md: 8, xl: 8),
            child: const MainContentCard(),
          ),
          // On laptop (xl: 1280x720+): 4 columns; on tablet: 12 or 4; on mobile: 12
          BsCol(
            config: const BsColConfig(xs: 12, md: 4, xl: 4),
            child: const SideFilterPanel(),
          ),
        ],
      ),
    );
  }
}
```

### Step 3: Implement Reusable Project Controls
Wrap `bootstrap_ui_flutter` components inside project-prefixed controls in `lib/core/widgets/` (`AppButton`, `AppCard`, `AppTextField`, `AppModal`).

---

## 6. Edge Cases & Defensive Invariants

| Failure Scenario | Root Cause | Preventive Invariant |
| :--- | :--- | :--- |
| **Material Scaffold Import** | Copy-pasting boilerplate from online Flutter tutorials. | CI Regex Gate in `RULE-UI-006` blocks PRs containing `Scaffold`. |
| **Ink Ripple Glitches on Desktop** | Using Material `ElevatedButton` on desktop targets. | Use `BsButton`, which renders native desktop-friendly hover states. |
| **Modal Overflow in Landscape** | Fixed modal height exceeding landscape screen height. | Use `scrollable: true` in `BsModal` and wrap modal body in `BsModalBody`. |
| **Drawer Conflict with Native Gestures** | Mobile OS swipe-back conflict with custom drawers. | Use `showBsOffcanvas` with explicit backdrop and close button. |
| **Form Validation Bypassed** | Using uncontrolled text fields without form bindings. | Always wrap inputs in Flutter `Form` and bind `BsInput.validator`. |
| **Dark Mode Inversion Contrast** | Hardcoding `Colors.white` or `Colors.black`. | Always query `context.bs.bodyBg` and `context.bs.bodyColor`. |

---

## 7. Verification & Quality Gates

Run automated audit scripts to ensure zero Material/Cupertino contamination:

```bash
# 1. Verify zero prohibited Material visual widgets in presentation code
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(Scaffold|AppBar|ElevatedButton|TextButton|OutlinedButton|FloatingActionButton|ListTile|AlertDialog|SnackBar|Drawer)\b'

# 2. Verify zero Cupertino visual controls
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(CupertinoButton|CupertinoNavigationBar|CupertinoTabBar|CupertinoActivityIndicator|CupertinoAlertDialog)\b'

# 3. Verify Flutter static analysis passes cleanly
flutter analyze
```


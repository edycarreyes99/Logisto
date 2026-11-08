# Bootstrap UI Flutter Component Quick Reference Catalog

> Standard: Complete API Reference for bootstrap_ui_flutter 0.6.0  
> Source Documentation: https://github.com/Nexus633/bootstrap_ui_flutter/tree/main/doc/en  
> Rule Conformance: RULE-UI-006 (Zero Material, Zero Cupertino), RULE-UI-002 (12-Column Grid)  
> Primary Form Factor Priority: Laptops from 1280x720 upwards  

---

## 1. 30 Core Component Suites

### 1. Grid & Containers
- `BsContainer`: Root layout wrapper.
  - Fluid mode: `BsContainer.fluid(child: ...)` or `BsContainer(type: BsContainerType.fluid, child: ...)` expands to 100% available viewport width.
  - Fixed mode: `BsContainer(type: BsContainerType.fixed, child: ...)` applies max-width breakpoints.
  - Parameters: `child` (required), `type` (`BsContainerType`), `padding` (`EdgeInsets?`).
- `BsRow`: Flexbox row distributing 12 column tracks horizontally.
  - Parameters: `children` (`List<Widget>`), `gutterX` (`double?`), `gutterY` (`double?`), `justify` (`BsRowJustify`), `alignItems` (`BsRowAlignItems`).
- `BsCol`: Column child placed directly within a `BsRow`.
  - Parameters: `child` (`Widget`, required), `config: BsColConfig(xs: 12, sm: 6, md: 4, lg: 3, xl: 3, xxl: 2)`, `offset: BsOffsetConfig(...)`, `alignSelf: BsAlignSelf`.

### 2. Navigation Bar (Replaces `AppBar` and `CupertinoNavigationBar`)
- `BsNavbar`: Responsive navigation header.
  - Parameters: `brand` (`Widget?`), `collapse` (`BsNavbarCollapse?`), `expand` (`BsNavbarExpand.lg` / `.sm` / `.md` / `.xl` / `.xxl` / `.always` / `.never`), `dark` (`bool`), `background` (`Color?`), `padding` (`EdgeInsetsGeometry`).
- `BsNavbarBrand` / `BsNavbarIconBrand`: Branding title or icon/network logo with click callback.
- `BsNavbarNav` & `BsNavbarLink`: Navigation links supporting `active: true` and `disabled: true`.
- `BsNavbarSpacer`: Responsive flex spacer pushing elements apart on desktop and collapsing to shrink on mobile.
- `BsNavbarText`: Paragraph formatting for inline navbar metadata.
- `BsNavbarCollapse`: Collapsible content containing hamburger menu on small viewports and horizontal row on desktop.

### 3. Buttons & Button Groups (Replaces `ElevatedButton`, `TextButton`, `CupertinoButton`)
- `BsButton`: Primary actionable button.
  - Parameters: `label` (`String`), `onPressed` (`VoidCallback?`), `variant` (`BsButtonVariant.primary` / `.secondary` / `.success` / `.danger` / `.warning` / `.info` / `.light` / `.dark`), `size` (`BsButtonSize.sm` / `.md` / `.lg`), `outline` (`bool`), `icon` (`IconData?`), `isLoading` (`bool`), `fullWidth` (`bool`), `badge` (`Widget?`), `badgePosition` (`BsButtonBadgePosition`).
- `BsButtonGroup`: Arranges multiple buttons in a contiguous horizontal or vertical block with shared borders.
- `BsCloseButton`: Universal dismiss icon for dialogs, toasts, cards. Parameters: `white` (`bool`), `disabled` (`bool`), `size` (`double`), `onPressed` (`VoidCallback?`).

### 4. Cards (Replaces Material `Card`)
- `BsCard`: Structured content container.
  - Parameters: `header` (`BsCardHeader?`), `body` (`BsCardBody?`), `footer` (`BsCardFooter?`), `children` (`List<Widget>?`), `image` (`Widget?`), `imagePosition` (`BsCardImagePosition.top` / `.bottom` / `.overlay`), `variant` (`BsVariant?`), `borderVariant` (`BsVariant?`), `onTap` (`VoidCallback?`).
- `BsCardHeader`: Header bar with padding and bottom border. Parameters: `child` (`Widget`), `backgroundColor` (`Color?`).
- `BsCardBody`: Main body wrapper. Parameters: `child` (`Widget?`), `children` (`List<Widget>?`), `padding` (`EdgeInsetsGeometry?`).
- `BsCardFooter`: Footer bar with padding and top border. Parameters: `child` (`Widget`).
- `BsCardGroup`: Connected cluster of cards with uniform heights.

### 5. Form Input Controls (Replaces `TextField`, `TextFormField`, `DropdownButton`, `Switch`)
- `BsInput`: Text input component extending `FormField<String>`.
  - Parameters: `controller`, `placeholder`, `size` (`BsInputSize.sm` / `.md` / `.lg`), `disabled` (`bool`), `readonly` (`bool`), `plainText` (`bool`), `floatingLabel` (`String?`), `validator` (`FormFieldValidator<String>?`), `validationState` (`BsValidationState.valid` / `.invalid`), `obscureText` (`bool`).
- `BsSelect<T>`: Styled dropdown menu extending `FormField<T>`. Parameters: `items` (`List<DropdownMenuItem<T>>`), `placeholder`, `floatingLabel`, `onChanged`.
- `BsCheckbox`: Checkbox and toggle switch extending `FormField<bool>`. Parameters: `label` (`Widget`), `initialValue` (`bool`), `isSwitch` (`bool: true` for `.form-switch`).
- `BsRadio<T>`: Radio button for exclusive groups. Parameters: `value` (`T`), `groupValue` (`T?`), `onChanged` (`ValueChanged<T?>`), `label` (`Widget`).
- `BsRange`: Slider for continuous numerical ranges. Parameters: `initialValue` (`double`), `min` (`double`), `max` (`double`), `onChanged`.
- `BsInputGroup`: Flex container combining text addons, icons, buttons, and inputs seamlessly.
  - Components: `BsInputGroupText('@')`, `BsInput(...).expanded()`, `BsButton(...)`.
- `BsValidatedForm`: Wraps Flutter `Form` with `wasValidated: bool` to trigger green valid / red invalid styling.
- `BsFormFeedback`: Contextual error or success message rendering below fields.

### 6. Modals & Dialogs (Replaces `AlertDialog`, `CupertinoAlertDialog`)
- `showBsModal<T>`: Helper function displaying dialog overlays.
  - Parameters: `context`, `builder` (`WidgetBuilder`), `backdrop` (`BsBackdrop.enabled` / `.static` / `.disabled`), `keyboard` (`bool: true`), `centered` (`bool`).
- `BsModal`: Structured modal dialog.
  - Parameters: `size` (`BsModalSize.sm` (300px), `.md` (500px), `.lg` (800px), `.xl` (1140px), `.fullscreen`), `header` (`BsModalHeader?`), `body` (`Widget: BsModalBody`), `footer` (`BsModalFooter?`), `centered` (`bool`), `scrollable` (`bool`).
- `BsModalHeader`: Header with title and built-in `BsCloseButton`. Parameters: `child` (`Widget`), `showCloseButton` (`bool`), `onClosePressed` (`VoidCallback?`).
- `BsModalBody`: Content container. Parameters: `child` (`Widget`), `padding` (`EdgeInsetsGeometry`).
- `BsModalFooter`: Action buttons container. Parameters: `children` (`List<Widget>`), `alignment` (`MainAxisAlignment.end`).

### 7. Offcanvas Sidebars (Replaces `Drawer` and `EndDrawer`)
- `showBsOffcanvas<T>`: Helper function sliding in side panels.
  - Parameters: `context`, `placement` (`BsOffcanvasPlacement.start` / `.end` / `.top` / `.bottom`), `backdrop` (`BsBackdrop.enabled` / `.static` / `.disabled`), `keyboard` (`bool: true`), `builder` (`WidgetBuilder`).
- `BsOffcanvas`: Offcanvas panel container.
  - Parameters: `header` (`BsOffcanvasHeader?`), `body` (`Widget: BsOffcanvasBody`), `placement`, `width` (`double: 400.0`), `height` (`double: 300.0`), `variant` (`BsOffcanvasVariant?`).
- `BsOffcanvasHeader` & `BsOffcanvasBody`: Structured sub-widgets for sidebar content.

### 8. Navs and Tabs (Replaces `BottomNavigationBar` and `TabBar`)
- `BsNav`: Versatile navigation bar.
  - Parameters: `variant` (`BsNavVariant.tabs` / `.pills` / `.underline` / `.plain`), `vertical` (`bool`), `children` (`List<BsNavLink>`).
- `BsNavLink`: Individual link. Parameters: `label` (`String`), `active` (`bool`), `disabled` (`bool`), `onPressed` (`VoidCallback?`).
- `BsTabContent` & `BsTabPane`: Tab content manager with smooth fade transitions between active panes.

### 9. Feedback & Notifications (Replaces `SnackBar` and `Banner`)
- `BsAlert`: Inline notification banner.
  - Parameters: `child` (`Widget`), `variant` (`BsVariant.primary` / `.success` / `.danger` / `.warning` / `.info`), `icon` (`IconData?`), `dismissible` (`bool`), `onClose` (`VoidCallback?`), `autoCloseDuration` (`Duration?`).
- `BsToast`: Desktop-style push notification card.
  - Parameters: `header` (`BsToastHeader?`), `child` (`Widget`), `variant` (`BsVariant?`).
- `BsToastManager.show(context, toast: BsToast(...), duration: Duration(seconds: 4))`: Global toast manager.
- `BsBadge`: Small status badge or count pill. Parameters: `label` (`String`), `variant` (`BsVariant`), `isPill` (`bool`).

### 10. Indicators & Loading (Replaces `CircularProgressIndicator` and `LinearProgressIndicator`)
- `BsSpinner.border()` / `BsSpinner.grow()`: Circular loading indicator. Parameters: `variant` (`BsVariant?`), `size` (`BsSpinnerSize.sm` / `.md`).
- `BsProgress`: Progress bar track. Parameters: `children` (`List<BsProgressBar>`), `height` (`double: 16.0`).
- `BsProgressBar`: Progress fill. Parameters: `value` (`double: 0.0 to 1.0`), `variant` (`BsVariant`), `striped` (`bool`), `animated` (`bool`), `label` (`Widget?`).
- `BsPlaceholder`: Skeleton loading shimmer. Parameters: `animation` (`BsPlaceholderAnimation.glow` / `.wave`), `child` (`Widget`).

### 11. Tables, Lists & Media
- `BsTable`: Complete styled data table with horizontal scrolling support.
  - Parameters: `head` (`BsTableHead(rows: [...])`), `children` (`List<BsTableRow>`), `foot` (`BsTableFoot?`), `small` (`bool`), `striped` (`bool`), `bordered` (`bool`), `hover` (`bool`).
- `BsListGroup`: Clean list item container.
  - Parameters: `children` (`List<BsListGroupItem>`), `flush` (`bool: true` removes outer borders for cards).
- `BsListGroupItem`: List item supporting `active: bool`, `disabled: bool`, and `onPressed: VoidCallback?`.
- `BsBreadcrumb` & `BsBreadcrumbItem`: Navigational hierarchy trail.
- `BsPagination` & `BsPaginationItem`: Multi-page pagination bar. Use `BsPagination.automatic(currentPage, totalPages, maxVisiblePages, onPageChanged)`.
- `BsCarousel`: Slideshow with autoplay, touch swipe, controls, indicators, captions.
  - Parameters: `items` (`List<BsCarouselItem>`), `autoplay` (`bool`), `defaultInterval` (`Duration`), `controls` (`bool`), `indicators` (`bool`), `fade` (`bool`).
- `BsImage`: Responsive image with `fluid: true`, `thumbnail: true`, `rounded: true`, `circle: true`.
- `BsFigure` & `BsFigureCaption`: HTML5 `<figure>` wrapper pairing image with formatted caption.

### 12. Tooltips, Popovers, Dropdowns & Collapse
- `BsTooltip`: Floating hover/focus label. Parameters: `message` (`String`), `placement` (`BsTooltipPlacement.top` / `.bottom` / `.start` / `.end`), `disabled` (`bool`), `child` (`Widget`).
- `BsPopover`: Rich popover with header title and interactive body. Parameters: `titleText`, `contentText`, `trigger` (`BsPopoverTrigger.click` / `.hover`), `child` (`Widget`).
- `BsDropdown`: Toggleable overlay menu. Parameters: `label` (`String`), `toggleVariant`, `menu: BsDropdownMenu(children: [BsDropdownItem(child: ..., onPressed: ...), BsDropdownDivider()])`.
- `BsAccordion`: Expandable accordion panels. Parameters: `items: [BsAccordionItem(title: '...', body: ..., initiallyExpanded: bool)]`, `alwaysOpen` (`bool`), `flush` (`bool`).
- `BsCollapse`: Smooth programmatic expand/collapse container. Parameters: `isExpanded` (`bool`), `horizontal` (`bool`), `child` (`Widget`).
- `BsScrollspy`: Automatically syncs scroll position with active navigation link. Parameters: `controller: BsScrollspyController()`, `child: SingleChildScrollView(controller: ...)`.

### 13. Typography & Icons
- `BsHeading`: Semantic heading rendering levels `h1` through `h6`. Parameters: `text` (`String`), `level` (`BsHeadingLevel.h1` to `.h6`), `removeMargin` (`bool`), `color` (`Color?`).
- `BsCode`: Monospace code snippet tag.
- `BsKbd`: Dark monospace keyboard shortcut badge.
- `BsBlockquote`: Blockquote callout with optional `footer: Widget`.
- `BsIcon`: High-fidelity vector icon renderer. Parameters: `icon` (`IconData`, e.g. `BsIcons.alarm`), `size` (`double?`), `color` (`Color?`), `variant` (`BsIconVariant?`).

---

## 2. Helpers Catalog

| Helper | Type | Usage |
| :--- | :--- | :--- |
| `BsVStack` | Layout Widget | Vertical flex stack with strict uniform spacing: `BsVStack(gap: 16, children: [...])`. |
| `BsHStack` | Layout Widget | Horizontal flex stack with strict uniform spacing: `BsHStack(gap: 8, children: [...])`. |
| `BsRatio` | Layout Widget | Enforces strict aspect ratio: `BsRatio(type: BsRatioType.ratio16x9, child: ...)`. |
| `BsVerticalRule` | Divider Widget | Thin vertical separator line used inside `BsHStack` or horizontal rows. |
| `BsLink` | Action Widget | Semantic text link with hover animations and Bootstrap variant colors. |
| `BsIconLink` | Action Widget | Semantic link pairing text with an adjacent `BsIcon`. |
| `.truncate()` | Extension | Extension on Flutter `Text` widget to clamp text with an ellipsis. |

---

## 3. Utility Extensions Catalog

### 3.1. Spacing (`BsSpacingExtension`)
- `.p0()` to `.p5()`: Uniform padding (0px, 4px, 8px, 16px, 24px, 48px).
- `.px0()` to `.px5()`: Horizontal padding.
- `.py0()` to `.py5()`: Vertical padding.
- `.pt0()` to `.pt5()`, `.pb0()` to `.pb5()`, `.ps0()` to `.ps5()`, `.pe0()` to `.pe5()`: Directional padding.
- `.m0()` to `.m5()`, `.mx0()` to `.mx5()`, `.my0()` to `.my5()`: Margin levels.
- `.mAuto()`, `.mxAuto()`, `.myAuto()`, `.msAuto()`, `.meAuto()`: Auto margins for flex alignment.
- Custom spacing: `.p(val)`, `.m(val)`. Supports responsive thresholds: `.p3(BsBreakpoints.md)`.

### 3.2. Borders & Rounding (`BsBorderExtension`)
- `.border({color, width})`: Adds 1px border on all sides.
- `.border0()`: Removes all borders.
- `.borderTop()`, `.borderBottom()`, `.borderStart()`, `.borderEnd()`: Directional borders.
- `.borderVariant(context, variant)`: Colors borders using theme variant.
- `.rounded()`, `.rounded0()` to `.rounded5()`: Curvature steps (0px, 4px, 6px, 8px, 16px, 32px).
- `.roundedCircle()`: Circular boundary.
- `.roundedPill()`: Capsule shape.

### 3.3. Display & Visibility (`BsDisplayExtension`)
- `.dNone([breakpoint])`: Hides widget conditionally based on screen breakpoint.
- `.dBlock([breakpoint])`: Displays widget conditionally.
- `.visible(bool)` / `.gone(bool)`: Visibility toggles.
- `.opacity(double)`: Sets opacity.

### 3.4. Alignment (`BsAlignmentExtension` & `BsVerticalAlignExtension`)
- `.center([breakpoint])`: Centers widget conditionally based on breakpoint.
- `.alignStart()`, `.alignEnd()`, `.alignTop()`, `.alignBottom()`: Alignment wrappers.
- `.alignMiddle()`, `.alignBaseline()`, `.alignTopInline()`, `.alignBottomInline()`: Inline rich text vertical alignment.

### 3.5. Sizing (`BsSizeExtension`)
- `.w(double)`, `.h(double)`: Fixed width/height wrappers.
- `.w100()`, `.w75()`, `.w50()`, `.w25()`: Relative width percentages.
- `.h100()`, `.h75()`, `.h50()`, `.h25()`: Relative height percentages.
- `.vw100(context)`, `.vh100(context)`: 100% viewport width and height.
- `.minVw100(context)`, `.minVh100(context)`: Minimum viewport width and height.
- `.expanded([flex])`: Wraps in `Expanded`.

### 3.6. Typography (`BsTextExtension`)
- `.fs1()` to `.fs6()`: Font sizes (40px, 32px, 28px, 24px, 20px, 16px).
- `.display1()` to `.display6()`: Display font sizes (80px to 40px with lighter weight).
- `.fwLight()`, `.fwNormal()`, `.fwMedium()`, `.fwSemibold()`, `.fwBold()`, `.fwBolder()`: Font weights.
- `.fstItalic()`, `.fstNormal()`: Font styles.
- `.lh1()`, `.lhSm()`, `.lhBase()`, `.lhLg()`: Line height steps (1.0, 1.25, 1.5, 2.0).
- `.textStart()`, `.textCenter()`, `.textEnd()`: Text alignment.
- `.textUppercase()`, `.textLowercase()`, `.textCapitalize()`: Text casing.
- `.truncate()`: Single-line ellipsis clamping.

# Material Design 3 and Bootstrap Responsive Grid Reference Catalog

> Standard: Complete API Reference for Material Design 3 & Bootstrap 12-Column Responsive Grid  
> Rule Conformance: RULE-UI-006 (Material 3 Visuals, Bootstrap Grid Only), RULE-UI-002 (12-Column Grid)  
> Primary Form Factor Priority: Laptops from 1280x720 upwards  

---

## 1. Permitted Responsive Grid Engine (From `bootstrap_ui_flutter`)

### 1.1. Grid & Containers
- `BsContainer`: Root layout wrapper.
  - Fluid mode: `BsContainer.fluid(child: ...)` or `BsContainer(fluid: true, child: ...)` expands to 100% available viewport width.
  - Parameters: `child` (`Widget`), `padding` (`EdgeInsetsGeometry?`).
- `BsRow`: Flexbox row distributing 12 column tracks horizontally.
  - Parameters: `children` (`List<Widget>`), `gutterX` (`double?`), `gutterY` (`double?`).
- `BsCol`: Column child placed directly within a `BsRow`.
  - Parameters: `child` (`Widget`, required), `config: BsColConfig(xs: 12, sm: 12, md: 6, lg: 4, xl: 3, xxl: 2)`.
- `BsBreakpoints`: Canonical breakpoint thresholds:
  - `xs`: <576px
  - `sm`: >=576px
  - `md`: >=768px
  - `lg`: >=992px
  - `xl`: >=1200px (Primary Laptop Benchmark: 1280x720+)
  - `xxl`: >=1400px

---

## 2. Permitted Material Design 3 Presentation Catalog

### 2.1. Navigation & App Bars
- `AppBar`: Top navigation bar. Parameters: `title`, `actions`, `leading`, `elevation`.
- `NavigationDrawer` / `Drawer`: Desktop and mobile navigation drawer.
- `NavigationBar`: Mobile bottom navigation bar.
- `NavigationRail`: Vertical desktop/tablet navigation rail.

### 2.2. Buttons & Actions
- `FilledButton`: Primary high-emphasis action button.
- `FilledButton.tonal`: Secondary medium-emphasis button.
- `ElevatedButton`: Surface-elevated button.
- `OutlinedButton`: Medium-emphasis bordered button.
- `TextButton`: Low-emphasis text action button.
- `IconButton`: Compact icon-only button for toolbars.
- `FloatingActionButton`: Prominent floating action trigger.

### 2.3. Cards & Surfaces
- `Card`: Primary content container. Parameters: `elevation`, `shape: RoundedRectangleBorder(...)`, `child`.
- `Card.outlined`: Bordered content container with zero elevation.
- `Card.filled`: Subtle filled container matching `colorScheme.surfaceContainerHighest`.

### 2.4. Form Inputs & Selection
- `TextField`: Primary text input field.
- `TextFormField`: Form-integrated text field supporting `validator`, `controller`, and `onSaved`.
- `DropdownButtonFormField<T>`: Form-integrated dropdown selector.
- `Checkbox` / `CheckboxListTile`: Toggle checkbox control.
- `Radio<T>` / `RadioListTile<T>`: Mutually exclusive radio selection.
- `Switch` / `SwitchListTile`: Toggle switch control.
- `Slider`: Continuous numerical range slider.

### 2.5. Dialogs & Overlays
- `showDialog`: Helper function displaying centered dialog overlays.
- `AlertDialog`: Standard prompt with `title`, `content`, and `actions`.
- `showModalBottomSheet`: Modal bottom sheet overlay for contextual mobile interactions.

### 2.6. Feedback & Indicators
- `SnackBar`: Toast notification displayed via `ScaffoldMessenger.of(context).showSnackBar`.
- `MaterialBanner`: Top notification banner.
- `CircularProgressIndicator`: Circular indeterminate loading spinner.
- `LinearProgressIndicator`: Horizontal progress indicator.
- `Badge`: Status or count indicator badge.
- `Chip` / `FilterChip` / `ActionChip`: Compact semantic tags.

### 2.7. Tables & Lists
- `DataTable` / `PaginatedDataTable`: Enterprise data tables for desktop and laptop viewports.
- `ListTile`: Standardized single-row representation with `leading`, `title`, `subtitle`, and `trailing`.
- `ListView`: Scrolling vertical list of tiles or cards.

---

## 3. Strictly Prohibited Visual Widgets

| Category | Prohibited Bootstrap UI Component | Prohibited Cupertino Component |
| :--- | :--- | :--- |
| Containers & Headers | `BsNavbar`, `BsCard`, `BsCardHeader`, `BsCardBody` | `CupertinoNavigationBar`, `CupertinoTabBar` |
| Buttons | `BsButton`, `BsButtonGroup`, `BsCloseButton` | `CupertinoButton` |
| Inputs | `BsInput`, `BsSelect`, `BsCheckbox`, `BsRadio`, `BsSwitch` | `CupertinoTextField`, `CupertinoSwitch`, `CupertinoSlider` |
| Dialogs | `BsModal`, `showBsModal`, `BsOffcanvas`, `showBsOffcanvas` | `CupertinoAlertDialog`, `CupertinoActionSheet` |
| Feedback & Loading | `BsBadge`, `BsAlert`, `BsToast`, `BsSpinner`, `BsProgress` | `CupertinoActivityIndicator` |
| Tables & Lists | `BsTable`, `BsListGroup`, `BsListGroupItem`, `BsAccordion` | None |

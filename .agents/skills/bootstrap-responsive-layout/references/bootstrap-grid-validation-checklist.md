# Bootstrap Responsive Grid Layout Validation Checklist

> Standard: 12-Column Responsive Layout Architecture via `bootstrap_ui_flutter`  
> Governed Rules: [../../../rules/rule-bootstrap-responsive-grid.md](../../../rules/rule-bootstrap-responsive-grid.md), [../../../rules/rule-short-decomposed-widgets.md](../../../rules/rule-short-decomposed-widgets.md)  
> Scope: lib/presentation/**, lib/core/widgets/**  

---

## 1. Grid Engine & Standard Breakpoint Rules
- [ ] All responsive screens and layout containers use `bootstrap_ui_flutter` components (`BsContainer`, `BsRow`, `BsCol`, `ColSize`).
- [ ] Layout columns strictly adhere to standard Bootstrap 5.3 breakpoint categories:
  - `xs` (<576px): Mobile portrait. Single-column full-width layout (`xs: 12`).
  - `sm` (>=576px): Mobile landscape / small phablets (`sm: 6` for 2 items per row).
  - `md` (>=768px): Tablets. Split view layouts (`md: 6` for dual columns, `md: 4` for 3-card grids).
  - `lg` (>=992px): Laptops / desktop displays (`lg: 3` sidebar, `lg: 9` main content; `lg: 4` for 3-column grids).
  - `xl` (>=1200px): Large desktop monitors (`xl: 3` for 4-column item grids).
  - `xxl` (>=1400px): Ultra-wide monitors (`xxl: 2` or `xxl: 3` with maximum bounded container constraints).
- [ ] Zero manual `MediaQuery.of(context).size.width` arithmetic or arbitrary `if (width > 600)` branching for layout structures.

## 2. Container Bounding & Safe Area Adaptation
- [ ] Root views wrap content inside `BsContainer` with fluid or bounded responsive configurations.
- [ ] Containers respect device `SafeArea` (notch, home indicator, status bar) on mobile and desktop window chrome.
- [ ] Horizontal gutters and row margins prevent card clipping and horizontal scrollbars.
- [ ] Nested `BsRow` components declare explicit horizontal and vertical gutter spacing (`gutter: AppSpacing.md`).

## 3. Column Sizing Integrity & Wrapping
- [ ] Total column spans per row logically evaluate to 12 or wrap cleanly into consecutive rows.
- [ ] Individual `BsCol` components wrap cards or decomposed sub-widgets cleanly without intrinsic height conflicts.
- [ ] Dynamic lists utilize `BsRow` with mapped `BsCol` children or responsive grid builders.
- [ ] Layouts adapt smoothly when resized interactively in desktop windows or web browsers.

## 4. Sub-Widget Decomposition & Nesting Limits
- [ ] Individual column items are extracted into dedicated sub-widgets in `presentation/[feature]/widgets/`.
- [ ] Nesting depth inside any column build tree does not exceed 3 levels (`RULE-UI-001`).
- [ ] Grid items implement flexible or constrained sizing rather than hardcoded fixed pixel widths.

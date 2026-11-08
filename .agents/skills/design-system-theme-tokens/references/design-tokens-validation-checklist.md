# Design System Tokens & Dual-Theme Architecture Validation Checklist

> Standard: Adaptive Dual-Theme System (Light & Dark) and Semantic Token Hierarchy  
> Governed Rules: [../../../rules/rule-adaptive-dual-theme.md](../../../rules/rule-adaptive-dual-theme.md), [../../../rules/rule-project-prefixed-components.md](../../../rules/rule-project-prefixed-components.md)  
> Scope: lib/theme/**, lib/presentation/**, lib/core/widgets/**  

---

## 1. Modular Design System Architecture
- [ ] Design system tokens are strictly segregated into 5 modular files in `lib/theme/`:
  - `app_colors.dart`: Adaptive Light and Dark palettes, semantic tokens, and dynamic context helpers.
  - `app_dimens.dart`: Component heights, icon dimensions, radius constants, and Bootstrap breakpoint bounds.
  - `app_spacing.dart`: Standard 8px modular spacing rhythm scale (`xxs` 2px, `xs` 4px, `sm` 8px, `md` 16px, `lg` 24px, `xl` 32px, `xxl` 48px).
  - `app_text_styles.dart`: Adaptive typography hierarchy (Display, Title, Body, Label) with brightness scaling.
  - `app_theme.dart`: ThemeData assembly for `lightTheme()` and `darkTheme()` with `BsThemeData` extensions.

## 2. Adaptive Dual-Theme Support (Light & Dark Parity)
- [ ] The app provides complete, pixel-perfect rendering in both Light and Dark themes.
- [ ] Root `MaterialApp` configures `theme: AppTheme.lightTheme()` and `darkTheme: AppTheme.darkTheme()`.
- [ ] `themeMode` is driven reactively by `ThemeProvider` consuming `ThemeModeEnum` (`light`, `dark`, `system`).
- [ ] Zero hardcoded hex literals (`Color(0xFF...)`) or bare `Colors.white` / `Colors.black` in UI widgets or screens.
- [ ] All colors resolve dynamically through context helpers (e.g., `AppColors.surfaceOf(context)`, `AppColors.textPrimaryOf(context)`).
- [ ] `BsThemeData.lightTheme` and `BsThemeData.darkTheme` are registered in ThemeData extensions for Bootstrap widgets.

## 3. Accessibility & Contrast Ratios
- [ ] Text contrast ratios satisfy WCAG 2.1 AA standards (minimum 4.5:1 for body text, 3:1 for large display titles) in both themes.
- [ ] Disabled elements maintain distinguishable visual contrast without appearing entirely invisible.
- [ ] Interactive icons and tap targets maintain minimum 48x48 pixel hit-boxes (`AppDimens.minTouchTarget`).
- [ ] Semantic feedback states (success, warning, error, info) remain visually distinct in both light and dark backgrounds.

## 4. Spacing Rhythm & Typography Consistency
- [ ] All margins, paddings, and component separations use `AppSpacing` tokens; zero arbitrary pixel numbers (e.g., `13.5px`).
- [ ] Border radius values use standardized tokens from `AppDimens` (`radiusSm`, `radiusMd`, `radiusLg`).
- [ ] Typography uses `AppTextStyles` hierarchy; zero un-themed inline `TextStyle()` declarations with arbitrary fonts.
- [ ] Font scaling respects user accessibility text scale preferences without clipping.

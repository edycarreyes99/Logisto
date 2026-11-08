# Feature Module Architecture & Scaffolding Validation Checklist

> Standard: Clean Architecture Feature Module Standard & Short Decomposed Widgets  
> Governed Rules: [../../../rules/rule-layered-architecture-flow.md](../../../rules/rule-layered-architecture-flow.md), [../../../rules/rule-short-decomposed-widgets.md](../../../rules/rule-short-decomposed-widgets.md), [../../../rules/rule-project-prefixed-components.md](../../../rules/rule-project-prefixed-components.md)  
> Scope: lib/presentation/[feature]/**, lib/domain/**  

---

## 1. Feature Module Folder Hierarchy
- [ ] Feature modules reside strictly in `lib/presentation/[feature_name]/`.
- [ ] The module contains:
  - `[feature]_screen.dart`: Primary UI Screen.
  - `[feature]_provider.dart`: Catalog state controller (`ChangeNotifier`).
  - `[feature]_form_provider.dart`: Form state controller (if mutations are present).
  - `widgets/`: Decomposed private sub-widgets.
    - `[feature]_header.dart`: Title, search, action controls.
    - `[feature]_grid.dart`: 12-column responsive Bootstrap grid.
    - `[feature]_grid_item.dart`: Single responsive item card.
    - `[feature]_empty_view.dart`: Localized empty state placeholder.
- [ ] Feature-specific display models reside in `presentation/[feature]/models/` or pure Domain models in `lib/domain/models/`.

## 2. Short & Decomposed Widget Architecture Standard
- [ ] Every widget `build` method is strictly 40 lines of code or fewer (`RULE-UI-001`).
- [ ] Widget tree nesting depth does not exceed 3 levels within any single build method.
- [ ] Complex child trees are extracted into single-responsibility sub-widgets in the feature's `widgets/` folder.
- [ ] Zero monolithic screen classes exceeding 200 total lines of code.

## 3. Project-Prefixed Reusable Components
- [ ] All UI controls use project-prefixed components from `lib/core/widgets/`:
  - `AppButton` instead of bare `ElevatedButton`, `TextButton`, `OutlinedButton`.
  - `AppTextField` instead of bare `TextField` or `TextFormField`.
  - `AppCard` instead of bare `Card`.
  - `AppSearchBar` for query filtering.
  - `AppBadge` for status chips.
  - `AppModal` for dialogs and alerts.
  - `AppEmptyState` for zero-data states.
  - `AppLoadingIndicator` for loading spinners.
- [ ] Direct use of bare Flutter buttons or inputs in feature screens is strictly banned (`RULE-UI-003`).

## 4. Layer Separation & Domain Purity
- [ ] Feature screens and widgets NEVER import `cloud_firestore` or database DTOs.
- [ ] All user interactions dispatch through `FeatureProvider` or `DomainService`.
- [ ] Domain models in `lib/domain/models/` have zero Flutter UI widget dependencies.

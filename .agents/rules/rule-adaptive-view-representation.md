---
id: RULE-UI-007
title: Adaptive View Representation - Desktop Data Tables versus Mobile-Tablet Card Lists
trigger: "Triggered when rendering catalog collections, entity lists, data grids, or detail screens across desktop, tablet, and mobile platforms."
category: presentation
severity: blocking
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/widgets/**"
  exclude:
    - "test/**"
---

# Adaptive View Representation - Desktop Data Tables versus Mobile-Tablet Card Lists

> Rule ID: RULE-UI-007  
> Severity: blocking  
> Target Scope: lib/presentation/**, lib/core/widgets/**  
> Category: presentation  

---

## 1. Architectural Invariant

All catalog, telemetry, document, and entity data views in this repository MUST provide adaptive representation tailored to the user device form factor and screen breakpoint:

1. **Desktop & Laptop Viewports (Breakpoints `lg`, `xl`, `xxl` - Width >= 992px):**
   - MUST render high-density tabular presentation using Flutter Material Design 3 `DataTable` or `Table` within a `Card` (`Card.outlined` or `Card.filled`).
   - Tabular layouts MUST feature structured column headers (`DataColumn`), text alignment (left for descriptions, right for numeric values, center for statuses/actions), status indicators (`Chip` or `Badge`), and compact action button groups (`FilledButton.tonal`, `OutlinedButton`, or `IconButton`).
   - Pagination controls MUST provide explicit page navigation (previous/next page, page size selection, record count).

2. **Tablet Viewports (Breakpoint `md` - Width 768px to 991px):**
   - MUST render a responsive 2-column card grid (`BsRow` with `BsCol(config: BsColConfig(xs: 12, md: 6))`) utilizing Material Design 3 `Card` widgets.
   - Cards display structured metadata, `Chip` status indicators, and touch-friendly action buttons.

3. **Mobile Handset Viewports (Breakpoints `xs`, `sm` - Width < 768px):**
   - MUST render touch-optimized Material 3 card stacks (`Card`) or list views (`ListView` with `ListTile`).
   - Touch targets MUST meet or exceed the 48x48 pixel minimum accessibility threshold.
   - List items MUST prioritize primary title, inline status chip/badge, 2-line secondary metadata summary, and trailing action/chevron navigation.
   - Pagination MUST support smooth continuous scroll (`fetchMore()` near scroll end) with Material 3 `CircularProgressIndicator` loading affordance.

4. **Headless Data Decoupling:**
   - Presentation views MUST decouple data querying from visual rendering using headless controllers or builders (such as `FirestoreQueryBuilder` from `firebase_ui_firestore`).
   - The query controller MUST supply items, pagination cursors, loading states, and error handling identically across desktop `DataTable`, tablet `Card` grid, and mobile `ListTile`/`Card` adapters.

5. **Standard Breakpoint Adaptation:**
   - Adaptive switching MUST derive from standard Bootstrap breakpoints (`BsBreakpoints.lg = 992.0`, `BsBreakpoints.md = 768.0`) evaluated via `LayoutBuilder(builder: (context, constraints) => ...)` or responsive `BsRow`/`BsCol` grid layout.
   - Direct ad-hoc arithmetic (`if (MediaQuery.of(context).size.width > 600)`) is strictly prohibited.

---

## 2. Rationale & Failure Impact

- **Ergonomics & Information Density:** Enterprise desktop users operating on laptop displays (1280x720+) and widescreen monitors require high information density, scan-friendly row alignment, and batch comparison capabilities. Displaying mobile-style single-column card stacks on desktop forces excessive vertical scrolling and leaves 70% of widescreen displays unused.
- **Mobile Usability & Touch Target Safety:** Forcing multi-column data tables onto mobile phone screens introduces horizontal scroll fatigue, clipped column contents, and unclickable micro-buttons.
- **Material 3 Visual Harmony:** Using Flutter Material Design 3 components ensures cohesive elevation, typography, color scheme tokens, and interactive ripple feedback across all adaptive views.
- **Failure Impact:** Inflexible layouts lead to `RenderFlex` overflow errors, broken desktop ergonomics, illegible mobile interfaces, and failure to meet enterprise UI/UX design standards.

---

## 3. Compliant Pattern (DO)

Implement an adaptive view that switches between Material 3 `DataTable` and `ListTile` card lists based on the active Bootstrap breakpoint, powered by `FirestoreQueryBuilder`:

```dart
// lib/presentation/catalog/widgets/adaptive_catalog_view.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import '../../../domain/models/catalog_item_model.dart';

class AdaptiveCatalogView extends StatelessWidget {
  final Query<CatalogItemModel> query;
  final ValueChanged<CatalogItemModel> onItemTap;

  const AdaptiveCatalogView({
    super.key,
    required this.query,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<CatalogItemModel>(
      query: query,
      pageSize: 20,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching && snapshot.docs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width >= BsBreakpoints.lg) {
              return _buildDesktopTable(context, snapshot);
            }
            if (width >= BsBreakpoints.md) {
              return _buildTabletGrid(context, snapshot);
            }
            return _buildMobileList(context, snapshot);
          },
        );
      },
    );
  }

  Widget _buildDesktopTable(BuildContext context, FirestoreQueryBuilderSnapshot<CatalogItemModel> snapshot) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: snapshot.docs.map((doc) {
            final item = doc.data();
            return DataRow(
              cells: [
                DataCell(Text(item.name)),
                DataCell(Text(item.category)),
                DataCell(Chip(label: Text(item.statusName))),
                DataCell(
                  OutlinedButton(
                    onPressed: () => onItemTap(item),
                    child: const Text('View'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabletGrid(BuildContext context, FirestoreQueryBuilderSnapshot<CatalogItemModel> snapshot) {
    return BsRow(
      children: snapshot.docs.map((doc) {
        final item = doc.data();
        return BsCol(
          config: const BsColConfig(xs: 12, md: 6),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(item.category),
                    const SizedBox(height: 8),
                    Chip(label: Text(item.statusName)),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => onItemTap(item),
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileList(BuildContext context, FirestoreQueryBuilderSnapshot<CatalogItemModel> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final item = snapshot.docs[index].data();
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.category),
            trailing: Chip(label: Text(item.statusName)),
            onTap: () => onItemTap(item),
          ),
        );
      },
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Rendering fixed-width data tables on mobile or non-responsive cards on desktop:

```dart
// PROHIBITED: Hardcoding a single representation regardless of viewport size
class BadCatalogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // VIOLATION: Hardcoded table forces horizontal scrolling on mobile phones!
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [...], // 10 columns unreadable on mobile screens
        rows: [...],
      ),
    );
  }
}
```

```dart
// PROHIBITED: Manual MediaQuery width branching
if (MediaQuery.of(context).size.width > 700) { ... }
```

---

## 5. Automated Validation & Audit Procedure

Verify that presentation views implement adaptive representation and contain zero manual width checks:

```bash
# 1. Audit presentation code for manual width checks
! rg --glob 'lib/presentation/**' 'MediaQuery\.of\(context\)\.size\.width'

# 2. Verify that responsive tests assert both mobile (320px) and laptop (1280px) viewports
rg --glob 'test/presentation/responsive/**' 'laptop_primary_720'

# 3. Run responsive verification suite
flutter test test/presentation/responsive/
```

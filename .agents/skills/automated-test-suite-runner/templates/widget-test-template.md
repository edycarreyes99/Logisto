# Canonical Widget Test Suite Template

> Scope: test/widget/[feature]/[widget]_test.dart  
> Rules Enforced: [../../../rules/rule-test-coverage-enforcement.md](../../../rules/rule-test-coverage-enforcement.md), [../../../rules/rule-short-decomposed-widgets.md](../../../rules/rule-short-decomposed-widgets.md)  

---

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:climatica/core/enums/language_enum.dart';
import 'package:climatica/core/widgets/app_button.dart';
import 'package:climatica/l10n/app_localizations.dart';
import 'package:climatica/theme/app_theme.dart';

Widget buildTestHarness({
  required Widget child,
  ThemeData? theme,
  Locale? locale,
  List<ChangeNotifierProvider>? providers,
}) {
  Widget widget = MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme ?? AppTheme.lightTheme(),
    darkTheme: AppTheme.darkTheme(),
    locale: locale ?? const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: LanguageEnum.values.map((lang) => lang.locale).toList(),
    home: Scaffold(body: child),
  );

  if (providers != null && providers.isNotEmpty) {
    widget = MultiProvider(
      providers: providers,
      child: widget,
    );
  }

  return widget;
}

void main() {
  group('DecomposedWidget Under Test', () {
    testWidgets('renders expected components in normal state', (tester) async {
      await tester.pumpWidget(
        buildTestHarness(
          child: const TargetWidget(title: 'Overview'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('displays empty state placeholder when collection is empty', (tester) async {
      await tester.pumpWidget(
        buildTestHarness(
          child: const TargetWidget(items: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_state_view')), findsOneWidget);
    });

    testWidgets('handles interactive button tap with callback execution', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        buildTestHarness(
          child: TargetWidget(
            onActionPressed: () => actionTriggered = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });
  });
}
```

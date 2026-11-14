/// Modular spacing scale enforcing an 8px base rhythm with fine-tuning micro-steps.
/// Conforms to RULE-UI-004.
class AppSpacing {
  AppSpacing._();

  // Modular Rhythm Scale
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Form Fields Metrics
  static const double textFieldLabelSpacing = 6.0;
  static const double textFieldVerticalPadding = 10.0;
  static const double textFieldHorizontalPadding = 14.0;
  static const double textFieldBorderRadius = 8.0;

  // Lists and Cards
  static const double cardPadding = 16.0;
  static const double cardBorderRadius = 12.0;

  // Dialogs and Modals
  static const double modalBorderRadius = 16.0;
  static const double modalHorizontalPadding = 20.0;
  static const double modalVerticalPadding = 20.0;
}

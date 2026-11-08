/// Modular spacing scale enforcing an 8px base rhythm with fine-tuning micro-steps.
class AppSpacing {
  // Modular Rhythm Scale
  static const double xxs = 6.0;   // Micro spacing: badge padding, input label gap
  static const double xs  = 8.0;   // Compact spacing: inline gaps, button icon separation
  static const double sm  = 16.0;  // Standard spacing: space between cards / list items
  static const double md  = 24.0;  // Section spacing: gap between major form sections
  static const double lg  = 32.0;  // Macro spacing: separation between major view blocks
  static const double xl  = 40.0;  // Hero spacing: top padding on onboarding/auth views
  static const double xxl = 48.0;  // Maximum breathing space

  // Form Fields Metrics
  static const double textFieldLabelSpacing = 6.0;
  static const double textFieldVerticalPadding = 12.0;
  static const double textFieldHorizontalPadding = 16.0;
  static const double textFieldBorderRadius = 10.0;
  static const double textFieldsHeight = 50.0;

  // Dropdowns and Selectors
  static const double dropdownLabelSpacing = 6.0;
  static const double dropdownVerticalPadding = 12.0;
  static const double dropdownHorizontalPadding = 16.0;
  static const double dropdownBorderRadius = 10.0;

  // Lists and Cards
  static const double listViewHorizontalPadding = 16.0;
  static const double listViewVerticalPadding = 16.0;
  static const double cardBorderRadius = 12.0;

  // Dialogs and Modals
  static const double modalWidth = 360.0;
  static const double modalMaxWidth = 420.0;
  static const double modalMaxHeight = 620.0;
  static const double modalBorderRadius = 24.0;
  static const double modalHorizontalPadding = 20.0;
  static const double modalVerticalPadding = 24.0;
}

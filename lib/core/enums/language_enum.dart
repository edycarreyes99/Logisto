/// Strongly-typed supported application languages.
enum LanguageEnum {
  /// English language bundle.
  en(code: 'en'),

  /// Spanish language bundle.
  es(code: 'es');

  /// Standard ISO 639-1 two-letter language code.
  final String code;

  const LanguageEnum({required this.code});

  /// Resolves [LanguageEnum] from [code] with fallback to Spanish.
  static LanguageEnum fromCode(String? code) {
    return LanguageEnum.values.firstWhere(
      (element) => element.code == code,
      orElse: () => LanguageEnum.es,
    );
  }
}

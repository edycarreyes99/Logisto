---
id: RULE-CODE-001
title: English Code and Enterprise Dart Doc Standards
category: quality
severity: blocking
scope:
  include:
    - "lib/**"
    - "tool/**"
  exclude:
    - "test/**"
---

# English Code and Enterprise Dart Doc Standards

> Rule ID: RULE-CODE-001  
> Severity: blocking  
> Target Scope: lib/**, tool/**  
> Category: quality  

---

## 1. Architectural Invariant

All source code, identifiers, types, classes, functions, variables, file names, commit messages, and comments MUST be authored 100% in professional technical English.

Every public class, enum, method, property, constructor, and parameter MUST include comprehensive `///` Dart Doc comments explaining its purpose, parameters, return value, and potential exceptions.

Under no circumstances shall:
1. Identifiers, method names, comments, or variable names use Spanish or other non-English languages (Spanish text belongs strictly inside `lib/l10n/app_es.arb`).
2. Public APIs be committed without `///` doc comments.
3. Code comments contain emojis, slang, or ambiguous colloquialisms.

---

## 2. Rationale & Failure Impact

- **Global Collaboration & Standards:** Enterprise Flutter codebases operate across international teams, automated AI tools, and static documentation generators. Standardizing on English prevents translation friction.
- **Self-Documenting Code:** Complete `///` doc comments generate rich API documentation (`dart doc`) and enable IDE hover tooltips for faster developer onboarding.
- **Failure Impact:** Mixed-language codebases degrade readability, confuse static analysis tools, cause indexing errors in AI coding agents, and violate enterprise compliance requirements.

---

## 3. Compliant Pattern (DO)

Clean English naming conventions with thorough Dart Doc comments:

```dart
/// Represents an environmental sensor device registered in a weather station.
///
/// Encapsulates hardware identifier, operational telemetry, and reporting cadence.
class WeatherSensorModel {
  /// Unique alphanumeric hardware serial identifier.
  final String serialNumber;

  /// Human-readable sensor location tag (e.g., "North Field Canopy").
  final String locationTag;

  /// Creates a [WeatherSensorModel] instance with immutable properties.
  ///
  /// - [serialNumber]: Hardware UUID or manufacturer serial.
  /// - [locationTag]: Descriptive deployment location.
  const WeatherSensorModel({
    required this.serialNumber,
    required this.locationTag,
  });

  /// Evaluates whether the sensor requires battery replacement or maintenance.
  ///
  /// Returns `true` if battery level drops below 15 percent; otherwise `false`.
  bool requiresMaintenance(double batteryPercentage) {
    return batteryPercentage < 15.0;
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Non-English identifiers, missing doc comments, or Spanish code comments:

```dart
// BAD: Spanish identifiers and missing doc comments
class EstacionClimatica { // VIOLATION: Non-English class identifier!
  final String nombre;    // VIOLATION: Non-English field identifier!

  EstacionClimatica(this.nombre);

  // VIOLATION: Spanish comment and missing Dart Doc /// documentation!
  // Esta funcion calcula la temperatura promedio
  double calcularTemp(List<double> valores) {
    return valores.reduce((a, b) => a + b) / valores.length;
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Verify public documentation coverage and absence of common non-English keywords in code:

```bash
# 1. Run dart doc verification
dart doc --validate-links

# 2. Audit for non-English keywords in Dart files
rg --glob 'lib/**.dart' '\b(funcion|calcular|estacion|usuario|guardar|eliminar)\b'
```

Expected output: 0 matches for non-English terms, and clean doc compilation with 0 warnings.

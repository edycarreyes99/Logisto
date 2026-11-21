---
id: RULE-DATA-006
title: Absolute Prohibition of Mock Data in Production Code
trigger: "Triggered when authoring production code, models, repositories, providers, or screens to ensure zero hardcoded fake or mock data enters production."
category: data
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
    - "integration_test/**"
---

# Absolute Prohibition of Mock Data in Production Code

> Rule ID: RULE-DATA-006  
> Severity: blocking  
> Target Scope: lib/**  
> Category: data  

---

## 1. Architectural Invariant

All production code located under `lib/` MUST exclusively interact with authentic backend repositories, live cloud services, native hardware channels, or empty state handlers.

Under no circumstances shall:
1. Hardcoded, dummy, fake, or mock records (e.g., sample invoices, dummy products, fake shifts, mocked customer lists) exist within providers, controllers, domain models, or presentation widgets under `lib/`.
2. Fallback bypasses with hardcoded credentials or PINs (e.g., `pin == '9999' || pin == '1234'`) exist in production authentication or supervisor approval flows.
3. Dummy mock identifiers (e.g., `RUC: J00000000`, `barcode: '00000000'`) be embedded into UI screens or PDF generation templates as simulated data.
4. Mock repositories, synthetic seed injectors, or database seeders be automatically triggered or executed in production startup flows under `lib/`.
5. Mock repositories or fake data generators be instantiated or imported in `lib/`.

All mocks, fakes, fixtures, seeders, and synthetic test datasets belong strictly and exclusively under `test/` or `integration_test/`.

---

## 2. Rationale & Failure Impact

- **Production Integrity:** Hardcoded mock arrays in providers or widgets masquerade as live system functionality, causing silent state synchronization failures, false audit reports, and severe multi-tenant contamination.
- **Security Vulnerability:** Mock PIN or credential bypasses in production screens create direct backdoors in terminal security, supervisor authorizations, and role-based access control (RBAC).
- **User Confusion:** Mock entities appearing in real production catalogs mislead enterprise users, skew financial reports, and corrupt business metrics.

---

## 3. Compliant Pattern (DO)

Providers must fetch from registered repositories and present authentic data or clean empty states:

```dart
// Compliant: Provider queries registered domain repositories via locator
class ReportsProvider extends ChangeNotifier {
  final InvoiceRepository invoiceRepo;
  final ProductRepository productRepo;

  ReportsProvider({
    required this.invoiceRepo,
    required this.productRepo,
  });

  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  Future<void> loadReports() async {
    _invoices = await invoiceRepo.getInvoicesByDateRange(...);
    notifyListeners();
  }
}
```

Mocks are defined strictly inside the test suite:

```dart
// test/mocks/mock_invoice_repository.dart
class MockInvoiceRepository extends Mock implements InvoiceRepository {}
```

---

## 4. Prohibited Pattern (DO NOT)

```dart
// FORBIDDEN under RULE-DATA-006: In-memory mock entities in production code
class ReportsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _mockProducts = [
    {'name': 'Cerveza Toña', 'sales': 120},
    {'name': 'Ron Flor de Caña', 'sales': 45},
  ];
}

// FORBIDDEN under RULE-DATA-006: Hardcoded bypass credentials
bool isAuthorized(String pin) {
  return pin == '9999' || pin == '1234'; // VIOLATION!
}
```

---

## 5. Verification & Auditing Checklist

- [ ] Zero static dummy lists or maps simulating business entities exist in `lib/`.
- [ ] No hardcoded PINs or bypass passwords exist in production authorization dialogs.
- [ ] All mock classes and fixtures are isolated in `test/`.
- [ ] Screens and providers handle genuine empty collections gracefully with localized empty states.

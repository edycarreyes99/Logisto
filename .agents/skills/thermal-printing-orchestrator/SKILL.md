---
name: thermal-printing-orchestrator
description: |
  Procedural guide for configuring cross-platform receipt printing, hardware discovery,
  PDF voucher layout generation, and peripheral management (USB/Bluetooth/Network).
  Enforces 80mm thermal, 58mm mobile, and dot-matrix continuous format compliance.
  Mandatory trigger conditions:
  - Trigger when generating PDF receipt vouchers, sales tickets, or test prints.
  - Trigger when discovering, pairing, or persisting Bluetooth or USB receipt printers.
  - Trigger when managing printer settings, friendly aliases, or auto-print configurations.
  Do NOT trigger when:
  - Do not trigger for standard non-printing UI layouts or forms.
  - Do not trigger for raw database collection or DTO creation without printing requirements.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Thermal Printing Orchestrator Workflow

> Standard: Universal Cross-Platform Thermal & Matrix Printing  
> Scope: lib/domain/services/printer_service.dart, lib/presentation/settings/widgets/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes receipt printing across macOS, Windows, Linux, Android, iOS, and Web. It governs the rendering of compact PDF invoice vouchers tailored to thermal receipt widths (80mm and 58mm) and dot-matrix continuous stationery, native hardware discovery (USB and Bluetooth), persistent printer pairing via SharedPreferences, customizable hardware aliases, and automated dispatch upon sale checkout.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Designing or adjusting receipt layouts (`ReceiptService`, `InvoicePdfService`).
- Scanning, discovering, or connecting to nearby Bluetooth or USB POS printers.
- Storing or updating friendly printer aliases and MAC addresses.
- Implementing automatic receipt printing on sale finalization in POS.
- Auditing printer management widgets for decomposed sub-widgets.

### 2.2. When to Avoid This Skill
- Generating general non-receipt business reports (A4/Letter PDF reports).
- Implementing Firebase Authentication or user profiles.
- Pure database queries without hardware or voucher integration.

---

## 3. Pre-Flight Verification (Step 0)

Verify printing dependencies and platform permissions are configured:

```bash
# 1. Verify pdf and printing dependencies in pubspec.yaml
grep -E "pdf:|printing:" pubspec.yaml

# 2. Check Android Bluetooth permissions in AndroidManifest.xml
grep -E "BLUETOOTH|BLUETOOTH_SCAN|BLUETOOTH_CONNECT" android/app/src/main/AndroidManifest.xml
```

---

## 4. Canonical Specification & Standards

### 4.1. Dependencies
- `pdf: ^3.11.1`
- `printing: ^5.13.2`

### 4.2. Core Domain Models & Enums
- `PrinterDeviceModel` (`id`, `name`, `customAlias`, `macAddress`, `type`, `connectionType`, `isDefault`).
- `PrinterTypeEnum` (`thermal80`, `thermal58`, `dotMatrix`).
- `PrinterConnectionTypeEnum` (`usb`, `bluetooth`, `network`).

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Voucher Generation (PDF Thermal Page Format)
When building thermal receipts, wrap PDF pages with exact roll widths:
- 80mm roll: `PdfPageFormat.roll80`
- 58mm roll: `PdfPageFormat.roll57`
- Set margins to minimal bounds (e.g., 2-4 mm) to prevent clipping.

```dart
final doc = pw.Document();
doc.addPage(
  pw.Page(
    pageFormat: printerType == PrinterTypeEnum.thermal58
        ? PdfPageFormat.roll57
        : PdfPageFormat.roll80,
    build: (pw.Context context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(organizationName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          // Line items table
        ],
      );
    },
  ),
);
```

### Step 2: Printer Discovery & Pairing
Query the printing subsystem for available system and Bluetooth printers:

```dart
final printers = await Printing.listPrinters();
final discovered = printers.map((p) => PrinterDeviceModel.fromPrinting(p)).toList();
```

Persist the selected printer along with custom user-friendly aliases in `AppPreferences`.

### Step 3: Decomposed Presentation Architecture
Adhere strictly to `RULE-UI-001` (sub-40 LOC build methods):
- `ActivePrinterCard`: Paired printer details and quick actions.
- `PrinterPreferencesCard`: Auto-print toggles.
- `DiscoveredPrintersList`: Scanned Bluetooth and USB devices.
- `PrinterAliasEditDialog`: Friendly alias naming modal.

---

## 6. Edge Cases & Defensive Invariants

| Scenario | Risk | Mitigation |
| :--- | :--- | :--- |
| Bluetooth disconnected mid-print | Crash or frozen UI | Wrap print call in try-catch with timeout, display localized error toast. |
| Printer out of paper | Unhandled exception | Catch printing platform exception, prompt user via AppFeedback. |
| No printer paired | Failed auto-print | Defensively check `savedPrinter != null` before dispatching print jobs. |
| Extremely long product names | Line item text overflow | Force wrap or truncate item descriptions with ellipsis in PDF table. |

---

## 7. Verification & Quality Gates

Run automated validation gates to ensure hardware abstraction complies with project standards:

```bash
# 1. Run static analysis
flutter analyze lib/presentation/settings lib/domain/services/receipt_service.dart

# 2. Run unit and widget tests
flutter test test/presentation/settings/printer_management_screen_test.dart
```

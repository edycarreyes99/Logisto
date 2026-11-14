import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/invoice_status_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/domain/models/invoice_model.dart';
import 'package:logisto/domain/models/printer_device_model.dart';
import 'package:logisto/domain/services/receipt_pdf_generator.dart';

void main() {
  late ThermalReceiptPdfGenerator generator;
  late InvoiceModel mockInvoice;

  setUp(() {
    generator = ThermalReceiptPdfGenerator();
    mockInvoice = InvoiceModel(
      id: 'inv-test-001',
      invoiceNumber: 'FAC-2026-0001',
      cashShiftId: 'shift-101',
      cashierUserId: 'user-01',
      customerDisplayName: 'Cliente Mostrador General',
      items: const [
        InvoiceItemModel(
          productId: 'prod-01',
          name: 'Cerveza Nacional 350ml',
          quantity: 2,
          unitPrice: 2.50,
          total: 5.00,
        ),
        InvoiceItemModel(
          productId: 'prod-02',
          name: 'Hamburguesa Especial de la Casa',
          quantity: 1,
          unitPrice: 8.50,
          total: 8.50,
        ),
      ],
      subtotal: 13.50,
      taxAmount: 2.03,
      totalAmount: 15.53,
      payments: const [
        PaymentTenderModel(
          method: PaymentMethodEnum.cash,
          amount: 15.53,
          tendered: 20.00,
          change: 4.47,
        ),
      ],
      paymentStatus: InvoiceStatusEnum.paid,
      createdAt: DateTime(2026, 11, 14, 15, 30),
    );
  });

  group('ThermalReceiptPdfGenerator Tests', () {
    test('generates valid PDF bytes for 80mm roll format', () async {
      final bytes = await generator.generateReceiptBytes(
        invoice: mockInvoice,
        hardwareType: PrinterHardwareType.thermal80mm,
        businessName: 'Bar & Billar Odynnix',
        businessTaxId: 'J0310000012345',
        businessAddress: 'Av. Principal #123',
        businessPhone: '+505 2222-3333',
        branchName: 'Sucursal Central',
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.isNotEmpty, isTrue);
      // Valid PDF documents start with '%PDF-' magic bytes
      final header = String.fromCharCodes(bytes.take(5));
      expect(header, equals('%PDF-'));
    });

    test('generates valid PDF bytes for 58mm compact roll format', () async {
      final bytes = await generator.generateReceiptBytes(
        invoice: mockInvoice,
        hardwareType: PrinterHardwareType.thermal58mm,
        businessName: 'Mini POS Mobile',
        branchName: 'Ruta 1',
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.isNotEmpty, isTrue);
      final header = String.fromCharCodes(bytes.take(5));
      expect(header, equals('%PDF-'));
    });

    test('generates valid PDF bytes for dot-matrix format', () async {
      final bytes = await generator.generateReceiptBytes(
        invoice: mockInvoice,
        hardwareType: PrinterHardwareType.dotMatrix,
        businessName: 'Impresora Matricial Cocina',
      );

      expect(bytes, isA<Uint8List>());
      expect(bytes.isNotEmpty, isTrue);
      final header = String.fromCharCodes(bytes.take(5));
      expect(header, equals('%PDF-'));
    });
  });
}

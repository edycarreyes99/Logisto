import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/preferences/app_preferences.dart';
import '../../domain/models/printer_device_model.dart';
import '../../domain/services/printer_service.dart';
import '../../domain/services/receipt_pdf_generator.dart';
import '../../domain/models/invoice_model.dart';

/// Concrete implementation of [IPrinterService] utilizing `printing` and `pdf` packages.
class PrintingServiceAdapter implements IPrinterService {
  final IReceiptPdfGenerator receiptPdfGenerator;
  final AppPreferences appPreferences;

  PrintingServiceAdapter({
    required this.receiptPdfGenerator,
    required this.appPreferences,
  });

  @override
  Future<List<PrinterDeviceModel>> getAvailablePrinters() async {
    try {
      final printers = await Printing.listPrinters();
      final savedPrinter = appPreferences.getSavedPrinter();

      return printers.map((p) {
        final nameLower = p.name.toLowerCase();
        final isUsb = nameLower.contains('usb') || (p.url.toLowerCase().contains('usb'));

        final isDefault = savedPrinter != null
            ? (savedPrinter.id == p.url || savedPrinter.rawName == p.name)
            : p.isDefault;

        return PrinterDeviceModel(
          id: p.url.isNotEmpty ? p.url : p.name,
          rawName: p.name,
          customAlias: (savedPrinter != null &&
                  (savedPrinter.id == p.url || savedPrinter.rawName == p.name))
              ? savedPrinter.customAlias
              : '',
          macAddress: p.url.contains(':') ? p.url : '',
          connectionType: isUsb ? PrinterConnectionType.usb : PrinterConnectionType.bluetooth,
          hardwareType: savedPrinter?.hardwareType ?? PrinterHardwareType.thermal80mm,
          isConnected: p.isAvailable,
          isDefault: isDefault,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> printReceipt({
    required InvoiceModel invoice,
    PrinterDeviceModel? targetPrinter,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  }) async {
    final effectivePrinter = targetPrinter ?? appPreferences.getSavedPrinter();
    final effectiveType = hardwareType ?? effectivePrinter?.hardwareType ?? PrinterHardwareType.thermal80mm;

    final pdfBytes = await receiptPdfGenerator.generateReceiptBytes(
      invoice: invoice,
      hardwareType: effectiveType,
      businessName: businessName,
      businessTaxId: businessTaxId,
      businessAddress: businessAddress,
      businessPhone: businessPhone,
      branchName: branchName,
    );

    if (effectivePrinter != null) {
      try {
        final printer = Printer(
          url: effectivePrinter.id.isNotEmpty ? effectivePrinter.id : effectivePrinter.rawName,
          name: effectivePrinter.rawName,
        );
        return await Printing.directPrintPdf(
          printer: printer,
          onLayout: (format) async => pdfBytes,
          name: 'Factura_${invoice.invoiceNumber}',
        );
      } catch (_) {
        // Fallback to standard layout dialog if direct printing fails
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
          name: 'Factura_${invoice.invoiceNumber}',
        );
        return true;
      }
    } else {
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Factura_${invoice.invoiceNumber}',
      );
      return true;
    }
  }

  @override
  Future<void> openPrintDialog({
    required InvoiceModel invoice,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  }) async {
    final savedPrinter = appPreferences.getSavedPrinter();
    final effectiveType = hardwareType ?? savedPrinter?.hardwareType ?? PrinterHardwareType.thermal80mm;

    final pdfBytes = await receiptPdfGenerator.generateReceiptBytes(
      invoice: invoice,
      hardwareType: effectiveType,
      businessName: businessName,
      businessTaxId: businessTaxId,
      businessAddress: businessAddress,
      businessPhone: businessPhone,
      branchName: branchName,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: 'Factura_${invoice.invoiceNumber}',
    );
  }

  @override
  Future<void> shareReceiptPdf({
    required InvoiceModel invoice,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  }) async {
    final savedPrinter = appPreferences.getSavedPrinter();
    final effectiveType = hardwareType ?? savedPrinter?.hardwareType ?? PrinterHardwareType.thermal80mm;

    final pdfBytes = await receiptPdfGenerator.generateReceiptBytes(
      invoice: invoice,
      hardwareType: effectiveType,
      businessName: businessName,
      businessTaxId: businessTaxId,
      businessAddress: businessAddress,
      businessPhone: businessPhone,
      branchName: branchName,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Ticket_${invoice.invoiceNumber}.pdf',
    );
  }

  @override
  Future<bool> printTestTicket({required PrinterDeviceModel printer}) async {
    final doc = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final double pageWidth = printer.hardwareType == PrinterHardwareType.thermal58mm
        ? 58 * PdfPageFormat.mm
        : 80 * PdfPageFormat.mm;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          pageWidth,
          double.infinity,
          marginAll: 4 * PdfPageFormat.mm,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'LOGISTO PRINTER TEST',
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Prueba de Impresion Exitosa',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Divider(thickness: 0.5),
              pw.Text('Alias: ${printer.displayName}', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('Hardware: ${printer.rawName}', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('Tipo: ${printer.connectionType.storageKey.toUpperCase()}', style: const pw.TextStyle(fontSize: 8)),
              if (printer.macAddress.isNotEmpty)
                pw.Text('MAC / ID: ${printer.macAddress}', style: const pw.TextStyle(fontSize: 7)),
              pw.Text('Fecha: ${dateFormat.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 7)),
              pw.Divider(thickness: 0.5),
              pw.Text('********************************', style: const pw.TextStyle(fontSize: 8)),
              pw.Text('IMPRESORA CONFIGURADA Y LISTA', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
              pw.Text('********************************', style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    final pdfBytes = await doc.save();
    try {
      final p = Printer(
        url: printer.id.isNotEmpty ? printer.id : printer.rawName,
        name: printer.rawName,
      );
      return await Printing.directPrintPdf(
        printer: p,
        onLayout: (format) async => pdfBytes,
        name: 'Test_Print_${printer.rawName}',
      );
    } catch (_) {
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Test_Print_${printer.rawName}',
      );
      return true;
    }
  }
}

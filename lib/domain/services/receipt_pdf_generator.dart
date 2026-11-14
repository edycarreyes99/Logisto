import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/models/invoice_model.dart';
import '../../domain/models/printer_device_model.dart';

/// Contract for generating continuous thermal and dot-matrix receipt PDFs.
abstract class IReceiptPdfGenerator {
  Future<Uint8List> generateReceiptBytes({
    required InvoiceModel invoice,
    PrinterHardwareType hardwareType = PrinterHardwareType.thermal80mm,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  });
}

/// Production implementation of [IReceiptPdfGenerator] delivering pixel-perfect
/// 80mm, 58mm, and dot-matrix continuous roll vouchers.
class ThermalReceiptPdfGenerator implements IReceiptPdfGenerator {
  @override
  Future<Uint8List> generateReceiptBytes({
    required InvoiceModel invoice,
    PrinterHardwareType hardwareType = PrinterHardwareType.thermal80mm,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  }) async {
    final doc = pw.Document();

    // Determine roll width and horizontal padding based on hardware type
    final double pageWidth;
    final double margin;
    final double baseFontSize;
    final double titleFontSize;

    switch (hardwareType) {
      case PrinterHardwareType.thermal58mm:
        pageWidth = 58 * PdfPageFormat.mm; // ~164 pt
        margin = 3 * PdfPageFormat.mm;
        baseFontSize = 7.0;
        titleFontSize = 9.5;
        break;
      case PrinterHardwareType.dotMatrix:
        pageWidth = 80 * PdfPageFormat.mm;
        margin = 4 * PdfPageFormat.mm;
        baseFontSize = 8.0;
        titleFontSize = 10.0;
        break;
      case PrinterHardwareType.thermal80mm:
        pageWidth = 80 * PdfPageFormat.mm; // ~226 pt
        margin = 4 * PdfPageFormat.mm;
        baseFontSize = 8.5;
        titleFontSize = 11.0;
        break;
    }

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    // Build page with dynamic roll height (unconstrained vertical dimension)
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          pageWidth,
          double.infinity,
          marginAll: margin,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              // Header - Business Information
              pw.Text(
                (businessName?.isNotEmpty ?? false) ? businessName! : 'LOGISTO ERP',
                style: pw.TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              if (businessTaxId != null && businessTaxId.isNotEmpty) ...[
                pw.SizedBox(height: 1),
                pw.Text(
                  'RUC / RFC: $businessTaxId',
                  style: pw.TextStyle(fontSize: baseFontSize - 1),
                  textAlign: pw.TextAlign.center,
                ),
              ],
              if (businessAddress != null && businessAddress.isNotEmpty) ...[
                pw.SizedBox(height: 1),
                pw.Text(
                  businessAddress,
                  style: pw.TextStyle(fontSize: baseFontSize - 1.5),
                  textAlign: pw.TextAlign.center,
                ),
              ],
              if (businessPhone != null && businessPhone.isNotEmpty) ...[
                pw.SizedBox(height: 1),
                pw.Text(
                  'Tel: $businessPhone',
                  style: pw.TextStyle(fontSize: baseFontSize - 1.5),
                  textAlign: pw.TextAlign.center,
                ),
              ],
              if (branchName != null && branchName.isNotEmpty) ...[
                pw.SizedBox(height: 1),
                pw.Text(
                  'Sucursal: $branchName',
                  style: pw.TextStyle(fontSize: baseFontSize - 1.5),
                  textAlign: pw.TextAlign.center,
                ),
              ],
              pw.SizedBox(height: 4),
              _buildDashedDivider(),
              pw.SizedBox(height: 4),

              // Invoice Metadata
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('FACTURA:', style: pw.TextStyle(fontSize: baseFontSize, fontWeight: pw.FontWeight.bold)),
                  pw.Text(invoice.invoiceNumber, style: pw.TextStyle(fontSize: baseFontSize, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Fecha:', style: pw.TextStyle(fontSize: baseFontSize - 1)),
                  pw.Text(dateFormat.format(invoice.createdAt), style: pw.TextStyle(fontSize: baseFontSize - 1)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Cliente:', style: pw.TextStyle(fontSize: baseFontSize - 1)),
                  pw.Expanded(
                    child: pw.Text(
                      invoice.customerDisplayName,
                      style: pw.TextStyle(fontSize: baseFontSize - 1),
                      textAlign: pw.TextAlign.right,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              if (invoice.cashierUserId.isNotEmpty)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Cajero:', style: pw.TextStyle(fontSize: baseFontSize - 1)),
                    pw.Text(invoice.cashierUserId, style: pw.TextStyle(fontSize: baseFontSize - 1)),
                  ],
                ),
              pw.SizedBox(height: 4),
              _buildDashedDivider(),
              pw.SizedBox(height: 4),

              // Items Table Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text('DESCRIPCION', style: pw.TextStyle(fontSize: baseFontSize - 1, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text('CANT', style: pw.TextStyle(fontSize: baseFontSize - 1, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text('TOTAL', style: pw.TextStyle(fontSize: baseFontSize - 1, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              _buildDashedDivider(),
              pw.SizedBox(height: 2),

              // Items Lines
              ...invoice.items.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.name, style: pw.TextStyle(fontSize: baseFontSize - 0.5)),
                            pw.Text(
                              '@ ${currencyFormat.format(item.unitPrice)}',
                              style: pw.TextStyle(fontSize: baseFontSize - 2, color: PdfColors.grey700),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2),
                          style: pw.TextStyle(fontSize: baseFontSize - 0.5),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          currencyFormat.format(item.total),
                          style: pw.TextStyle(fontSize: baseFontSize - 0.5),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.SizedBox(height: 4),
              _buildDashedDivider(),
              pw.SizedBox(height: 4),

              // Totals
              _buildTotalRow('Subtotal:', currencyFormat.format(invoice.subtotal), baseFontSize - 0.5),
              _buildTotalRow('IVA (15%):', currencyFormat.format(invoice.taxAmount), baseFontSize - 0.5),
              pw.SizedBox(height: 2),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL:', style: pw.TextStyle(fontSize: baseFontSize + 1.5, fontWeight: pw.FontWeight.bold)),
                  pw.Text(currencyFormat.format(invoice.totalAmount), style: pw.TextStyle(fontSize: baseFontSize + 1.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),

              pw.SizedBox(height: 4),
              _buildDashedDivider(),
              pw.SizedBox(height: 4),

              // Payments breakdown
              if (invoice.payments.isNotEmpty) ...[
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text('FORMAS DE PAGO:', style: pw.TextStyle(fontSize: baseFontSize - 1, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 2),
                ...invoice.payments.map((p) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 0.5),
                    child: pw.Column(
                      children: [
                        _buildTotalRow(
                          p.method.storageKey.toUpperCase(),
                          currencyFormat.format(p.amount),
                          baseFontSize - 1,
                        ),
                        if (p.tendered != null && p.tendered! > 0)
                          _buildTotalRow(
                            '  Recibido:',
                            currencyFormat.format(p.tendered!),
                            baseFontSize - 1.5,
                          ),
                        if (p.change != null && p.change! > 0)
                          _buildTotalRow(
                            '  Cambio:',
                            currencyFormat.format(p.change!),
                            baseFontSize - 1.5,
                          ),
                      ],
                    ),
                  );
                }),
                pw.SizedBox(height: 4),
                _buildDashedDivider(),
                pw.SizedBox(height: 4),
              ],

              // QR Code for electronic validation
              pw.BarcodeWidget(
                data: 'https://logisto.app/verify?inv=${invoice.invoiceNumber}&tot=${invoice.totalAmount}',
                barcode: pw.Barcode.qrCode(),
                width: 48,
                height: 48,
              ),
              pw.SizedBox(height: 4),

              // Footer Courtesy Text
              pw.Text(
                '¡Gracias por su compra!',
                style: pw.TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Conserve este ticket para cualquier cambio o garantia.',
                style: pw.TextStyle(fontSize: baseFontSize - 2),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _buildDashedDivider() {
    return pw.Container(
      height: 1,
      child: pw.LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints?.maxWidth ?? 200;
          const dashWidth = 3.0;
          const dashSpace = 2.0;
          final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
          return pw.Flex(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            direction: pw.Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return pw.SizedBox(
                width: dashWidth,
                height: 0.8,
                child: pw.DecoratedBox(
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value, double fontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 0.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: fontSize)),
          pw.Text(value, style: pw.TextStyle(fontSize: fontSize)),
        ],
      ),
    );
  }
}

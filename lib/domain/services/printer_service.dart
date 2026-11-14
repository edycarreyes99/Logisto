import '../../domain/models/invoice_model.dart';
import '../../domain/models/printer_device_model.dart';

/// Contract for printing, testing, sharing, and discovering printers across OS platforms.
abstract class IPrinterService {
  /// Lists all printers recognized by the host OS (USB, network, and paired Bluetooth).
  Future<List<PrinterDeviceModel>> getAvailablePrinters();

  /// Directly sends receipt document bytes to the targeted or configured printer.
  Future<bool> printReceipt({
    required InvoiceModel invoice,
    PrinterDeviceModel? targetPrinter,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  });

  /// Opens the native OS interactive print preview and device selector dialog.
  Future<void> openPrintDialog({
    required InvoiceModel invoice,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  });

  /// Shares or exports the receipt PDF document via standard OS share intents.
  Future<void> shareReceiptPdf({
    required InvoiceModel invoice,
    PrinterHardwareType? hardwareType,
    String? businessName,
    String? businessTaxId,
    String? businessAddress,
    String? businessPhone,
    String? branchName,
  });

  /// Prints a diagnostic test ticket to verify connection and alignment.
  Future<bool> printTestTicket({
    required PrinterDeviceModel printer,
  });
}

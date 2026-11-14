import 'package:flutter/foundation.dart';
import '../../data/preferences/app_preferences.dart';
import '../../domain/models/printer_device_model.dart';
import '../../domain/services/printer_service.dart';

/// Presentation state controller governing printer discovery, alias configuration,
/// hardware type assignment, and test-print triggers.
class PrinterManagementProvider extends ChangeNotifier {
  final IPrinterService printerService;
  final AppPreferences appPreferences;

  PrinterManagementProvider({
    required this.printerService,
    required this.appPreferences,
  }) {
    loadSavedPrinter();
  }

  PrinterDeviceModel? _savedPrinter;
  List<PrinterDeviceModel> _discoveredPrinters = [];
  bool _isScanning = false;
  bool _isPrintingTest = false;
  String? _errorMessage;
  String? _successMessage;

  PrinterDeviceModel? get savedPrinter => _savedPrinter;
  List<PrinterDeviceModel> get discoveredPrinters => _discoveredPrinters;
  bool get isScanning => _isScanning;
  bool get isPrintingTest => _isPrintingTest;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get autoPrintOnSale => appPreferences.getAutoPrintOnSale();

  /// Loads persisted printer configuration on startup.
  void loadSavedPrinter() {
    _savedPrinter = appPreferences.getSavedPrinter();
    notifyListeners();
  }

  /// Scans for available USB and Bluetooth printers visible to the OS.
  Future<void> scanForPrinters() async {
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await printerService.getAvailablePrinters();
      _discoveredPrinters = list;
    } catch (e) {
      _errorMessage = 'Error al escanear impresoras: $e';
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  /// Selects and saves a printer as default, persisting its MAC address / device ID.
  Future<void> selectPrinter(PrinterDeviceModel printer) async {
    final updated = printer.copyWith(
      isDefault: true,
      isConnected: true,
      lastConnectedAt: DateTime.now(),
    );
    _savedPrinter = updated;
    await appPreferences.saveSavedPrinter(updated);
    notifyListeners();
  }

  /// Updates the user-defined custom alias for the saved printer.
  Future<void> updatePrinterAlias(String newAlias) async {
    if (_savedPrinter == null) return;
    final updated = _savedPrinter!.copyWith(customAlias: newAlias.trim());
    _savedPrinter = updated;
    await appPreferences.saveSavedPrinter(updated);
    notifyListeners();
  }

  /// Changes the hardware paper size / printing technology.
  Future<void> updateHardwareType(PrinterHardwareType type) async {
    if (_savedPrinter == null) return;
    final updated = _savedPrinter!.copyWith(hardwareType: type);
    _savedPrinter = updated;
    await appPreferences.saveSavedPrinter(updated);
    notifyListeners();
  }

  /// Toggles automatic ticket printing on completed checkout.
  Future<void> toggleAutoPrint(bool value) async {
    await appPreferences.setAutoPrintOnSale(value);
    notifyListeners();
  }

  /// Clears saved printer connection.
  Future<void> disconnectSavedPrinter() async {
    _savedPrinter = null;
    await appPreferences.clearSavedPrinter();
    notifyListeners();
  }

  /// Dispatches a diagnostic test ticket to the configured printer.
  Future<bool> printTestTicket() async {
    if (_savedPrinter == null) {
      _errorMessage = 'No hay ninguna impresora seleccionada.';
      notifyListeners();
      return false;
    }

    _isPrintingTest = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final success = await printerService.printTestTicket(printer: _savedPrinter!);
      if (success) {
        _successMessage = 'Página de prueba enviada con éxito.';
      } else {
        _errorMessage = 'No se pudo enviar la prueba de impresión.';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error en prueba de impresión: $e';
      return false;
    } finally {
      _isPrintingTest = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}

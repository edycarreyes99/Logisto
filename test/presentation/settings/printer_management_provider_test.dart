import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/domain/models/printer_device_model.dart';
import 'package:logisto/domain/services/printer_service.dart';
import 'package:logisto/presentation/settings/printer_management_provider.dart';

class MockPrinterService extends Mock implements IPrinterService {}

void main() {
  late MockPrinterService mockPrinterService;
  late AppPreferences appPreferences;
  late PrinterManagementProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    appPreferences = await AppPreferences.getInstance(preferences: sharedPrefs);
    mockPrinterService = MockPrinterService();

    registerFallbackValue(
      const PrinterDeviceModel(
        id: 'dummy',
        rawName: 'Dummy',
        connectionType: PrinterConnectionType.bluetooth,
      ),
    );

    provider = PrinterManagementProvider(
      printerService: mockPrinterService,
      appPreferences: appPreferences,
    );
  });

  group('PrinterManagementProvider Tests', () {
    test('initializes with no saved printer when storage is clean', () {
      expect(provider.savedPrinter, isNull);
      expect(provider.discoveredPrinters, isEmpty);
      expect(provider.isScanning, isFalse);
    });

    test('scans and populates available printer devices', () async {
      when(() => mockPrinterService.getAvailablePrinters()).thenAnswer(
        (_) async => [
          const PrinterDeviceModel(
            id: 'usb-01',
            rawName: 'Epson TM-T20III',
            connectionType: PrinterConnectionType.usb,
            hardwareType: PrinterHardwareType.thermal80mm,
          ),
          const PrinterDeviceModel(
            id: 'bt-01',
            rawName: 'MTP-II Bluetooth',
            macAddress: '66:32:B1:88:99:AA',
            connectionType: PrinterConnectionType.bluetooth,
            hardwareType: PrinterHardwareType.thermal58mm,
          ),
        ],
      );

      await provider.scanForPrinters();

      expect(provider.discoveredPrinters.length, equals(2));
      expect(provider.discoveredPrinters.first.rawName, equals('Epson TM-T20III'));
      expect(provider.discoveredPrinters.last.macAddress, equals('66:32:B1:88:99:AA'));
    });

    test('selects printer and persists in local preferences with MAC address', () async {
      const printer = PrinterDeviceModel(
        id: 'bt-02',
        rawName: 'Thermal BT-80',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        connectionType: PrinterConnectionType.bluetooth,
        hardwareType: PrinterHardwareType.thermal80mm,
      );

      await provider.selectPrinter(printer);

      expect(provider.savedPrinter, isNotNull);
      expect(provider.savedPrinter!.id, equals('bt-02'));
      expect(provider.savedPrinter!.macAddress, equals('AA:BB:CC:DD:EE:FF'));
      expect(provider.savedPrinter!.isDefault, isTrue);

      final persisted = appPreferences.getSavedPrinter();
      expect(persisted, isNotNull);
      expect(persisted!.macAddress, equals('AA:BB:CC:DD:EE:FF'));
    });

    test('updates custom alias for saved printer and persists update', () async {
      const printer = PrinterDeviceModel(
        id: 'usb-02',
        rawName: 'POS-80C',
        connectionType: PrinterConnectionType.usb,
      );
      await provider.selectPrinter(printer);

      await provider.updatePrinterAlias('Caja Principal - Mostrador');

      expect(provider.savedPrinter!.customAlias, equals('Caja Principal - Mostrador'));
      expect(provider.savedPrinter!.displayName, equals('Caja Principal - Mostrador'));

      final persisted = appPreferences.getSavedPrinter();
      expect(persisted!.customAlias, equals('Caja Principal - Mostrador'));
    });

    test('updates hardware type (80mm, 58mm, dotMatrix)', () async {
      const printer = PrinterDeviceModel(
        id: 'usb-03',
        rawName: 'Generic POS',
        connectionType: PrinterConnectionType.usb,
      );
      await provider.selectPrinter(printer);

      await provider.updateHardwareType(PrinterHardwareType.dotMatrix);

      expect(provider.savedPrinter!.hardwareType, equals(PrinterHardwareType.dotMatrix));
      final persisted = appPreferences.getSavedPrinter();
      expect(persisted!.hardwareType, equals(PrinterHardwareType.dotMatrix));
    });

    test('disconnects and clears saved printer', () async {
      const printer = PrinterDeviceModel(
        id: 'bt-03',
        rawName: 'Mobile Printer',
        connectionType: PrinterConnectionType.bluetooth,
      );
      await provider.selectPrinter(printer);
      expect(provider.savedPrinter, isNotNull);

      await provider.disconnectSavedPrinter();

      expect(provider.savedPrinter, isNull);
      expect(appPreferences.getSavedPrinter(), isNull);
    });

    test('prints test ticket to saved printer', () async {
      const printer = PrinterDeviceModel(
        id: 'bt-04',
        rawName: 'Test Thermal',
        connectionType: PrinterConnectionType.bluetooth,
      );
      await provider.selectPrinter(printer);

      when(() => mockPrinterService.printTestTicket(printer: any(named: 'printer')))
          .thenAnswer((_) async => true);

      final result = await provider.printTestTicket();

      expect(result, isTrue);
      expect(provider.successMessage, isNotNull);
    });
  });
}

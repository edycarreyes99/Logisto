import 'dart:convert';

/// Physical connection type for a receipt or ticket printer.
enum PrinterConnectionType {
  usb,
  bluetooth,
  network,
}

/// Hardware technology / paper size format of the printer.
enum PrinterHardwareType {
  thermal80mm,
  thermal58mm,
  dotMatrix,
}

extension PrinterConnectionTypeX on PrinterConnectionType {
  String get storageKey {
    switch (this) {
      case PrinterConnectionType.usb:
        return 'usb';
      case PrinterConnectionType.bluetooth:
        return 'bluetooth';
      case PrinterConnectionType.network:
        return 'network';
    }
  }

  static PrinterConnectionType fromStorageKey(String? key) {
    switch (key) {
      case 'usb':
        return PrinterConnectionType.usb;
      case 'network':
        return PrinterConnectionType.network;
      case 'bluetooth':
      default:
        return PrinterConnectionType.bluetooth;
    }
  }
}

extension PrinterHardwareTypeX on PrinterHardwareType {
  String get storageKey {
    switch (this) {
      case PrinterHardwareType.thermal80mm:
        return 'thermal80mm';
      case PrinterHardwareType.thermal58mm:
        return 'thermal58mm';
      case PrinterHardwareType.dotMatrix:
        return 'dotMatrix';
    }
  }

  static PrinterHardwareType fromStorageKey(String? key) {
    switch (key) {
      case 'thermal58mm':
        return PrinterHardwareType.thermal58mm;
      case 'dotMatrix':
        return PrinterHardwareType.dotMatrix;
      case 'thermal80mm':
      default:
        return PrinterHardwareType.thermal80mm;
    }
  }
}

/// Pure domain entity modeling a configured or discovered printer device.
class PrinterDeviceModel {
  final String id;
  final String rawName;
  final String customAlias;
  final String macAddress;
  final PrinterConnectionType connectionType;
  final PrinterHardwareType hardwareType;
  final bool isConnected;
  final bool isDefault;
  final DateTime? lastConnectedAt;

  const PrinterDeviceModel({
    required this.id,
    required this.rawName,
    this.customAlias = '',
    this.macAddress = '',
    required this.connectionType,
    this.hardwareType = PrinterHardwareType.thermal80mm,
    this.isConnected = false,
    this.isDefault = false,
    this.lastConnectedAt,
  });

  /// User-friendly display name preferring custom alias over raw manufacturer string.
  String get displayName => customAlias.trim().isNotEmpty ? customAlias.trim() : rawName;

  PrinterDeviceModel copyWith({
    String? id,
    String? rawName,
    String? customAlias,
    String? macAddress,
    PrinterConnectionType? connectionType,
    PrinterHardwareType? hardwareType,
    bool? isConnected,
    bool? isDefault,
    DateTime? lastConnectedAt,
  }) {
    return PrinterDeviceModel(
      id: id ?? this.id,
      rawName: rawName ?? this.rawName,
      customAlias: customAlias ?? this.customAlias,
      macAddress: macAddress ?? this.macAddress,
      connectionType: connectionType ?? this.connectionType,
      hardwareType: hardwareType ?? this.hardwareType,
      isConnected: isConnected ?? this.isConnected,
      isDefault: isDefault ?? this.isDefault,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rawName': rawName,
      'customAlias': customAlias,
      'macAddress': macAddress,
      'connectionType': connectionType.storageKey,
      'hardwareType': hardwareType.storageKey,
      'isConnected': isConnected,
      'isDefault': isDefault,
      'lastConnectedAt': lastConnectedAt?.toIso8601String(),
    };
  }

  factory PrinterDeviceModel.fromMap(Map<String, dynamic> map) {
    return PrinterDeviceModel(
      id: map['id'] as String? ?? '',
      rawName: map['rawName'] as String? ?? 'Impresora',
      customAlias: map['customAlias'] as String? ?? '',
      macAddress: map['macAddress'] as String? ?? '',
      connectionType: PrinterConnectionTypeX.fromStorageKey(map['connectionType'] as String?),
      hardwareType: PrinterHardwareTypeX.fromStorageKey(map['hardwareType'] as String?),
      isConnected: map['isConnected'] as bool? ?? false,
      isDefault: map['isDefault'] as bool? ?? false,
      lastConnectedAt: map['lastConnectedAt'] != null
          ? DateTime.tryParse(map['lastConnectedAt'] as String)
          : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory PrinterDeviceModel.fromJson(String source) =>
      PrinterDeviceModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

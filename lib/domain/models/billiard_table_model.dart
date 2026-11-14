import '../../core/enums/table_status_enum.dart';
import '../../core/enums/table_type_enum.dart';

/// Pure domain model for an active rental session on a billiard table.
class BilliardSessionModel {
  final String sessionId;
  final String? customerId;
  final String? customerName;
  final DateTime startTime;
  final int accumulatedSeconds;
  final bool isPaused;
  final DateTime? pausedAt;
  final String? associatedAccountId;

  const BilliardSessionModel({
    required this.sessionId,
    this.customerId,
    this.customerName,
    required this.startTime,
    this.accumulatedSeconds = 0,
    this.isPaused = false,
    this.pausedAt,
    this.associatedAccountId,
  });

  BilliardSessionModel copyWith({
    String? sessionId,
    String? customerId,
    String? customerName,
    DateTime? startTime,
    int? accumulatedSeconds,
    bool? isPaused,
    DateTime? pausedAt,
    String? associatedAccountId,
  }) {
    return BilliardSessionModel(
      sessionId: sessionId ?? this.sessionId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      startTime: startTime ?? this.startTime,
      accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
      isPaused: isPaused ?? this.isPaused,
      pausedAt: pausedAt ?? this.pausedAt,
      associatedAccountId: associatedAccountId ?? this.associatedAccountId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'customerId': customerId,
      'customerName': customerName,
      'startTime': startTime.toIso8601String(),
      'accumulatedSeconds': accumulatedSeconds,
      'isPaused': isPaused,
      'pausedAt': pausedAt?.toIso8601String(),
      'associatedAccountId': associatedAccountId,
    };
  }

  factory BilliardSessionModel.fromMap(Map<String, dynamic> map) {
    return BilliardSessionModel(
      sessionId: map['sessionId'] as String? ?? '',
      customerId: map['customerId'] as String?,
      customerName: map['customerName'] as String?,
      startTime: map['startTime'] != null
          ? DateTime.tryParse(map['startTime'].toString()) ?? DateTime.now()
          : DateTime.now(),
      accumulatedSeconds: (map['accumulatedSeconds'] as num?)?.toInt() ?? 0,
      isPaused: map['isPaused'] as bool? ?? false,
      pausedAt: map['pausedAt'] != null
          ? DateTime.tryParse(map['pausedAt'].toString())
          : null,
      associatedAccountId: map['associatedAccountId'] as String?,
    );
  }
}

/// Pure domain model for a billiard table station.
class BilliardTableModel {
  final String id;
  final int tableNumber;
  final String name;
  final TableTypeEnum tableType;
  final double hourlyRate;
  final int minimumMinutes;
  final int graceMinutes;
  final TableStatusEnum status;
  final BilliardSessionModel? currentSession;

  const BilliardTableModel({
    required this.id,
    required this.tableNumber,
    required this.name,
    required this.tableType,
    required this.hourlyRate,
    this.minimumMinutes = 15,
    this.graceMinutes = 3,
    required this.status,
    this.currentSession,
  });

  BilliardTableModel copyWith({
    String? id,
    int? tableNumber,
    String? name,
    TableTypeEnum? tableType,
    double? hourlyRate,
    int? minimumMinutes,
    int? graceMinutes,
    TableStatusEnum? status,
    BilliardSessionModel? currentSession,
  }) {
    return BilliardTableModel(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      name: name ?? this.name,
      tableType: tableType ?? this.tableType,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      minimumMinutes: minimumMinutes ?? this.minimumMinutes,
      graceMinutes: graceMinutes ?? this.graceMinutes,
      status: status ?? this.status,
      currentSession: currentSession ?? this.currentSession,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'name': name,
      'tableType': tableType.storageKey,
      'hourlyRate': hourlyRate,
      'minimumMinutes': minimumMinutes,
      'graceMinutes': graceMinutes,
      'status': status.storageKey,
      'currentSession': currentSession?.toMap(),
    };
  }

  factory BilliardTableModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return BilliardTableModel(
      id: docId ?? (map['id'] as String? ?? ''),
      tableNumber: (map['tableNumber'] as num?)?.toInt() ?? 1,
      name: map['name'] as String? ?? '',
      tableType: TableTypeEnum.fromStorageKey(map['tableType'] as String?),
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 10.0,
      minimumMinutes: (map['minimumMinutes'] as num?)?.toInt() ?? 15,
      graceMinutes: (map['graceMinutes'] as num?)?.toInt() ?? 3,
      status: TableStatusEnum.fromStorageKey(map['status'] as String?),
      currentSession: map['currentSession'] != null
          ? BilliardSessionModel.fromMap(
              map['currentSession'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

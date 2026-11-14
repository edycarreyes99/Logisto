import '../../core/enums/audit_action_enum.dart';

/// Pure domain model for an immutable enterprise security audit trail log entry.
class AuditLogModel {
  final String id;
  final String orgId;
  final String buId;
  final String userId;
  final String userDisplayName;
  final AuditActionEnum action;
  final String description;
  final String? previousValue;
  final String? newValue;
  final String? clientIp;
  final DateTime timestamp;

  const AuditLogModel({
    required this.id,
    required this.orgId,
    required this.buId,
    required this.userId,
    required this.userDisplayName,
    required this.action,
    required this.description,
    this.previousValue,
    this.newValue,
    this.clientIp,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'buId': buId,
      'userId': userId,
      'userDisplayName': userDisplayName,
      'action': action.storageKey,
      'description': description,
      'previousValue': previousValue,
      'newValue': newValue,
      'clientIp': clientIp,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AuditLogModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AuditLogModel(
      id: docId ?? (map['id'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      buId: map['buId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userDisplayName: map['userDisplayName'] as String? ?? '',
      action: AuditActionEnum.fromStorageKey(map['action'] as String?),
      description: map['description'] as String? ?? '',
      previousValue: map['previousValue'] as String?,
      newValue: map['newValue'] as String?,
      clientIp: map['clientIp'] as String?,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

---
id: RULE-DATA-003
title: Offline Cache Management and Storage Allocation
category: data
severity: critical
scope:
  include:
    - "lib/data/firestore/**"
    - "lib/data/preferences/**"
  exclude:
    - "test/**"
---

# Offline Cache Management and Storage Allocation

> Rule ID: RULE-DATA-003  
> Severity: critical  
> Target Scope: lib/data/firestore/**, lib/data/preferences/**  
> Category: data  

---

## 1. Architectural Invariant

All persistent offline caches (Cloud Firestore disk cache, IndexedDB web stores, and SharedPreferences) MUST have deterministic size bounds, safe error recovery protocols, and explicit lifecycle cleanup routines.

Under no circumstances shall:
1. Cache clear routines wipe persistent credentials or user preferences without explicit user logout confirmation.
2. Web platforms exhaust browser IndexedDB quotas by unbounded binary file storage in Firestore documents.
3. Offline mutations fail silently without propagating retry metadata or status indicators to the presentation layer.

---

## 2. Rationale & Failure Impact

- **Storage Predictability:** Mobile and desktop operating systems evict application data or fail write operations if storage quotas are exceeded without warning.
- **Session Cleanup:** When a user logs out, sensitive cached customer documents MUST be cleared from the local device to prevent information disclosure to subsequent users on shared hardware.
- **Failure Impact:** Unbounded cache accumulation leads to disk saturation, sluggish app startup, out-of-quota exceptions on web browsers, and privacy breaches on shared mobile devices.

---

## 3. Compliant Pattern (DO)

Configure deterministic cache limits, safe logout cleanup, and resilient offline synchronization:

```dart
// lib/data/firestore/firestore_client.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  final FirebaseFirestore _firestore;

  FirestoreClient({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      // 100 MB deterministic cache boundary
      cacheSizeBytes: 104857600,
    );
  }

  /// Safely terminates listeners and clears the local Firestore persistence cache upon logout.
  Future<void> clearCacheOnLogout() async {
    try {
      await _firestore.terminate();
      await _firestore.clearPersistence();
    } catch (_) {
      // Gracefully handle browser IndexedDB lock errors during teardown
    }
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Ignoring cache limits and performing blind storage wipes that delete critical session tokens:

```dart
// BAD: Unmanaged storage allocation and destructive cache wiping
class BadCacheHandler {
  Future<void> wipeAll() async {
    // VIOLATION: Blindly dropping entire shared_preferences without preserving auth state!
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // VIOLATION: Terminating firestore without checking active write transactions
    await FirebaseFirestore.instance.clearPersistence();
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Verify Firestore client configures an explicit cache size or unlimited policy properly:

```bash
# Verify explicit cache size configuration in firestore client
rg --glob 'lib/data/firestore/**' 'cacheSizeBytes'
```

Expected output: At least 1 match confirming cache size policy is explicitly declared.

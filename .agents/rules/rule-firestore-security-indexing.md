---
id: RULE-DATA-002
title: Cloud Firestore Security Rules and Composite Indexing Manifest
category: data
severity: blocking
scope:
  include:
    - "firestore.rules"
    - "firestore.indexes.json"
    - "lib/data/firestore/**"
  exclude:
    - "test/**"
---

# Cloud Firestore Security Rules and Composite Indexing Manifest

> Rule ID: RULE-DATA-002  
> Severity: blocking  
> Target Scope: firestore.rules, firestore.indexes.json, lib/data/firestore/**  
> Category: data  

---

## 1. Architectural Invariant

All database access MUST be governed by declarative, production-grade security rules (`firestore.rules`) enforcing authentication, authorization, and tenant isolation. Every multi-field query (`where` combined with `orderBy` or range filters) MUST be declared in `firestore.indexes.json`.

Under no circumstances shall:
1. `firestore.rules` permit open read or write access (`allow read, write: if true;`) outside authenticated testing environments.
2. Collections containing user or tenant sensitive data allow cross-tenant query execution.
3. Code perform compound queries without an existing composite index registered in the project indexing manifest.

---

## 2. Rationale & Failure Impact

- **Data Privacy & Tenant Boundary Enforcement:** Multi-tenant mobile and enterprise applications must prevent unauthorized user access, data leaks, and tampering. Security rules serve as the authoritative backend firewall.
- **Query Performance & Indexing:** Cloud Firestore rejects compound queries lacking composite indexes at runtime, resulting in unhandled exceptions and empty views.
- **Failure Impact:** Insecure rules expose sensitive customer records, open the project to malicious data wipes, and fail enterprise compliance audits. Missing indexes cause runtime crashes.

---

## 3. Compliant Pattern (DO)

Enforce strict user ownership validation in `firestore.rules` and declare composite indexes:

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to verify authentication
    function isAuthenticated() {
      return request.auth != null;
    }

    // Helper function to verify document ownership
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Weather stations collection scoped to authorized users
    match /weather_stations/{stationId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() 
        && request.resource.data.userId == request.auth.uid
        && request.resource.data.name is string;
      allow update, delete: if isOwner(resource.data.userId);
    }
  }
}
```

Composite index declaration in `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "weather_stations",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "recordedAt", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

---

## 4. Prohibited Pattern (DON'T)

Open, unauthenticated security rules allowing unrestricted public read/write access:

```javascript
// BAD: Wide-open public access security rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      // VIOLATION: Completely open public read and write access!
      allow read, write: if true;
    }
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan security rules files for permissive rules patterns:

```bash
# Verify no wide-open rules in firestore.rules
rg --glob 'firestore.rules' 'allow\s+read,\s*write:\s*if\s+true;'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.

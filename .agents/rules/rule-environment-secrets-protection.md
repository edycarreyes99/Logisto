---
id: RULE-SEC-001
title: Environment Secrets and Sensitive Credential Protection
category: quality
severity: blocking
scope:
  include:
    - ".env*"
    - "lib/**"
    - "tool/**"
  exclude:
    - "test/**"
---

# Environment Secrets and Sensitive Credential Protection

> Rule ID: RULE-SEC-001  
> Severity: blocking  
> Target Scope: .env*, lib/**, tool/**  
> Category: quality  

---

## 1. Architectural Invariant

All external API keys, service endpoints, backend credentials, encryption secrets, and environment configurations MUST be loaded dynamically via environment variables (`flutter_dotenv`) and NEVER committed into version control.

Under no circumstances shall:
1. Active environment files (`.env`, `.env.production`, `.env.staging`) containing real secrets or private tokens be committed into git repositories.
2. Dart source code, configuration files, or build scripts hardcode cleartext API keys, authorization tokens, passwords, or private encryption keys.
3. A project omit `.env.example`, which serves as the authoritative, non-sensitive schema manifest detailing all required environment variables.
4. Application bootstrap proceed without validating the presence of mandatory environment keys during `setupLocator()`.

---

## 2. Rationale & Failure Impact

- **Credential Leak Prevention:** Public or private git commits containing hardcoded secrets can be automatically harvested by malicious bots within seconds, compromising backend cloud resources, customer data, and third-party API quotas.
- **Environment Parity & Portability:** Decoupling secrets from compiled binaries allows identical application artifacts to transition smoothly between development, staging, and production environments simply by substituting environment files.
- **Failure Impact:** Compromised API keys result in unauthorized cloud spending, catastrophic database breaches, project suspensions, and enterprise regulatory compliance failures (GDPR, SOC2, HIPAA).

---

## 3. Compliant Pattern (DO)

Store environment variables in `.env` (git-ignored), maintain `.env.example` as a template, and load configurations securely at startup:

```dart
// .env.example (Committed to source control as schema template)
# Environment Configuration Template
API_BASE_URL=https://api.climatica.example.com
FIRESTORE_PROJECT_ID=climatica-production
WEATHER_API_KEY=YOUR_API_KEY_HERE
PERSISTENCE_CACHE_SIZE_MB=100
```

```dart
// lib/locator.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads and validates mandatory environment secrets prior to dependency registration.
Future<void> loadEnvironmentConfig() async {
  await dotenv.load(fileName: ".env");

  // Validate mandatory environment configuration keys
  const requiredKeys = ['API_BASE_URL', 'FIRESTORE_PROJECT_ID'];
  for (final key in requiredKeys) {
    final value = dotenv.env[key];
    if (value == null || value.trim().isEmpty) {
      throw StateError(
        'Missing required environment variable: $key. '
        'Ensure .env is created and configured matching .env.example.',
      );
    }
  }
}
```

Ensure `.gitignore` contains strict exclusion patterns:

```gitignore
# .gitignore
.env
.env.*
!.env.example
*.keystore
*.jks
google-services.json
GoogleService-Info.plist
```

---

## 4. Prohibited Pattern (DON'T)

Hardcoding API keys, tokens, or private secrets directly in Dart source files:

```dart
// BAD: Cleartext secrets hardcoded in application source code
class BadApiConfig {
  // VIOLATION: Hardcoded production API key!
  static const String apiKey = "AIzaSyD-EXAMPLE_LEAKED_SECRET_KEY_12345";

  // VIOLATION: Hardcoded production backend endpoint!
  static const String serverToken = "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.example";
}
```

---

## 5. Automated Validation & Audit Procedure

Execute automated scans to confirm `.env` is ignored and no hardcoded high-entropy secrets exist:

```bash
# 1. Verify .env is listed in .gitignore
git check-ignore .env || grep -q "^\.env$" .gitignore

# 2. Audit repository for potential leaked API key patterns
rg --glob 'lib/**.dart' '(?i)(api[_-]?key|secret[_-]?key|bearer\s+[a-zA-Z0-9_\-\.]+)\s*=\s*["'\''"][a-zA-Z0-9_\-\.]{16,}["'\'']'
```

Expected output: 0 matches in Dart source code, and clean confirmation that `.env` is git-ignored.

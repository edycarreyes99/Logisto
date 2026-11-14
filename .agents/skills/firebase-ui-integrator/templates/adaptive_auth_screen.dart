import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

/// Responsive authentication screen wrapping [SignInScreen] with Material Design 3 and [bootstrap_ui_flutter].
/// Configures [sideBuilder] for desktop/laptop displays (>=800px) and [headerBuilder]
/// for mobile screens, conforming to RULE-UI-006, RULE-UI-007, and RULE-QUAL-002.
class AdaptiveAuthScreen extends StatelessWidget {
  final List<AuthProvider> providers;
  final VoidCallback onAuthenticated;

  const AdaptiveAuthScreen({
    super.key,
    required this.providers,
    required this.onAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SignInScreen(
      providers: providers,
      breakpoint: 800,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          onAuthenticated();
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          onAuthenticated();
        }),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                'Logisto Portal',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
      sideBuilder: (context, constraints) {
        return BsContainer.fluid(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Logisto',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Multiplatform Operations',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unified operations telemetry across Web, Desktop, and Mobile.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Chip(
                    avatar: const Icon(Icons.check, size: 16),
                    label: const Text('System Operational - 99.98% SLA'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        final text = action == AuthAction.signIn
            ? 'Please enter your corporate credentials.'
            : 'Register a new enterprise account.';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(text, style: theme.textTheme.bodyMedium),
        );
      },
      footerBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              'Protected by Enterprise Security Standards',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        );
      },
    );
  }
}

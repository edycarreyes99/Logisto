# Reactive State Management & ChangeNotifier Validation Checklist

> Standard: Reactive, Decoupled State Management with ChangeNotifier  
> Governed Rules: [../../../rules/rule-state-mutation-guardrails.md](../../../rules/rule-state-mutation-guardrails.md), [../../../rules/rule-subscription-controller-lifecycle.md](../../../rules/rule-subscription-controller-lifecycle.md), [../../../rules/rule-strongly-typed-enums.md](../../../rules/rule-strongly-typed-enums.md)  
> Scope: lib/presentation/**, lib/core/providers/**  

---

## 1. State Controller Design & Encapsulation
- [ ] State controllers extend `ChangeNotifier` and reside strictly in `lib/presentation/[feature]/` or `lib/core/providers/`.
- [ ] Internal state collections and mutable variables are private (`_items`, `_status`, `_errorMessage`).
- [ ] Public getters expose read-only state; collections return `List.unmodifiable(_items)` or immutable views.
- [ ] State lifecycle is governed by strongly-typed status Enums (`idle`, `loading`, `loaded`, `submitting`, `success`, `error`).
- [ ] Zero raw string comparisons for state inspection (e.g., `status == 'loading'` is strictly prohibited).

## 2. State Mutation Guardrails & Build Phase Invariants
- [ ] Zero synchronous state mutations (`notifyListeners()`) during widget build phases or inside layout callbacks.
- [ ] Asynchronous operations schedule notification via post-frame microtasks if triggered from lifecycle hooks.
- [ ] Mutation methods (`submit()`, `delete()`, `refresh()`) set loading state and notify listeners before awaiting async tasks.
- [ ] Multiple mutations within a single synchronous operation batch notifications to avoid rebuild thrashing.

## 3. Subscription & Resource Disposal Lifecycle
- [ ] All `StreamSubscription` instances (from Firestore repositories or services) are stored in nullable fields.
- [ ] Subscriptions are cancelled explicitly in the overridden `dispose()` method: `await _subscription?.cancel()`.
- [ ] All `TextEditingController`, `FocusNode`, `AnimationController`, and `PageController` instances are disposed.
- [ ] Calling methods on disposed providers is guarded via `if (!hasListeners) return;` or disposable flags.
- [ ] Controllers registered in `lib/locator.dart` as factories clean up cleanly upon screen teardown.

## 4. Error Handling, Retries & Optimistic State Rollback
- [ ] Asynchronous workflows wrap domain calls in `try / catch` blocks and emit `StatusEnum.error` on failure.
- [ ] Error messages are localized or mapped to strongly-typed error enums rather than raw backend exception strings.
- [ ] Optimistic mutations cache previous state in memory; if remote persistence fails, previous state is restored and listeners notified.
- [ ] Failed operations expose an idempotent `retry()` or `reexecute()` callback for user-triggered recovery.

## 5. UI Layer Consumption & Rebuild Optimization
- [ ] Feature screens consume state reactively using `AnimatedBuilder`, `ListenableBuilder`, or scoped `Consumer<T>`.
- [ ] Sub-widgets listen only to the specific slices of state they require to render.
- [ ] Zero `setState()` calls for business logic or external data retrieval inside StatefulWidget widgets.

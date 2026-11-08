# Reactive Form Validation Engine Validation Checklist

> Standard: Reactive Form Validation via `BaseValidator` and `GenericFormProvider`  
> Governed Rules: [../../../rules/rule-strongly-typed-enums.md](../../../rules/rule-strongly-typed-enums.md), [../../../rules/rule-subscription-controller-lifecycle.md](../../../rules/rule-subscription-controller-lifecycle.md), [../../../rules/rule-project-prefixed-components.md](../../../rules/rule-project-prefixed-components.md)  
> Scope: lib/core/validators/**, lib/presentation/**/generic_form_provider.dart  

---

## 1. Strongly-Typed Validation Errors
- [ ] Form validation errors are modeled strictly as strongly-typed Enums (`ValidationErrorEnum`).
- [ ] Error enum cases include: `none`, `empty`, `tooShort`, `tooLong`, `invalidPattern`.
- [ ] Zero raw string error messages returned from validation evaluation logic.
- [ ] Error enums map to localized user-facing strings exclusively via `AppLocalizations` in the presentation tier.

## 2. Validator Architecture (`BaseValidator` & `TextFieldValidator`)
- [ ] Custom validators extend or compose `BaseValidator<T>`.
- [ ] `TextFieldValidator` encapsulates `TextEditingController`, validation rules (`isRequired`, `minLength`, `maxLength`, `regexPattern`), and reactive error notification.
- [ ] Evaluates validation on-the-fly (`onChanged`) or lazily upon form submission request.
- [ ] Validates empty, whitespace-only, boundary lengths, and regex mismatches defensively.
- [ ] Exposes clean boolean getters: `isValid`, `isDirty`, `hasError`.

## 3. Form Provider Integration (`GenericFormProvider`)
- [ ] Form providers maintain individual `TextFieldValidator` instances for each user input field.
- [ ] Form submission validates all fields via `validateAll()`; submission halts immediately if any field is invalid.
- [ ] State emits `FormSubmissionStatusEnum.submitting`, `FormSubmissionStatusEnum.success`, or `FormSubmissionStatusEnum.error`.
- [ ] Double-submission is prevented by blocking calls while `status == FormSubmissionStatusEnum.submitting`.
- [ ] Form resets restore default initial values and clear all error states via an explicit `reset()` method.

## 4. Resource Disposal & Memory Leak Prevention
- [ ] Every `TextEditingController` owned by a validator is disposed in the parent provider's or widget's `dispose()` method.
- [ ] Form providers registered as GetIt factories ensure no memory retention of discarded form sessions.
- [ ] Focus nodes associated with input fields are disposed.

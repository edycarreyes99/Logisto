/// Base exception class for all enterprise domain and infrastructure exceptions.
class AppException implements Exception {
  /// English technical message detailing the failure reason.
  final String message;

  /// Optional error code or identifier.
  final String? code;

  /// Optional original underlying exception.
  final dynamic cause;

  const AppException(this.message, {this.code, this.cause});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Thrown when an input validation fails.
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.cause});
}

/// Thrown when attempting to exceed a customer's available credit ceiling.
class InsufficientCreditException extends AppException {
  final double requestedAmount;
  final double availableCredit;

  const InsufficientCreditException({
    required this.requestedAmount,
    required this.availableCredit,
    String? message,
  }) : super(
         message ??
             'Insufficient credit ceiling. Requested: \$$requestedAmount, Available: \$$availableCredit',
         code: 'ERR_INSUFFICIENT_CREDIT',
       );
}

/// Thrown when attempting to operate on a closed cash shift.
class ShiftClosedException extends AppException {
  const ShiftClosedException([super.message = 'Cash shift is closed.'])
    : super(code: 'ERR_SHIFT_CLOSED');
}

/// Thrown when an unauthorized user attempts an operation requiring supervisor elevation.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Unauthorized operation. Supervisor elevation required.',
  ]) : super(code: 'ERR_UNAUTHORIZED');
}

import '../../core/enums/invoice_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../core/errors/app_exception.dart';
import '../models/customer_model.dart';
import '../models/invoice_model.dart';

/// Calculation outcome produced by [CheckoutTenderEngine.processCheckout].
class CheckoutResult {
  final double totalAmount;
  final double totalPaid;
  final double change;
  final double creditCarriedOver;
  final InvoiceStatusEnum status;
  final List<PaymentTenderModel> finalizedPayments;

  const CheckoutResult({
    required this.totalAmount,
    required this.totalPaid,
    required this.change,
    required this.creditCarriedOver,
    required this.status,
    required this.finalizedPayments,
  });
}

/// Pure domain calculation engine processing POS multi-tender and credit rules.
class CheckoutTenderEngine {
  const CheckoutTenderEngine();

  /// Processes payments against [totalAmount], validating customer credit limits and change.
  CheckoutResult processCheckout({
    required double totalAmount,
    required List<PaymentTenderModel> tenders,
    CustomerModel? registeredCustomer,
  }) {
    if (totalAmount < 0) {
      throw const ValidationException('Total amount cannot be negative.');
    }

    if (totalAmount == 0.0) {
      return CheckoutResult(
        totalAmount: 0.0,
        totalPaid: 0.0,
        change: 0.0,
        creditCarriedOver: 0.0,
        status: InvoiceStatusEnum.paid,
        finalizedPayments: tenders,
      );
    }

    double cashTendered = 0.0;
    double nonCashTendered = 0.0;
    double creditRequested = 0.0;

    for (final tender in tenders) {
      if (tender.amount <= 0) {
        throw const ValidationException(
          'Payment tender amount must be greater than zero.',
        );
      }

      if (tender.method == PaymentMethodEnum.cash) {
        final tendered = tender.tendered ?? tender.amount;
        if (tendered < tender.amount) {
          throw const ValidationException(
            'Tendered cash cannot be less than the tender amount.',
          );
        }
        cashTendered += tendered;
      } else if (tender.method == PaymentMethodEnum.customerCredit) {
        creditRequested += tender.amount;
      } else {
        nonCashTendered += tender.amount;
      }
    }

    // Customer credit validation rule
    if (creditRequested > 0.0) {
      if (registeredCustomer == null) {
        throw const ValidationException(
          'Customer credit is strictly prohibited for unregistered / guest customers.',
        );
      }
      if (!registeredCustomer.canChargeCredit(creditRequested)) {
        throw InsufficientCreditException(
          requestedAmount: creditRequested,
          availableCredit: registeredCustomer.availableCredit,
        );
      }
    }

    // Non-cash tenders (cards, transfer, credit) cannot exceed total invoice amount
    final totalNonCash = nonCashTendered + creditRequested;
    if (totalNonCash - totalAmount > 0.01) {
      throw const ValidationException(
        'Non-cash payment exceeds total payable amount.',
      );
    }

    // Cash required to settle remaining balance
    final cashRequired = double.parse(
      (totalAmount - totalNonCash).toStringAsFixed(2),
    );

    // Verify sufficient overall payment
    final totalPaidTendered = totalNonCash + cashTendered;
    final double underpaid = totalAmount - totalPaidTendered;
    if (underpaid > 0.01) {
      throw ValidationException(
        'Insufficient payment. Remaining unliquidated balance: \$${underpaid.toStringAsFixed(2)}',
      );
    }

    // Compute cash change
    final double change = (cashTendered > cashRequired)
        ? double.parse((cashTendered - cashRequired).toStringAsFixed(2))
        : 0.0;

    final double cashApplied = (cashTendered >= cashRequired)
        ? cashRequired
        : cashTendered;

    // Build finalized tender models with change and applied amount properly reflected
    final List<PaymentTenderModel> processed = [];
    bool cashRecorded = false;

    for (final tender in tenders) {
      if (tender.method == PaymentMethodEnum.cash) {
        if (!cashRecorded) {
          processed.add(
            PaymentTenderModel(
              method: PaymentMethodEnum.cash,
              amount: cashApplied,
              tendered: cashTendered,
              change: change,
              cardReference: tender.cardReference,
            ),
          );
          cashRecorded = true;
        }
      } else {
        processed.add(tender);
      }
    }

    final InvoiceStatusEnum status = (creditRequested > 0.0)
        ? InvoiceStatusEnum.partiallyPaidCredit
        : InvoiceStatusEnum.paid;

    final double finalNonCreditPaid = double.parse(
      (nonCashTendered + cashApplied).toStringAsFixed(2),
    );

    return CheckoutResult(
      totalAmount: totalAmount,
      totalPaid: finalNonCreditPaid,
      change: change,
      creditCarriedOver: creditRequested,
      status: status,
      finalizedPayments: processed,
    );
  }
}

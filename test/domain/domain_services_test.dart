import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/invoice_status_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/core/enums/shift_status_enum.dart';
import 'package:logisto/core/enums/table_status_enum.dart';
import 'package:logisto/core/enums/table_type_enum.dart';
import 'package:logisto/core/errors/app_exception.dart';
import 'package:logisto/domain/models/billiard_table_model.dart';
import 'package:logisto/domain/models/customer_model.dart';
import 'package:logisto/domain/models/invoice_model.dart';
import 'package:logisto/domain/services/billiard_rate_calculator.dart';
import 'package:logisto/domain/services/cash_shift_calculator.dart';
import 'package:logisto/domain/services/checkout_tender_engine.dart';

void main() {
  group('BilliardRateCalculator Domain Tests', () {
    const calculator = BilliardRateCalculator();
    const table = BilliardTableModel(
      id: 'tbl_1',
      tableNumber: 1,
      name: 'Mesa 1',
      tableType: TableTypeEnum.pool,
      hourlyRate: 12.0, // $0.20 per minute, $0.00333 per second
      minimumMinutes: 15, // minimum $3.00
      graceMinutes: 3, // free up to 180s
      status: TableStatusEnum.occupied,
    );

    test('returns 0.0 for zero or negative seconds', () {
      expect(calculator.calculateCharge(table: table, elapsedSeconds: 0), 0.0);
      expect(
        calculator.calculateCharge(table: table, elapsedSeconds: -10),
        0.0,
      );
    });

    test('applies grace period (free under 3 minutes)', () {
      // 2 minutes = 120s < 180s
      final charge = calculator.calculateCharge(
        table: table,
        elapsedSeconds: 120,
      );
      expect(charge, 0.0);
    });

    test(
      'applies minimum fraction charge when above grace but below minimumMinutes',
      () {
        // 5 minutes = 300s. Above grace (3 min) but below minimum (15 min).
        // 15 min at $12/h = (15 / 60) * 12 = $3.00
        final charge = calculator.calculateCharge(
          table: table,
          elapsedSeconds: 300,
        );
        expect(charge, 3.00);
      },
    );

    test('calculates exact pro-rated seconds above minimumMinutes', () {
      // 30 minutes = 1800s. (1800 / 3600) * 12 = $6.00
      final charge30Min = calculator.calculateCharge(
        table: table,
        elapsedSeconds: 1800,
      );
      expect(charge30Min, 6.00);

      // 45 minutes = 2700s. (2700 / 3600) * 12 = $9.00
      final charge45Min = calculator.calculateCharge(
        table: table,
        elapsedSeconds: 2700,
      );
      expect(charge45Min, 9.00);
    });

    test('handles table transfer calculation with new table rate', () {
      const vipTable = BilliardTableModel(
        id: 'tbl_vip',
        tableNumber: 10,
        name: 'Mesa VIP',
        tableType: TableTypeEnum.vip,
        hourlyRate: 20.0,
        minimumMinutes: 15,
        graceMinutes: 0,
        status: TableStatusEnum.occupied,
      );

      // 1 hour = 3600s transferred to VIP table ($20/h)
      final transferCharge = calculator.calculateTransferCharge(
        sourceTable: table,
        targetTable: vipTable,
        elapsedSeconds: 3600,
      );
      expect(transferCharge, 20.00);

      // Split transfer calculation: 30 min on standard table + 30 min on VIP table
      final splitCharge = calculator.calculateSplitTransferCharge(
        sourceTable: table,
        sourceSeconds: 1800,
        targetTable: vipTable,
        targetSeconds: 1800,
      );
      // 0.5h * $12 ($6.00) + 0.5h * $20 ($10.00) => $16.00
      expect(splitCharge, 16.00);
    });
  });

  group('CheckoutTenderEngine Domain Tests', () {
    const engine = CheckoutTenderEngine();
    final customer = CustomerModel(
      id: 'cust_1',
      orgId: 'org_1',
      taxId: '001-123',
      firstName: 'Roberto',
      lastName: 'Gómez',
      phone: '123',
      creditLimit: 100.0,
      currentDebtBalance: 20.0, // 80.0 available
      createdAt: DateTime.now(),
    );

    test('processes full cash payment with change', () {
      final result = engine.processCheckout(
        totalAmount: 15.50,
        tenders: const [
          PaymentTenderModel(
            method: PaymentMethodEnum.cash,
            amount: 15.50,
            tendered: 20.00,
          ),
        ],
      );

      expect(result.totalAmount, 15.50);
      expect(result.totalPaid, 15.50);
      expect(result.change, 4.50);
      expect(result.creditCarriedOver, 0.0);
      expect(result.status, InvoiceStatusEnum.paid);
    });

    test('processes multi-tender split between cash and card', () {
      final result = engine.processCheckout(
        totalAmount: 50.00,
        tenders: const [
          PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 20.00),
          PaymentTenderModel(method: PaymentMethodEnum.card, amount: 30.00),
        ],
      );

      expect(result.totalPaid, 50.00);
      expect(result.change, 0.0);
      expect(result.status, InvoiceStatusEnum.paid);
    });

    test(
      'processes partial cash payment with remaining carried to customer credit',
      () {
        final result = engine.processCheckout(
          totalAmount: 60.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 20.00),
            PaymentTenderModel(
              method: PaymentMethodEnum.customerCredit,
              amount: 40.00,
            ),
          ],
          registeredCustomer: customer,
        );

        expect(result.totalPaid, 20.00);
        expect(result.creditCarriedOver, 40.00);
        expect(result.status, InvoiceStatusEnum.partiallyPaidCredit);
      },
    );

    test(
      'throws ValidationException if credit is requested for unregistered guest',
      () {
        expect(
          () => engine.processCheckout(
            totalAmount: 50.00,
            tenders: const [
              PaymentTenderModel(
                method: PaymentMethodEnum.customerCredit,
                amount: 50.00,
              ),
            ],
            registeredCustomer: null,
          ),
          throwsA(isA<ValidationException>()),
        );
      },
    );

    test(
      'throws InsufficientCreditException if credit exceeds customer limit',
      () {
        // Customer has 80.0 available credit, requesting 90.0
        expect(
          () => engine.processCheckout(
            totalAmount: 100.00,
            tenders: const [
              PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 10.00),
              PaymentTenderModel(
                method: PaymentMethodEnum.customerCredit,
                amount: 90.00,
              ),
            ],
            registeredCustomer: customer,
          ),
          throwsA(isA<InsufficientCreditException>()),
        );
      },
    );

    test('throws ValidationException if total payment is insufficient', () {
      expect(
        () => engine.processCheckout(
          totalAmount: 100.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 70.00),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test(
      'calculates correct change when cash tender amount exceeds bill directly',
      () {
        final result = engine.processCheckout(
          totalAmount: 15.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 20.00),
          ],
        );

        expect(result.totalAmount, 15.00);
        expect(result.totalPaid, 15.00);
        expect(result.change, 5.00);
        expect(result.status, InvoiceStatusEnum.paid);
        expect(result.finalizedPayments.first.change, 5.00);
        expect(result.finalizedPayments.first.amount, 15.00);
        expect(result.finalizedPayments.first.tendered, 20.00);
      },
    );

    test(
      'calculates correct cash change in split multi-tender transaction',
      () {
        // Total $50.00: $20.00 paid on card, $50.00 cash handed
        final result = engine.processCheckout(
          totalAmount: 50.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.card, amount: 20.00),
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: 50.00),
          ],
        );

        expect(result.totalAmount, 50.00);
        expect(result.totalPaid, 50.00);
        expect(result.change, 20.00);
        expect(result.status, InvoiceStatusEnum.paid);
        final cashTender = result.finalizedPayments.firstWhere(
          (t) => t.method == PaymentMethodEnum.cash,
        );
        expect(cashTender.amount, 30.00);
        expect(cashTender.change, 20.00);
      },
    );

    test('rejects non-cash tender that exceeds invoice total', () {
      expect(
        () => engine.processCheckout(
          totalAmount: 50.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.card, amount: 60.00),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('rejects negative or zero payment tender amount', () {
      expect(
        () => engine.processCheckout(
          totalAmount: 50.00,
          tenders: const [
            PaymentTenderModel(method: PaymentMethodEnum.cash, amount: -10.00),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('handles zero total complimentary sale without error', () {
      final result = engine.processCheckout(
        totalAmount: 0.0,
        tenders: const [],
      );

      expect(result.totalAmount, 0.0);
      expect(result.totalPaid, 0.0);
      expect(result.change, 0.0);
      expect(result.status, InvoiceStatusEnum.paid);
    });
  });

  group('CashShiftCalculator Domain Tests', () {
    const calculator = CashShiftCalculator();

    test('reconciles balanced blind drop', () {
      final result = calculator.reconcileBlindDrop(
        openingBalance: 100.0,
        cashSales: 450.0,
        cashInjections: 50.0,
        cashWithdrawals: 100.0,
        actualCashCounted: 500.0,
      );

      expect(result.expectedBalance, 500.0);
      expect(result.difference, 0.0);
      expect(result.discrepancyStatus, ShiftDiscrepancyEnum.balanced);
    });

    test('reconciles shortage (faltante)', () {
      final result = calculator.reconcileBlindDrop(
        openingBalance: 100.0,
        cashSales: 450.0,
        cashInjections: 0.0,
        cashWithdrawals: 150.0,
        actualCashCounted: 395.0, // expected 400.0
      );

      expect(result.expectedBalance, 400.0);
      expect(result.difference, -5.0);
      expect(result.discrepancyStatus, ShiftDiscrepancyEnum.shortage);
    });

    test('reconciles surplus (sobrante)', () {
      final result = calculator.reconcileBlindDrop(
        openingBalance: 100.0,
        cashSales: 450.0,
        cashInjections: 0.0,
        cashWithdrawals: 150.0,
        actualCashCounted: 408.0, // expected 400.0
      );

      expect(result.expectedBalance, 400.0);
      expect(result.difference, 8.0);
      expect(result.discrepancyStatus, ShiftDiscrepancyEnum.surplus);
    });
  });
}

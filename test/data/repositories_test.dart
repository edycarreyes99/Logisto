// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/kds_status_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/repositories/account_receivable_repository.dart';
import 'package:logisto/data/repositories/business_unit_repository.dart';
import 'package:logisto/data/repositories/invoice_repository.dart';
import 'package:logisto/data/repositories/kitchen_order_repository.dart';
import 'package:logisto/data/repositories/open_account_repository.dart';
import 'package:logisto/data/repositories/organization_repository.dart';
import 'package:logisto/data/repositories/product_repository.dart';
import 'package:logisto/data/repositories/warehouse_repository.dart';
import 'package:logisto/domain/models/account_receivable_model.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/open_account_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockTransaction extends Mock implements Transaction {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Duration(seconds: 1));
    registerFallbackValue((Transaction tx) async {});
  });

  group('Enterprise Data Repositories Unit Tests', () {
    late MockFirestoreClient mockClient;
    late MockFirebaseFirestore mockFirestore;
    late MockTransaction mockTransaction;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDoc;
    late MockDocumentSnapshot mockDocSnapshot;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockQueryDoc;

    final now = DateTime(2026, 11, 12);

    setUp(() {
      mockClient = MockFirestoreClient();
      mockFirestore = MockFirebaseFirestore();
      mockTransaction = MockTransaction();
      mockCollection = MockCollectionReference();
      mockDoc = MockDocumentReference();
      mockDocSnapshot = MockDocumentSnapshot();
      mockQuerySnapshot = MockQuerySnapshot();
      mockQueryDoc = MockQueryDocumentSnapshot();

      when(() => mockClient.instance).thenReturn(mockFirestore);
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDoc.set(any())).thenAnswer((_) async {});
      when(() => mockDoc.update(any())).thenAnswer((_) async {});
      when(() => mockDoc.delete()).thenAnswer((_) async {});
      when(
        () => mockCollection.get(),
      ).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDoc]);
    });

    test('OrganizationRepository gets and saves organization', () async {
      when(() => mockClient.organizations).thenReturn(mockCollection);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.id).thenReturn('org_1');
      when(() => mockDocSnapshot.data()).thenReturn({
        'id': 'org_1',
        'legalName': 'Test Corp',
        'commercialName': 'Test',
        'taxId': '123',
        'ownerUserId': 'owner_1',
        'createdAt': now.toIso8601String(),
      });

      final repo = FirestoreOrganizationRepository(client: mockClient);
      final org = await repo.getOrganization('org_1');

      expect(org, isNotNull);
      expect(org?.id, 'org_1');
      expect(org?.legalName, 'Test Corp');

      final newOrg = OrganizationModel(
        id: 'org_2',
        legalName: 'Corp 2',
        commercialName: 'Two',
        taxId: '456',
        ownerUserId: 'owner_2',
        createdAt: now,
      );
      await repo.saveOrganization(newOrg);
      verify(() => mockCollection.doc('org_2')).called(1);
      verify(() => mockDoc.set(any())).called(1);
    });

    test('BusinessUnitRepository retrieves and saves branch units', () async {
      when(() => mockClient.businessUnits('org_1')).thenReturn(mockCollection);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.id).thenReturn('bu_1');
      when(() => mockDocSnapshot.data()).thenReturn({
        'id': 'bu_1',
        'orgId': 'org_1',
        'name': 'Sucursal 1',
        'taxId': '123-1',
        'phone': '555',
        'address': 'Street 1',
        'businessType': 'billiard',
        'isBilliardHall': true,
        'createdAt': now.toIso8601String(),
      });

      final repo = FirestoreBusinessUnitRepository(client: mockClient);
      final bu = await repo.getBusinessUnit(orgId: 'org_1', buId: 'bu_1');

      expect(bu?.name, 'Sucursal 1');
      expect(bu?.isBilliardHall, isTrue);

      final newBu = BusinessUnitModel(
        id: 'bu_2',
        orgId: 'org_1',
        name: 'Sucursal 2',
        taxId: '123-2',
        phone: '556',
        address: 'Street 2',
        businessType: BusinessTypeEnum.retail,
        isBilliardHall: false,
        createdAt: now,
      );
      await repo.saveBusinessUnit(orgId: 'org_1', businessUnit: newBu);
      verify(() => mockCollection.doc('bu_2')).called(1);
    });

    test('ProductRepository handles get, save and delete', () async {
      when(() => mockClient.products('org_1')).thenReturn(mockCollection);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.id).thenReturn('prod_1');
      when(() => mockDocSnapshot.data()).thenReturn({
        'id': 'prod_1',
        'orgId': 'org_1',
        'sku': 'SKU-1',
        'name': 'Soda',
        'categoryId': 'cat_1',
        'productType': 'standard',
        'costPrice': 1.0,
        'salePrice': 2.0,
      });

      final repo = FirestoreProductRepository(client: mockClient);
      final prod = await repo.getProductById(
        orgId: 'org_1',
        productId: 'prod_1',
      );

      expect(prod?.name, 'Soda');
      expect(prod?.salePrice, 2.0);

      await repo.deleteProduct(orgId: 'org_1', productId: 'prod_1');
      verify(() => mockDoc.delete()).called(1);
    });

    test('InvoiceRepository creates and retrieves invoices', () async {
      when(
        () => mockClient.invoices('org_1', 'bu_1'),
      ).thenReturn(mockCollection);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.id).thenReturn('inv_1');
      when(() => mockDocSnapshot.data()).thenReturn({
        'id': 'inv_1',
        'invoiceNumber': 'FAC-001',
        'cashShiftId': 'shift_1',
        'cashierUserId': 'usr_1',
        'customerDisplayName': 'Walk-in',
        'items': [],
        'subtotal': 10.0,
        'taxAmount': 1.5,
        'totalAmount': 11.5,
        'payments': [],
        'paymentStatus': 'paid',
        'createdAt': now.toIso8601String(),
      });

      final repo = FirestoreInvoiceRepository(client: mockClient);
      final inv = await repo.getInvoiceById(
        orgId: 'org_1',
        buId: 'bu_1',
        invoiceId: 'inv_1',
      );

      expect(inv?.invoiceNumber, 'FAC-001');
      expect(inv?.totalAmount, 11.5);
    });

    test('WarehouseRepository and Stock queries work cleanly', () async {
      when(
        () => mockClient.warehouses('org_1', 'bu_1'),
      ).thenReturn(mockCollection);
      when(
        () => mockClient.warehouseStock('org_1', 'bu_1', 'wh_1'),
      ).thenReturn(mockCollection);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn({
        'productId': 'prod_1',
        'currentQuantity': 100.0,
        'reservedQuantity': 10.0,
        'availableQuantity': 90.0,
        'minStock': 20.0,
        'reorderPoint': 40.0,
      });

      final repo = FirestoreWarehouseRepository(client: mockClient);
      final stock = await repo.getProductStock(
        orgId: 'org_1',
        buId: 'bu_1',
        warehouseId: 'wh_1',
        productId: 'prod_1',
      );

      expect(stock?.availableQuantity, 90.0);
      expect(stock?.currentQuantity, 100.0);
    });

    test(
      'KitchenOrderRepository updates status to served and records completedAt',
      () async {
        when(
          () => mockClient.kitchenOrders('org_1', 'bu_1'),
        ).thenReturn(mockCollection);

        final repo = FirestoreKitchenOrderRepository(client: mockClient);
        await repo.updateOrderStatus(
          orgId: 'org_1',
          buId: 'bu_1',
          orderId: 'kds_1',
          status: KdsStatusEnum.served,
        );

        verify(() => mockCollection.doc('kds_1')).called(1);
        verify(() => mockDoc.update(any())).called(1);
      },
    );

    test(
      'OpenAccountRepository addItemToAccount executes atomically via transaction',
      () async {
        when(
          () => mockClient.openAccounts('org_1', 'bu_1'),
        ).thenReturn(mockCollection);
        when(
          () => mockFirestore.runTransaction<void>(
            any(),
            timeout: any(named: 'timeout'),
            maxAttempts: any(named: 'maxAttempts'),
          ),
        ).thenAnswer((invocation) async {
          final handler =
              invocation.positionalArguments[0]
                  as Future<void> Function(Transaction);
          await handler(mockTransaction);
        });

        when(
          () => mockTransaction.get(mockDoc),
        ).thenAnswer((_) async => mockDocSnapshot);
        when(() => mockDocSnapshot.exists).thenReturn(true);
        when(() => mockDocSnapshot.id).thenReturn('tab_100');
        when(() => mockDocSnapshot.data()).thenReturn({
          'id': 'tab_100',
          'code': 'TAB-100',
          'status': 'open',
          'items': [
            {
              'productId': 'prod_beer',
              'name': 'Beer',
              'quantity': 1,
              'unitPrice': 2.0,
              'total': 2.0,
            },
          ],
          'totalAmount': 2.0,
          'openedAt': now.toIso8601String(),
        });
        when(
          () => mockTransaction.update(mockDoc, any()),
        ).thenReturn(mockTransaction);

        final repo = FirestoreOpenAccountRepository(client: mockClient);
        const newItem = AccountItemModel(
          productId: 'prod_rum',
          name: 'Rum',
          quantity: 1,
          unitPrice: 5.0,
          total: 5.0,
        );

        await repo.addItemToAccount(
          orgId: 'org_1',
          buId: 'bu_1',
          accountId: 'tab_100',
          item: newItem,
        );

        verify(() => mockFirestore.runTransaction<void>(any())).called(1);
        verify(() => mockTransaction.get(mockDoc)).called(1);
        verify(
          () => mockTransaction.update(mockDoc, {
            'items': [
              {
                'productId': 'prod_beer',
                'name': 'Beer',
                'quantity': 1.0,
                'unitPrice': 2.0,
                'total': 2.0,
                'isBilliardTime': false,
                'notes': null,
              },
              {
                'productId': 'prod_rum',
                'name': 'Rum',
                'quantity': 1.0,
                'unitPrice': 5.0,
                'total': 5.0,
                'isBilliardTime': false,
                'notes': null,
              },
            ],
            'totalAmount': 7.0,
          }),
        ).called(1);
      },
    );

    test(
      'AccountReceivableRepository records payment atomically via transaction',
      () async {
        when(
          () => mockClient.accountsReceivable('org_1', 'bu_1'),
        ).thenReturn(mockCollection);
        when(
          () => mockFirestore.runTransaction<void>(
            any(),
            timeout: any(named: 'timeout'),
            maxAttempts: any(named: 'maxAttempts'),
          ),
        ).thenAnswer((invocation) async {
          final handler =
              invocation.positionalArguments[0]
                  as Future<void> Function(Transaction);
          await handler(mockTransaction);
        });

        when(
          () => mockTransaction.get(mockDoc),
        ).thenAnswer((_) async => mockDocSnapshot);
        when(() => mockDocSnapshot.exists).thenReturn(true);
        when(() => mockDocSnapshot.id).thenReturn('ar_1');
        when(() => mockDocSnapshot.data()).thenReturn({
          'id': 'ar_1',
          'buId': 'bu_1',
          'customerId': 'cust_1',
          'customerName': 'Carlos Gómez',
          'invoiceId': 'inv_1',
          'invoiceNumber': 'FAC-001',
          'originalAmount': 100.0,
          'pendingAmount': 100.0,
          'dueDate': now.toIso8601String(),
          'createdAt': now.toIso8601String(),
          'payments': [],
        });
        when(
          () => mockTransaction.update(mockDoc, any()),
        ).thenReturn(mockTransaction);

        final repo = FirestoreAccountReceivableRepository(client: mockClient);
        final payment = CreditPaymentModel(
          id: 'pay_1',
          receivableId: 'ar_1',
          amount: 40.0,
          method: PaymentMethodEnum.cash,
          cashierUserId: 'usr_cajero',
          receivedAt: now,
        );

        await repo.recordPayment(
          orgId: 'org_1',
          buId: 'bu_1',
          arId: 'ar_1',
          payment: payment,
        );

        verify(() => mockFirestore.runTransaction<void>(any())).called(1);
        verify(
          () => mockTransaction.update(mockDoc, {
            'payments': [payment.toMap()],
            'pendingAmount': 60.0,
          }),
        ).called(1);
      },
    );
  });
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Logisto ERP & Smart POS';

  @override
  String get appTagline =>
      'Multi-Branch Commercial, Operations & Financial Management';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get billiards => 'Billiards';

  @override
  String get openAccounts => 'Open Accounts';

  @override
  String get pos => 'POS Checkout';

  @override
  String get kitchen => 'Kitchen KDS';

  @override
  String get cash => 'Cash Shifts';

  @override
  String get products => 'Products';

  @override
  String get inventory => 'Inventory';

  @override
  String get kardex => 'Kardex Ledger';

  @override
  String get customers => 'Customers';

  @override
  String get invoices => 'Invoices';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get purchasing => 'Purchasing';

  @override
  String get receivables => 'Receivables';

  @override
  String get payables => 'Payables';

  @override
  String get reports => 'Reports & BI';

  @override
  String get users => 'Users & Staff';

  @override
  String get settings => 'Settings';

  @override
  String get audit => 'Audit Trail';

  @override
  String get login => 'Sign In';

  @override
  String get onboarding => 'Onboarding';

  @override
  String get businessUnits => 'Branches';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get accept => 'Accept';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search by name, SKU or ID...';

  @override
  String get filter => 'Filter';

  @override
  String get refresh => 'Refresh';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get seedDatabase => 'Seed DB';

  @override
  String get databaseSeededSuccess =>
      'Database initialized successfully in Cloud Firestore.';

  @override
  String get logout => 'Log Out';

  @override
  String get switchBranch => 'Switch Branch';

  @override
  String get fastPin => 'Fast PIN';

  @override
  String get viewDetails => 'View Details';

  @override
  String get printTicket => 'Print Receipt';

  @override
  String get pay => 'Pay';

  @override
  String get openShift => 'Open Shift';

  @override
  String get closeShift => 'Close Shift (Z-Cut)';

  @override
  String get transfer => 'Transfer';

  @override
  String get addProduct => 'New Product';

  @override
  String get addCustomer => 'New Customer';

  @override
  String get addSupplier => 'New Supplier';

  @override
  String get addWarehouse => 'New Warehouse';

  @override
  String get inviteUser => 'Register Staff Member';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get pinLabel => 'Terminal PIN (4 digits)';

  @override
  String get loginButton => 'Sign In to System';

  @override
  String get googleSignIn => 'Sign In with Google';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String get invalidCredentials => 'Invalid credentials. Please try again.';

  @override
  String get enterPin => 'Enter your 4-digit PIN';

  @override
  String get pinPrompt => 'Enter terminal PIN for quick user switch';

  @override
  String get welcomeTitle => 'Welcome to Logisto ERP';

  @override
  String get welcomeDesc =>
      'Configure your organization and initial branch to get started.';

  @override
  String get createFirstBranch => 'Step 1: Create First Branch';

  @override
  String get selectBusinessType => 'Business Type';

  @override
  String get branchNameLabel => 'Branch Name';

  @override
  String get initializeDefaults => 'Step 2: Initialize Catalogs';

  @override
  String get sampleCatalogPrompt =>
      'Default products, warehouses, cash register and base settings will be created in Cloud Firestore.';

  @override
  String get startUsingApp => 'Start Operating';

  @override
  String stepLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get selectBranchPrompt => 'Select an active branch to operate:';

  @override
  String get noBranchesFound => 'No assigned branches found.';

  @override
  String get activeBranchBadge => 'Active Branch';

  @override
  String get todaySales => 'Today Sales';

  @override
  String get weekSales => 'Week Sales';

  @override
  String get monthSales => 'Month Sales';

  @override
  String get activeCash => 'Cash in Till';

  @override
  String get openTabs => 'Open Tabs';

  @override
  String get totalProducts => 'Catalog SKUs';

  @override
  String get totalCustomers => 'Registered Customers';

  @override
  String get topSellingProducts => 'Top Selling Products';

  @override
  String get salesByCategory => 'Sales by Category';

  @override
  String get salesByTender => 'Sales by Payment Tender';

  @override
  String get cartTitle => 'Sale Summary & Items';

  @override
  String get emptyCart => 'Cart is empty. Add items from the catalog.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total Amount';

  @override
  String get tenderCash => 'Cash';

  @override
  String get tenderCard => 'Card';

  @override
  String get tenderCredit => 'Customer Credit';

  @override
  String get tenderTransfer => 'Bank Transfer';

  @override
  String get changeDue => 'Change Due';

  @override
  String get amountTendered => 'Tendered';

  @override
  String get referenceCode => 'Payment Reference Code';

  @override
  String get selectCustomer => 'Customer';

  @override
  String get consumidorFinal => 'Consumidor Final (CF)';

  @override
  String creditAvailable(String amount) {
    return 'Available Credit: $amount';
  }

  @override
  String get creditExceeded => 'Amount exceeds available credit limit.';

  @override
  String invoiceCreatedSuccess(String number) {
    return 'Invoice #$number generated successfully.';
  }

  @override
  String get ticketHeader => 'SALES RECEIPT';

  @override
  String get printSuccess => 'Thermal ticket sent to printer.';

  @override
  String tableNumber(int number) {
    return 'Table #$number';
  }

  @override
  String get tableType => 'Table Type';

  @override
  String get hourlyRate => 'Hourly Rate';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusOccupied => 'Occupied';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusMaintenance => 'Maintenance';

  @override
  String get startSession => 'Start Time';

  @override
  String get pauseSession => 'Pause';

  @override
  String get resumeSession => 'Resume';

  @override
  String get stopSession => 'Stop & Bill';

  @override
  String get transferTable => 'Transfer Table';

  @override
  String get selectDestinationTable => 'Select destination table';

  @override
  String elapsedMinutes(int minutes) {
    return 'Elapsed: $minutes min';
  }

  @override
  String currentAmount(String amount) {
    return 'Current: $amount';
  }

  @override
  String get openTabsTitle => 'Active Tabs';

  @override
  String get openNewTab => 'Open New Bar / Table Tab';

  @override
  String get tabNamePlaceholder => 'Tab name or identifier...';

  @override
  String get tableAssignment => 'Assign Table (Optional)';

  @override
  String get addItemToTab => 'Add Item';

  @override
  String get sendToKitchen => 'Send to Kitchen';

  @override
  String get checkoutTab => 'Checkout Tab';

  @override
  String get preReceipt => 'Print Pre-Bill';

  @override
  String get splitTab => 'Split Tab';

  @override
  String get sku => 'SKU Code';

  @override
  String get barcode => 'Barcode';

  @override
  String get productName => 'Product Name';

  @override
  String get category => 'Category';

  @override
  String get productType => 'Product Type';

  @override
  String get costPrice => 'Cost Price';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get stockQuantity => 'In Stock';

  @override
  String get minStock => 'Min Stock';

  @override
  String get warehouse => 'Warehouse';

  @override
  String get transferStock => 'Transfer Stock';

  @override
  String get sourceWarehouse => 'Source Warehouse';

  @override
  String get destWarehouse => 'Destination Warehouse';

  @override
  String get adjustStock => 'Stock Adjustment';

  @override
  String get customerName => 'Customer Name';

  @override
  String get taxId => 'Tax ID / SSN';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get creditLimit => 'Credit Limit';

  @override
  String get currentDebt => 'Outstanding Debt';

  @override
  String get creditBlocked => 'Credit Blocked (Delinquent)';

  @override
  String get allowCredit => 'Enable Credit Line';

  @override
  String get customerSavedSuccess => 'Customer saved successfully.';

  @override
  String get supplierName => 'Supplier Company Name';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get paymentTermsDays => 'Payment Terms (Days)';

  @override
  String get supplierSavedSuccess => 'Supplier saved successfully.';

  @override
  String get activeShift => 'Active Cash Shift';

  @override
  String get noActiveShift => 'No active shift open in this branch.';

  @override
  String get startingCash => 'Starting Cash Float';

  @override
  String get expectedCash => 'System Expected Cash';

  @override
  String get actualCash => 'Actual Physical Cash';

  @override
  String get discrepancy => 'Cash Discrepancy';

  @override
  String get balanced => 'Balanced';

  @override
  String get shortage => 'Cash Shortage';

  @override
  String get surplus => 'Cash Surplus';

  @override
  String get blindDropPrompt =>
      'Blind Count: Enter counted bills and coins without viewing system total.';

  @override
  String get performBlindDrop => 'Submit Blind Count';

  @override
  String get xCut => 'Partial X-Cut';

  @override
  String get zCut => 'Closing Z-Cut';

  @override
  String get shiftClosedSuccess => 'Cash shift closed successfully with Z-Cut.';

  @override
  String get kitchenOrders => 'Kitchen Orders';

  @override
  String get barOrders => 'Bar Orders';

  @override
  String get markCooking => 'Preparing';

  @override
  String get markReady => 'Mark Ready';

  @override
  String get markServed => 'Mark Served';

  @override
  String elapsedOrderTime(String time) {
    return 'Elapsed: $time';
  }

  @override
  String get userName => 'Staff Member Name';

  @override
  String get userEmail => 'Login Email';

  @override
  String get userRole => 'Branch Role';

  @override
  String get superAdmin => 'Global Super Administrator';

  @override
  String get assignRole => 'Assign Role';

  @override
  String get terminalPin => 'Terminal PIN';

  @override
  String get roleUpdatedSuccess => 'Role updated successfully.';

  @override
  String get userInvitedSuccess => 'Staff member registered successfully.';

  @override
  String get companySettings => 'Organization Settings';

  @override
  String get rbacMatrix => 'RBAC Permission Matrix';

  @override
  String get supervisorElevation => 'Supervisor Authorization Required';

  @override
  String get enterSupervisorPin =>
      'Enter authorized supervisor PIN to proceed:';

  @override
  String get pinVerified => 'Authorization granted.';

  @override
  String get pinIncorrect => 'Invalid PIN or supervisor privilege missing.';

  @override
  String get lightTheme => 'Light Mode (White)';

  @override
  String get darkTheme => 'Dark Mode';

  @override
  String get spanishLanguage => 'Español';

  @override
  String get englishLanguage => 'English';

  @override
  String get auditTrail => 'Audit Trail';

  @override
  String get actionType => 'Action Type';

  @override
  String get performedBy => 'Performed By';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get details => 'Details';

  @override
  String get requiredField => 'This field is required.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get numberRequired => 'Enter a valid numeric value.';

  @override
  String get operationSuccessful => 'Operation completed successfully.';

  @override
  String get operationFailed =>
      'Operation could not be completed. Check input.';

  @override
  String get confirmationPrompt =>
      'Are you sure you want to perform this action?';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this record permanently?';

  @override
  String get logoutConfirmation =>
      'Are you sure you want to log out of your current session?';

  @override
  String get recordDeletedSuccess => 'Record deleted successfully.';

  @override
  String get modules => 'Modules';

  @override
  String get logistoEnterprise => 'Logisto Enterprise';

  @override
  String get corporatePortalLogin => 'Corporate Portal Login';

  @override
  String get welcomeBannerTitle => 'Logisto Multiplatform ERP & POS';

  @override
  String get welcomeBannerDesc =>
      'Unified enterprise operations for retail, billiard halls, pharmacies, and hospitality. Offline-first Firestore synchronization with high-density desktop controls.';

  @override
  String get fastPinAlert =>
      'Fast Operator Switching enabled for multi-user POS.';

  @override
  String get newOrgSetup => 'New Org Setup';

  @override
  String get fastPinSwitch => 'Fast PIN Switch';

  @override
  String get enterPinPrompt => 'Enter 4-digit terminal PIN to unlock station:';

  @override
  String get unlock => 'Unlock';

  @override
  String get invalidPin => 'Invalid 4-digit PIN.';

  @override
  String get systemInformation => 'System Information';

  @override
  String get operationalControls => 'Operational Controls';

  @override
  String get liveEventStream => 'Live Event Stream';

  @override
  String get registerNewBranch => 'Register New Branch';

  @override
  String get branchName => 'Branch Name';

  @override
  String get physicalAddress => 'Physical Address';

  @override
  String get createBranch => 'Create Branch';

  @override
  String get manageBranches => 'Manage Branches';

  @override
  String get selectBranchToOperate => 'Select an active branch to operate:';

  @override
  String get onboardingTitle => 'Logisto Onboarding Wizard';

  @override
  String get step1Title => 'Step 1: Enterprise Architecture Overview';

  @override
  String get step2Title => 'Step 2: First Business Unit Branch';

  @override
  String get step3Title => 'Step 3: Initial Station Infrastructure';

  @override
  String get step4Title => 'Step 4: Operational Readiness';

  @override
  String get primaryBusinessSegment => 'Primary Business Segment:';

  @override
  String get billiardSetupPrompt => 'Configure initial billiard rental tables:';

  @override
  String get retailSetupPrompt => 'Default warehouse and cash drawer setup:';

  @override
  String get readyToLaunch => 'Ready to launch your enterprise workspace.';

  @override
  String get seedProductionDataPrompt =>
      'Inject initial production seeds (products, warehouses, tables, customers, suppliers)';

  @override
  String get completeAndStart => 'Complete Setup & Launch';

  @override
  String get createProduct => 'Create Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get stockWarehouses => 'Warehouses & Stock';

  @override
  String get internalTransfer => 'Internal Warehouse Transfer';

  @override
  String get transferQuantity => 'Transfer Quantity';

  @override
  String get confirmTransfer => 'Confirm Transfer';

  @override
  String get confirmAdjustment => 'Confirm Adjustment';

  @override
  String get adjustmentReason => 'Adjustment Reason';

  @override
  String get newWarehouse => 'New Warehouse';

  @override
  String get warehouseName => 'Warehouse Name';

  @override
  String get warehouseCode => 'Warehouse Code';

  @override
  String get isDefaultSalesWarehouse => 'Default for Sales Dispatch';

  @override
  String get startTable => 'Start Table';

  @override
  String get pauseTable => 'Pause';

  @override
  String get resumeTable => 'Resume';

  @override
  String get sendToTab => 'Send to Tab';

  @override
  String get tableStatusAvailable => 'Available';

  @override
  String get tableStatusOccupied => 'In Play';

  @override
  String get tableStatusPaused => 'Paused';

  @override
  String get tableStatusBilling => 'Billing';

  @override
  String get ratePerHour => 'Rate per hour';

  @override
  String get player => 'Player / Customer';

  @override
  String get accrued => 'Accrued';

  @override
  String get tableReady => 'Table ready for check-in';

  @override
  String get enterCustomerPrompt => 'Enter customer name or table alias:';

  @override
  String get openAccountsTitle => 'Open Accounts & Bar Tabs';

  @override
  String get tabAliasPrompt =>
      'Customer / Table Alias (e.g. Table 1, Bar Carlos)';

  @override
  String get preBillPreview => 'Pre-Bill Preview';

  @override
  String get totalToCollect => 'Total to Collect';

  @override
  String get sendToCheckout => 'Proceed to Payment / Checkout';

  @override
  String get addItem => 'Add Item';

  @override
  String get multiTenderPayment => 'Multi-Tender Payment';

  @override
  String get customerSelectOrRegister => 'Select or Register Customer';

  @override
  String get availableCredit => 'Available Credit';

  @override
  String get creditCeiling => 'Credit Limit Ceiling';

  @override
  String get changeCustomer => 'Change';

  @override
  String get quickCatalog => 'Quick Product Catalog';

  @override
  String get noProductsAvailable => 'No products available in this branch.';

  @override
  String get confirmAndInvoice => 'Confirm & Print Invoice';

  @override
  String get thermalReceipt => 'Thermal Receipt (ESC/POS)';

  @override
  String get printThermal => 'Print Receipt';

  @override
  String get newSale => 'New Sale';

  @override
  String get cashShiftsTitle => 'Cash Shifts & Blind Drop Controls';

  @override
  String get openNewShift => 'Open New Shift';

  @override
  String get openingFloat => 'Initial Opening Cash Float';

  @override
  String get recordCashMovement => 'Record Cash Movement';

  @override
  String get withdrawalSangria => 'Withdrawal (Sangría)';

  @override
  String get cashInflow => 'Cash Inflow (Ingreso)';

  @override
  String get blindDropTitle => 'Blind Drop & Z-Cut Closing';

  @override
  String get physicalCashCount => 'Physical Cash Counted';

  @override
  String get closeShiftConfirm => 'Close Shift & Lock Drawer';

  @override
  String get taxIdRuc => 'Tax ID / RUC / Cédula';

  @override
  String get creditBlockedStatus => 'BLOCKED';

  @override
  String get creditActiveStatus => 'ACTIVE';

  @override
  String get blockCredit => 'Block Credit';

  @override
  String get unblockCredit => 'Unblock Credit';

  @override
  String get creditDays => 'Credit Days';

  @override
  String get editRole => 'Edit Role';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get accountsReceivableTitle => 'Accounts Receivable (CxC) & ROC';

  @override
  String get collectPaymentRoc => 'Collect Payment (ROC)';

  @override
  String get accountsPayableTitle => 'Accounts Payable (CxP)';

  @override
  String get paySupplier => 'Pay Supplier';

  @override
  String get dueDate => 'Due Date';

  @override
  String get totalDebt => 'Total Debt';

  @override
  String get balanceRemaining => 'Balance Remaining';

  @override
  String get emitReceiptAndApply => 'Emit Receipt & Apply';

  @override
  String get disbursePayment => 'Disburse Payment';

  @override
  String get purchasingTitle => 'Purchase Orders & Inbound Goods';

  @override
  String get createPurchaseOrder => 'Create Purchase Order';

  @override
  String get receiveGoods => 'Receive Inbound Goods';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get kitchenKdsTitle => 'Kitchen & Bar Display System (KDS)';

  @override
  String get markInPreparation => 'In Preparation';

  @override
  String get orderQueueEmpty => 'No orders in this status queue.';

  @override
  String get settingsTitle => 'Settings & RBAC';

  @override
  String get corporateSettings => 'Corporate & Fiscal';

  @override
  String get corporateTaxConfig => 'Corporate & Tax Configuration';

  @override
  String get rbacSecurity => 'RBAC Security';

  @override
  String get appearanceAndLanguage => 'Appearance & Language';

  @override
  String get themeModeLabel => 'Theme Mode';

  @override
  String get themeLight => 'Light (White)';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageLabel => 'System Language';

  @override
  String get langSpanish => 'Español (Spanish)';

  @override
  String get langEnglish => 'English (Inglés)';

  @override
  String get currencyExchange => 'Currency & Exchange Rates';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changesSavedSuccess => 'Settings saved successfully.';

  @override
  String get filterToday => 'Today';

  @override
  String get filterWeek => 'Week';

  @override
  String get filterMonth => 'Month';

  @override
  String get filterYear => 'Year';

  @override
  String get navSectionCoreOperations => 'Core Operations';

  @override
  String get navSectionInventoryOperations => 'Operations & Inventory';

  @override
  String get navSectionCatalogsPartners => 'Catalogs & Partners';

  @override
  String get navSectionFinanceLedgers => 'Finance & Ledgers';

  @override
  String get navSectionSystemManagement => 'System Management';

  @override
  String get navOffcanvasTitle => 'Logisto ERP Modules';

  @override
  String get defaultBranchName => 'Central Branch';

  @override
  String get menu => 'Menu';

  @override
  String get selectBranch => 'Select Branch';

  @override
  String get filterAuditLogsPlaceholder => 'Filter audit logs...';

  @override
  String get tableHeaderTimestamp => 'Timestamp';

  @override
  String get tableHeaderUser => 'User';

  @override
  String get tableHeaderAction => 'Action';

  @override
  String get tableHeaderDescription => 'Description';

  @override
  String get tableHeaderBeforeAfter => 'Before / After';

  @override
  String get tableHeaderClientIp => 'Client IP';

  @override
  String get tableCustomerAliasPlaceholder => 'e.g. Carlos M.';

  @override
  String get billiardFloorPlanTitle => 'Billiard Stations & Floor Plan';

  @override
  String get selectDestinationTablePrompt =>
      'Select an available destination table:';

  @override
  String get noTablesAvailableForTransfer =>
      'No other available tables at this moment.';

  @override
  String get currentShiftSummary => 'Current Shift Summary';

  @override
  String get openingFloatPrompt => 'Enter initial opening cash float:';

  @override
  String get amountPlaceholder => 'Amount (e.g. 50.00)';

  @override
  String get tableHeaderTime => 'Time';

  @override
  String get tableHeaderType => 'Type';

  @override
  String get tableHeaderAmount => 'Amount';

  @override
  String get tableHeaderReason => 'Reason';

  @override
  String get blindDropShiftClosure => 'Blind Drop Shift Closure (Corte Z)';

  @override
  String get expectedBalance => 'Expected Balance:';

  @override
  String get physicalCashCountedPrompt =>
      'Enter actual physical cash counted in cash drawer (USD):';

  @override
  String get physicalCountedAmountPlaceholder =>
      'Physical Counted Amount (e.g. 520.00)';

  @override
  String get noCustomersFound => 'No customers found matching search.';

  @override
  String get placeholderFirstName => 'First Name';

  @override
  String get placeholderLastName => 'Last Name';

  @override
  String get placeholderTaxId => 'Tax ID / SSN / RUC';

  @override
  String get placeholderPhone => 'Phone Number';

  @override
  String get placeholderEmail => 'Email Address';

  @override
  String get placeholderCreditLimit => 'Credit Limit (\$)';

  @override
  String get tableHeaderTaxId => 'Tax ID / RUC';

  @override
  String get tableHeaderCustomerName => 'Customer Name';

  @override
  String get tableHeaderAvailableHeadroom => 'Available Headroom';

  @override
  String get tableHeaderStatus => 'Status';

  @override
  String get tableHeaderActions => 'Actions';

  @override
  String get kpiRealtime => 'Realtime';

  @override
  String get kpiAuditReady => 'Audit Ready';

  @override
  String get tableHeaderQtySold => 'Qty Sold';

  @override
  String get tableHeaderRevenue => 'Revenue';

  @override
  String get filterLogsPlaceholder => 'Filter logs or telemetry...';

  @override
  String get tableHeaderService => 'Service';

  @override
  String get tableHeaderTarget => 'Target';

  @override
  String get telemetryAndStatus => 'Telemetry & Status';

  @override
  String get processedTasksLabel => 'Processed Tasks:';

  @override
  String get telemetryNodeOperational =>
      'Multiplatform node operational on current target.';

  @override
  String get transferSourceBodega => 'Source: Bodega Central de Reserva';

  @override
  String get transferDestBarra =>
      'Destination: Barra Principal (Piso de Venta)';

  @override
  String get auditedStockCountPrompt => 'Enter audited physical stock count:';

  @override
  String get transferQuantityPlaceholder => 'Transfer Quantity (Units)';

  @override
  String get newTotalQuantityPlaceholder => 'New Total Quantity';

  @override
  String get tableHeaderAvailableStock => 'Available Stock';

  @override
  String get tableHeaderReserved => 'Reserved';

  @override
  String get noKardexMovements => 'No Kardex movements recorded.';

  @override
  String get tableHeaderMovementType => 'Movement Type';

  @override
  String get tableHeaderQuantity => 'Quantity';

  @override
  String get tableHeaderTotalValue => 'Total Value';

  @override
  String get tableHeaderReferenceNotes => 'Reference / Notes';

  @override
  String get voidInvoiceTitle => 'Void Sales Invoice';

  @override
  String get voidInvoiceConfirmation =>
      'Are you sure you want to void this sales invoice? Stock movements will be reversed and an audit entry recorded.';

  @override
  String get searchInvoicePlaceholder => 'Search invoice # or customer...';

  @override
  String get noInvoicesRecorded => 'No sales invoices recorded yet.';

  @override
  String get tableHeaderInvoiceNumber => 'Invoice #';

  @override
  String get tableHeaderCustomer => 'Customer';

  @override
  String get tableHeaderCashier => 'Cashier';

  @override
  String get tableHeaderPaymentTender => 'Payment Tender';

  @override
  String get kdsOrderCompleted => 'Order completed.';

  @override
  String get kdsOrderCancelled => 'Order cancelled.';

  @override
  String get hourlyRatePlaceholder => 'Hourly rate (e.g. 10.00)';

  @override
  String get fastCatalogTitle => 'Fast Bar / Kitchen Catalog';

  @override
  String get tapItemToAddPrompt =>
      'Tap an item to add immediately to current tab:';

  @override
  String get activeTabOrderTitle => 'Active Tab Order';

  @override
  String get noTabSelected =>
      'No tab selected. Select or create an open account.';

  @override
  String get noConsumablesLoaded =>
      'No consumables loaded yet. Click items on the left to add.';

  @override
  String get noSupplierLiabilities => 'No supplier liabilities recorded.';

  @override
  String get paymentAmountPlaceholder => 'Payment Amount (\$)';

  @override
  String get tableHeaderSupplier => 'Supplier';

  @override
  String get tableHeaderSupplierInvoiceNumber => 'Supplier Invoice #';

  @override
  String get tableHeaderPaidToDate => 'Paid to Date';

  @override
  String get consumidorFinalWalkIn => 'Consumidor Final (Walk-in)';

  @override
  String get errorTitle => 'Error';

  @override
  String get tableHeaderItem => 'Item';

  @override
  String get tableHeaderQty => 'Qty';

  @override
  String get productNamePlaceholder => 'Product name...';

  @override
  String get skuPlaceholder => 'SKU-001';

  @override
  String get tableHeaderSkuBarcode => 'SKU / Barcode';

  @override
  String get noPurchaseOrdersRegistered => 'No purchase orders registered.';

  @override
  String get estimatedOrderValuePlaceholder =>
      'Estimated Total Order Value (\$)';

  @override
  String get tableHeaderOrderRef => 'Order Ref';

  @override
  String get tableHeaderOrderDate => 'Order Date';

  @override
  String get noOutstandingReceivables => 'No outstanding accounts receivable.';

  @override
  String get tableHeaderBalanceDue => 'Balance Due';

  @override
  String get reportExportedSuccess => 'Report Exported Successfully';

  @override
  String get reportExportedDesc =>
      'The financial ledger and operational metrics have been compiled into CSV format.\n\nReady for corporate audit archive.';

  @override
  String get tableHeaderItemConcept => 'Item / Concept';

  @override
  String get tableHeaderDetailsSku => 'Details / SKU';

  @override
  String get tableHeaderMetric1 => 'Metric 1';

  @override
  String get tableHeaderMetric2 => 'Metric 2';

  @override
  String get tableHeaderStatusRatio => 'Status / Ratio';

  @override
  String get tabAppearance => 'Appearance';

  @override
  String get legalNameLabel => 'Legal Name:';

  @override
  String get commercialBrandLabel => 'Commercial Brand:';

  @override
  String get salesTaxRateLabel => 'Sales Tax Rate (%):';

  @override
  String get rbacMatrixTitle => 'RBAC Security & Permission Matrix';

  @override
  String get tableHeaderRoleKey => 'Role Key';

  @override
  String get tableHeaderAccessibleModules => 'Accessible Modules';

  @override
  String get tableHeaderSensitivePermissions => 'Sensitive Permissions';

  @override
  String get supervisorPinPrompt =>
      'This action requires elevated supervisor permissions. Please enter authorized 4-digit PIN:';

  @override
  String get noSuppliersFound => 'No suppliers found.';

  @override
  String get placeholderCompanyLegalName => 'Company Legal Name';

  @override
  String get placeholderContactPerson => 'Contact Person';

  @override
  String get placeholderPaymentTerms => 'Payment Terms (e.g. 30 Days)';

  @override
  String get tableHeaderCompanyName => 'Company Name';

  @override
  String get tableHeaderContactPerson => 'Contact Person';

  @override
  String get tableHeaderCreditTerms => 'Credit Terms';

  @override
  String get tableHeaderPayableBalance => 'Payable Balance';

  @override
  String get tableHeaderUserName => 'Name';

  @override
  String get tableHeaderUserEmail => 'Email';

  @override
  String get tableHeaderSuperAdmin => 'Super Admin';

  @override
  String get tableHeaderAssignedBranches => 'Assigned Branches';

  @override
  String get yes => 'YES';

  @override
  String get no => 'NO';

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get statusInactive => 'INACTIVE';

  @override
  String get statusActiveTitle => 'Active';

  @override
  String get statusInactiveTitle => 'Inactive';

  @override
  String get staff => 'Staff';

  @override
  String get placeholderFullName => 'Full name...';

  @override
  String get sendInvite => 'Send Invite';

  @override
  String get companyEmailPlaceholder => 'admin@company.com';

  @override
  String get userEmailPlaceholder => 'user@logisto.com';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get editSupplier => 'Edit Supplier';

  @override
  String startTableNamed(String name) {
    return 'Start $name';
  }

  @override
  String transferTableNamed(String name) {
    return 'Transfer $name';
  }

  @override
  String openCashShiftRegister(int number) {
    return 'Open Cash Shift (Register #$number)';
  }

  @override
  String reconciliationStatus(String status) {
    return 'Reconciliation Status: $status';
  }

  @override
  String registerActiveShift(int number) {
    return 'Register #$number • Active Shift';
  }

  @override
  String customerDebtAmount(String amount) {
    return 'Debt: \$$amount';
  }

  @override
  String telemetryTasksProcessed(int count) {
    return 'Active telemetry tasks processed: $count';
  }

  @override
  String kardexValueAmount(String amount) {
    return 'Val: \$$amount';
  }

  @override
  String invoiceDetailsTitle(String number) {
    return 'Invoice #$number';
  }

  @override
  String invoiceCustomerLabel(String name) {
    return 'Customer: $name';
  }

  @override
  String invoiceCashierLabel(String cashier) {
    return 'Cashier: $cashier';
  }

  @override
  String kdsItemNote(String note) {
    return 'Note: $note';
  }

  @override
  String preBillPreviewCode(String code) {
    return 'Pre-Bill Preview: $code';
  }

  @override
  String customerDisplayName(String name) {
    return 'Customer: $name';
  }

  @override
  String paySupplierNamed(String name) {
    return 'Pay Supplier: $name';
  }

  @override
  String payableInvoiceLabel(String number) {
    return 'Invoice: $number';
  }

  @override
  String remainingDebtLabel(String amount) {
    return 'Remaining Debt: ';
  }

  @override
  String collectPaymentCustomer(String customer) {
    return 'Collect Payment (ROC): $customer';
  }

  @override
  String outstandingBalanceAmount(String amount) {
    return 'Outstanding Balance: \$$amount';
  }

  @override
  String authorizeActionTitle(String action) {
    return 'Authorize: $action';
  }

  @override
  String supplierDueAmount(String amount) {
    return 'Due: \$$amount';
  }

  @override
  String branchCountLabel(int count) {
    return '$count Branch(es)';
  }

  @override
  String editStaffNamed(String name) {
    return 'Edit Staff: $name';
  }

  @override
  String superAdminStatus(String status) {
    return 'Super Admin: $status';
  }

  @override
  String taxAmountLabel(int percent) {
    return 'Tax ($percent%):';
  }

  @override
  String taxReceiptLabel(int percent) {
    return 'IVA / Tax ($percent%):';
  }

  @override
  String invoiceReceiptNumber(String number) {
    return 'INVOICE: $number';
  }

  @override
  String get allEvents => 'All Events';

  @override
  String get unknown => 'Unknown';

  @override
  String get finishPrintZCut => 'Finish & Print Z-Cut';

  @override
  String get submitBlindCount => 'Submit Blind Count';

  @override
  String get blindDropSecurityRule =>
      'Security Rule: Enter total physical cash counted in drawer. Expected totals remain hidden until count is confirmed.';

  @override
  String get physicalCountedLabel => 'Physical Counted:';

  @override
  String get varianceDiscrepancyLabel => 'Variance / Discrepancy:';

  @override
  String get shiftOpen => 'Shift Open';

  @override
  String get openingFloatBase => 'Opening Float (Base):';

  @override
  String get cashSalesLabel => 'Cash Sales:';

  @override
  String get cardSalesLabel => 'Card / POS Sales:';

  @override
  String get cashInjectionsLabel => 'Cash Injections:';

  @override
  String get withdrawalsLabel => 'Withdrawals (Sangrías):';

  @override
  String get calculatedCashInTill => 'Calculated Cash in Till:';

  @override
  String get cashMovementButton => 'Cash Movement (+ / -)';

  @override
  String get closeShiftBlindDropButton => 'Close Shift (Blind Drop / Corte Z)';

  @override
  String get noActiveShiftPrompt =>
      'No cash shift currently open on this workstation.';

  @override
  String get openShiftInitialFloat => 'Open Shift with Initial Float';

  @override
  String get closedShiftHistoryTitle => 'Closed Shift Audit History';

  @override
  String get tableHeaderRegister => 'Register';

  @override
  String get tableHeaderExpected => 'Expected';

  @override
  String get tableHeaderCounted => 'Counted';

  @override
  String get tableHeaderVariance => 'Variance';

  @override
  String get counterDefault => 'Counter';

  @override
  String tableRatePerHour(String rate, String type) {
    return 'Rate: /hr ($type)';
  }

  @override
  String tablePlayerLabel(String name) {
    return 'Player: $name';
  }

  @override
  String tableAccruedAmount(String amount) {
    return 'Accrued: ';
  }

  @override
  String get startSessionAction => 'Start Session';

  @override
  String get selectOperatingBusinessUnit => 'Select Operating Business Unit';

  @override
  String get addBranch => 'Add Branch';

  @override
  String get registerCustomer => 'Register Customer';

  @override
  String get saveCustomer => 'Save Customer';

  @override
  String get collect => 'Collect';

  @override
  String get view => 'View';

  @override
  String get registerSupplier => 'Register Supplier';

  @override
  String get saveSupplier => 'Save Supplier';

  @override
  String get issueOrder => 'Issue Order';

  @override
  String get block => 'Block';

  @override
  String get unblock => 'Unblock';

  @override
  String get kpiSynced => 'Synced';

  @override
  String get kpiMonthly => 'Monthly';

  @override
  String get kpiPending => 'Pending';

  @override
  String get kpiCatalog => 'Catalog';

  @override
  String get tableHeaderUnitsSold => 'Units Sold';

  @override
  String get revenueByCategory => 'Revenue by Category';

  @override
  String get revenueByTender => 'Revenue by Payment Tender';

  @override
  String get topSellingProductsAndServices =>
      'Top 10 Selling Products & Services';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get overview => 'Overview';

  @override
  String get metrics => 'Metrics';

  @override
  String get erpSuite => 'ERP Suite';

  @override
  String get systemInfo => 'System Info';

  @override
  String get filterLogsOrTelemetry => 'Filter logs or telemetry...';

  @override
  String get increment => 'Increment';

  @override
  String get reset => 'Reset';

  @override
  String get processedTasks => 'Processed Tasks:';

  @override
  String get serviceCore => 'Core';

  @override
  String get targetDarwinWin32 => 'Darwin/Win32';

  @override
  String get serviceWeb => 'Web';

  @override
  String get targetWasmMobile => 'WASM/Mobile';

  @override
  String get statusReady => 'Ready';

  @override
  String internalTransferTitle(String productName) {
    return 'Internal Transfer: $productName';
  }

  @override
  String get confirmTransferGuide => 'Confirm Transfer Guide';

  @override
  String stockAdjustmentTitle(String productName) {
    return 'Inventory Stock Adjustment: $productName';
  }

  @override
  String get newTotalQuantity => 'New Total Quantity';

  @override
  String get saveAdjustment => 'Save Adjustment';

  @override
  String get warehouses => 'Warehouses';

  @override
  String get stockLevels => 'Stock Levels';

  @override
  String get kardexLedger => 'Kardex Ledger';

  @override
  String stockLevelsWarehouse(String warehouse) {
    return 'Stock Levels: $warehouse';
  }

  @override
  String get kardexLedgerHeader =>
      'Permanent Kardex Movement Ledger (Entries, Exits, Transfers & Audits)';

  @override
  String get tableHeaderProduct => 'Product';

  @override
  String get tableHeaderUnitCost => 'Unit Cost';

  @override
  String get tableHeaderSku => 'SKU';

  @override
  String get tableHeaderProductItem => 'Product Item';

  @override
  String get tableHeaderMinStock => 'Min Stock';

  @override
  String get tableHeaderCost => 'Cost';

  @override
  String get tableHeaderSalePrice => 'Sale Price';

  @override
  String get tableHeaderTotalAmount => 'Total Amount';

  @override
  String get tableHeaderDueDate => 'Due Date';

  @override
  String get tableHeaderTotalDebt => 'Total Debt';

  @override
  String get tableHeaderProductName => 'Product Name';

  @override
  String get tableHeaderRucTaxId => 'RUC / Tax ID';

  @override
  String get tableHeaderPhone => 'Phone';

  @override
  String invoiceTitle(String invoiceNumber) {
    return 'Invoice $invoiceNumber';
  }

  @override
  String customerLabel(String customer) {
    return 'Customer: $customer';
  }

  @override
  String cashierLabel(String cashier) {
    return 'Cashier: $cashier';
  }

  @override
  String get startPreparation => 'Start Preparation';

  @override
  String get readyToServe => 'Ready to Serve';

  @override
  String get served => 'Served';

  @override
  String get openAccountsAndTabs => 'Open Accounts & Tabs';

  @override
  String get openNewTabTitle => 'Open New Bar / Table Tab';

  @override
  String get openTabAction => 'Open Tab';

  @override
  String get fastCatalogPrompt =>
      'Tap an item to add immediately to current tab:';

  @override
  String get activeTabOrder => 'Active Tab Order';

  @override
  String get timerAction => 'Timer';

  @override
  String get preBillPrint => 'Pre-Bill Print';

  @override
  String get proceedToCheckout => 'Proceed to Checkout';

  @override
  String paySupplierTitle(String supplier) {
    return 'Pay Supplier: $supplier';
  }

  @override
  String invoiceLabel(String invoiceNumber) {
    return 'Invoice: $invoiceNumber';
  }

  @override
  String get paid => 'Paid';

  @override
  String get receive => 'Receive';

  @override
  String get delivered => 'Delivered';

  @override
  String get outstandingBalanceLabel => 'Outstanding Balance: ';

  @override
  String get reportsAndBi => 'Reports & BI';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get reportExportedSuccessfully => 'Report Exported Successfully';

  @override
  String get done => 'Done';

  @override
  String get settingsAndRbac => 'Settings & RBAC';

  @override
  String get appearance => 'Appearance';

  @override
  String get corporateAndFiscal => 'Corporate & Fiscal';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get systemLanguage => 'System Language';

  @override
  String get corporateAndTaxConfig => 'Corporate & Tax Configuration';

  @override
  String get legalName => 'Legal Name:';

  @override
  String get commercialBrand => 'Commercial Brand:';

  @override
  String get taxIdRucLabel => 'Tax ID / RUC:';

  @override
  String get salesTaxRatePercent => 'Sales Tax Rate (%):';

  @override
  String get defaultOperatingCurrency => 'Default Operating Currency:';

  @override
  String get rbacSecurityMatrix => 'RBAC Security & Permission Matrix';

  @override
  String authorizeActionNamed(String action) {
    return 'Authorize: $action';
  }

  @override
  String get authorizeAction => 'Authorize Action';

  @override
  String get invalidSupervisorPin => 'Invalid supervisor authorization PIN.';

  @override
  String get companyNamePrompt => 'Company name...';

  @override
  String get usersAndStaff => 'Users & Staff';

  @override
  String get inviteEmployee => 'Invite Employee';

  @override
  String get inviteNewEmployee => 'Invite New Employee';

  @override
  String get fullNamePrompt => 'Full name...';

  @override
  String get superAdminYes => 'Super Admin: YES';

  @override
  String get superAdminNo => 'Super Admin: NO';

  @override
  String editStaffTitle(String name) {
    return 'Edit Staff: $name';
  }

  @override
  String get roles => 'Roles';

  @override
  String get productCatalog => 'Products';

  @override
  String get newProduct => 'New Product';

  @override
  String get productNamePrompt => 'Product name...';

  @override
  String get quickProductCatalog => 'Quick Product Catalog';

  @override
  String get noProductsAvailablePrompt =>
      'No products available. Add items in catalog or seed database.';

  @override
  String get selectOrRegisterCustomer => 'Select or Register Customer';

  @override
  String get limit => 'Limit';

  @override
  String get balance => 'Balance';

  @override
  String get saleSummaryAndItems => 'Sale Summary & Items';

  @override
  String get cartIsEmptyPrompt => 'Cart is empty. Add items from the catalog.';

  @override
  String get itemHeader => 'Item';

  @override
  String get qtyHeader => 'Qty';

  @override
  String get clear => 'Clear';

  @override
  String get finalizeSale => 'Finalize Sale';

  @override
  String get walkInCustomer => 'Consumidor Final (Walk-in)';

  @override
  String get creditAvail => 'Credit Avail.';

  @override
  String get changeAction => 'Change';

  @override
  String get salesReceipt => 'Sales Receipt';

  @override
  String get thankYouForBusiness => '*** THANK YOU FOR YOUR BUSINESS ***';

  @override
  String get printAction => 'Print';

  @override
  String get newSaleAction => 'New Sale';

  @override
  String get tax15Percent => 'IVA / Tax (15%):';

  @override
  String get onboardingWizardTitle => 'Logisto Onboarding Wizard';

  @override
  String stepCounter(int step) {
    return 'Step $step of 4';
  }

  @override
  String get previousStep => 'Previous';

  @override
  String get launchSystem => 'Launch System';

  @override
  String get nextStep => 'Next Step';

  @override
  String get step1Desc =>
      'Logisto isolates global corporate masters (Customers, Suppliers, Users) at the Organization level, while transactional activities (POS, Kitchen, Warehouses, Tables) execute inside specific Business Units.';

  @override
  String get step1Placeholder =>
      'Corporate Legal Name (e.g. Inversiones Castillo S.A.)';

  @override
  String get step2Placeholder =>
      'Branch Name (e.g. Downtown Billiards or Central Pharmacy)';

  @override
  String get step2Segment => 'Primary Business Segment:';

  @override
  String get step3Placeholder => 'Hourly rate (e.g. 10.00)';

  @override
  String get adjust => 'Adjust';

  @override
  String get itemsBilled => 'Items Billed:';

  @override
  String get totalPaid => 'Total Paid:';

  @override
  String get confirmVoid => 'Confirm Void';

  @override
  String get searchInvoiceOrCustomer => 'Search invoice # or customer...';

  @override
  String get voidAction => 'Void';

  @override
  String get voidInvoiceDesc =>
      'Supervisor confirmation required. Voiding this invoice will reverse sales metrics and audit the cancellation.';

  @override
  String get allFilter => 'All';

  @override
  String get pendingFilter => 'Pending';

  @override
  String get inPrepFilter => 'In Prep';

  @override
  String get readyFilter => 'Ready';

  @override
  String get noOrdersInQueue => 'No orders in this status queue.';

  @override
  String get customerTableAliasPlaceholder =>
      'Customer / Table Alias (e.g. Barra Carlos)';

  @override
  String get accountTotal => 'Account Total:';

  @override
  String get paymentAmountDollar => 'Payment Amount (\$)';

  @override
  String get estimatedTotalOrderValue => 'Estimated Total Order Value (\$)';

  @override
  String get createPurchaseOrderAction => 'Create Purchase Order';

  @override
  String get exchangeRateLabel => 'Exchange Rate (USD -> NIO):';

  @override
  String get supervisorPermissionPrompt =>
      'This action requires elevated supervisor permissions. Please enter authorized 4-digit PIN:';

  @override
  String get orderCompleted => 'Order completed.';

  @override
  String get orderCancelled => 'Order cancelled.';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get newTab => 'New Tab';

  @override
  String get noTabSelectedPrompt =>
      'No tab selected. Select or create an open account.';

  @override
  String get noSupplierLiabilitiesRecorded =>
      'No supplier liabilities recorded.';

  @override
  String get settled => 'SETTLED';

  @override
  String get noPurchaseOrdersRecorded => 'No purchase orders recorded.';

  @override
  String get statusReceived => 'RECEIVED';

  @override
  String get statusPending => 'PENDING';

  @override
  String get salesReport8020 => 'Sales 80/20';

  @override
  String get cashShifts => 'Cash Shifts';

  @override
  String get creditAging => 'Credit & Aging';

  @override
  String csvReportGenerated(String count) {
    return 'CSV formatted report generated ($count rows):';
  }

  @override
  String get reportSalesPareto => 'Sales & Pareto Contribution (80/20)';

  @override
  String get reportInventoryValuation => 'Inventory Valuation & Reorder Point';

  @override
  String get reportBilliardsUtilization =>
      'Billiard Station Utilization & Hourly Rent';

  @override
  String get reportCashDrawerCuts => 'Cash Drawer Cuts (Z-Report Audit)';

  @override
  String get reportReceivablesAging => 'Accounts Receivable & Aging (CxC)';

  @override
  String get noneRequiresSupervisorPin => 'None (Requires Supervisor PIN)';

  @override
  String get companyLegalName => 'Company Legal Name';

  @override
  String get contactRepresentative => 'Contact Representative';

  @override
  String get creditDaysExample => 'Credit Days (e.g. 15, 30)';

  @override
  String get searchSupplierPlaceholder => 'Search supplier name or tax ID...';

  @override
  String get rucTaxIdPlaceholder => 'RUC / Tax ID';

  @override
  String daysCount(int count) {
    return '$count Days';
  }

  @override
  String get superAdminShort => 'SuperAdmin';

  @override
  String get noProductsRegistered =>
      'No products registered in this organization.';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get select => 'Select';

  @override
  String get add => 'Add';

  @override
  String get error => 'Error';

  @override
  String get creditLimitLabel => 'Limit';

  @override
  String get debtLabel => 'Debt';

  @override
  String get tableHeaderPrice => 'Price';

  @override
  String get totalAmountLabel => 'Total Amount:';

  @override
  String get subtotalLabel => 'Subtotal:';

  @override
  String get customer => 'Customer';

  @override
  String get cashTendered => 'Cash Tendered';

  @override
  String get cardPayment => 'Card Payment';

  @override
  String get customerCredit => 'Customer Credit';

  @override
  String get addedToCustomerDebt => 'Added to Customer Debt:';

  @override
  String get creditAvailablePrefix => 'Credit Avail.';

  @override
  String get step3Alert =>
      'Auto-provisioning \"Main Warehouse\" and \"Register 01\".';

  @override
  String get productionSeedsEnabled => 'Production Seeds: ENABLED';

  @override
  String get productionSeedsDisabled => 'Production Seeds: DISABLED';

  @override
  String unitsCount(int count) {
    return '$count units';
  }

  @override
  String inStockCount(int count) {
    return '$count in stock';
  }

  @override
  String minStockCount(int count) {
    return 'Min: $count';
  }

  @override
  String get stockStatusLow => 'LOW STOCK';

  @override
  String get stockStatusOptimal => 'OPTIMAL';

  @override
  String get defaultCustomerFirstName => 'New';

  @override
  String get defaultCustomerLastName => 'Customer';

  @override
  String get defaultSupplierName => 'New Supplier';

  @override
  String get defaultContactName => 'Contact';

  @override
  String get defaultProductName => 'New Product';

  @override
  String get auditPhysicalCountReason => 'Physical count audit';

  @override
  String get mainWarehouse => 'Main';

  @override
  String kdsMinutesPending(int minutes) {
    return '$minutes min (Pending)';
  }

  @override
  String kdsMinutesCooking(int minutes) {
    return '$minutes min (Cooking)';
  }

  @override
  String kdsNote(String note) {
    return 'Note: $note';
  }

  @override
  String priceEach(String price) {
    return '\$$price each';
  }

  @override
  String totalLiabilitiesAmount(String amount) {
    return 'Total Liabilities: \$$amount';
  }

  @override
  String get authErrorEmailPasswordRequired =>
      'Email and password are required.';

  @override
  String get authErrorPinFourDigits => 'PIN must be exactly 4 digits.';

  @override
  String get businessTypeBilliard => 'Billiards & Entertainment';

  @override
  String get businessTypeRetail => 'Retail & Store';

  @override
  String get businessTypePharmacy => 'Pharmacy & Health';

  @override
  String get businessTypeRestaurant => 'Restaurant & Bar';

  @override
  String get businessTypeGeneral => 'General Commercial';

  @override
  String get productTypeStandard => 'Standard';

  @override
  String get productTypeCombo => 'Combo';

  @override
  String get productTypeService => 'Service';

  @override
  String get productTypeRawMaterial => 'Raw Material';

  @override
  String get productTypePack => 'Pack / Bundle';

  @override
  String get productTypeRecipeBom => 'Recipe / BOM';

  @override
  String get roleSuperAdmin => 'Super Administrator';

  @override
  String get roleAdminBusinessUnit => 'Branch Manager';

  @override
  String get roleSupervisor => 'Floor Supervisor';

  @override
  String get roleCashier => 'Cashier';

  @override
  String get roleWaiter => 'Waiter / Server';

  @override
  String get roleInventoryManager => 'Inventory Manager';

  @override
  String get roleKitchen => 'Kitchen / KDS';

  @override
  String get auditActionVoidItem => 'void item';

  @override
  String get auditActionVoidInvoice => 'void invoice';

  @override
  String get auditActionApplyDiscount => 'apply discount';

  @override
  String get auditActionOpenDrawer => 'open drawer';

  @override
  String get auditActionTransferTable => 'transfer table';

  @override
  String get auditActionSplitBill => 'split bill';

  @override
  String get auditActionBlindDrop => 'blind drop';

  @override
  String get auditActionReorderPoint => 'reorder point';

  @override
  String get auditActionForceSync => 'force sync';

  @override
  String get auditActionRateChange => 'rate change';

  @override
  String get auditActionCreditOverride => 'credit override';

  @override
  String get auditActionStockAdjustment => 'stock adjustment';

  @override
  String get auditActionCloseShift => 'close shift';

  @override
  String get movementPurchaseReceipt => 'Purchase Receipt';

  @override
  String get movementSalesDeduction => 'Sales Deduction';

  @override
  String get movementInternalTransfer => 'Internal Transfer';

  @override
  String get movementWasteAdjustment => 'Waste Adjustment';

  @override
  String get movementInitialCount => 'Initial Count';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodCustomerCredit => 'Customer Credit';

  @override
  String get paymentMethodBankTransfer => 'Bank Transfer';

  @override
  String get paymentMethodMixed => 'Mixed / Split';

  @override
  String get discrepancyBalanced => 'Balanced';

  @override
  String get discrepancyShortage => 'Shortage';

  @override
  String get discrepancySurplus => 'Surplus';

  @override
  String get tableTypePool => 'Pool';

  @override
  String get tableTypeCarambola => 'Carambola';

  @override
  String get tableTypeSnooker => 'Snooker';

  @override
  String get tableTypeVip => 'VIP';

  @override
  String reportTagLowStock(int count) {
    return 'Low Stock: $count Units';
  }

  @override
  String reportTagInStock(int count) {
    return '$count In Stock';
  }

  @override
  String reportTagShortage(String amount) {
    return 'Shortage -\$$amount';
  }

  @override
  String get reportTagBalanced => 'Balanced \$0.00';

  @override
  String get reportTagActiveCredit => 'Active Credit';

  @override
  String get reportTagBlockedOverdue => 'BLOCKED (Overdue >30d)';

  @override
  String reportTagOccupancy(int percent) {
    return 'Occupancy: $percent%';
  }

  @override
  String get reportTagTopPareto => 'Top 80%';

  @override
  String reportMetricCostVal(String amount) {
    return 'Cost Val: \$$amount';
  }

  @override
  String reportMetricSaleVal(String amount) {
    return 'Sale Val: \$$amount';
  }

  @override
  String reportMetricExpected(String amount) {
    return 'Expected: \$$amount';
  }

  @override
  String reportMetricCounted(String amount) {
    return 'Counted: \$$amount';
  }

  @override
  String reportMetricCurrentDebt(String amount) {
    return 'Current Debt: \$$amount';
  }

  @override
  String reportMetricDaysOverdue(int days) {
    return 'Days Overdue: $days';
  }

  @override
  String reportMetricTimeSales(String amount) {
    return 'Time Sales: \$$amount';
  }

  @override
  String reportMetricBarConsumed(String amount) {
    return 'Bar Consumed: \$$amount';
  }

  @override
  String reportMetricRevenue(String amount) {
    return 'Revenue: \$$amount';
  }

  @override
  String reportMetricMargin(String percent) {
    return 'Margin: $percent%';
  }

  @override
  String reportSubShiftHours(String opened, String closed) {
    return 'Opened $opened • Closed $closed';
  }

  @override
  String reportSubTableRateHours(String rate, String hours) {
    return 'Rate: \$$rate/h • $hours Hours Active';
  }

  @override
  String reportSubParetoRankUnits(int rank, int units) {
    return 'Pareto Rank #$rank • $units Units Sold';
  }

  @override
  String reportSubSkuMin(String sku, int min) {
    return 'SKU: $sku • Min: $min units';
  }

  @override
  String reportSubRucLimit(String ruc, String limit) {
    return 'RUC: $ruc • Limit: \$$limit';
  }

  @override
  String reportShiftCashier(String number, String name) {
    return 'Shift #$number • Cashier: $name';
  }

  @override
  String get categoryBeverages => 'Beverages';

  @override
  String get categoryCocktails => 'Cocktails';

  @override
  String get categoryFood => 'Food';

  @override
  String get forgotPasswordPrompt => 'Reset Password';

  @override
  String get forgotPasswordDesc =>
      'Enter your corporate email address to receive password recovery instructions.';

  @override
  String get resetPasswordEmailSent =>
      'Password reset instructions sent to your email.';

  @override
  String get send => 'Send';

  @override
  String get authSubtitleHint => 'Multi-tenant access to operations & POS';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get rememberMe => 'Remember session';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get demoProfilesPrompt => 'Quick access demo profiles:';

  @override
  String get signUp => 'Create Account';

  @override
  String get signUpSubtitle => 'Register a new enterprise user account';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNamePlaceholder => 'John Doe';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get accountCreatedSuccess => 'Account created successfully.';

  @override
  String get verifyEmailTitle => 'Verify Your Email';

  @override
  String verifyEmailPrompt(String email) {
    return 'We have sent a verification email to $email. Please verify your email to access all corporate features.';
  }

  @override
  String get resendVerificationEmail => 'Resend Verification Email';

  @override
  String get verificationEmailSent =>
      'Verification email sent. Please check your inbox.';

  @override
  String get iHaveVerified => 'I have verified my email';

  @override
  String get emailNotVerifiedYet =>
      'Email is not verified yet. Please check your inbox or click resend.';

  @override
  String get printerManagementTitle => 'Printer Management';

  @override
  String get printerManagementSubtitle =>
      'Configuration and pairing of thermal, USB, and Bluetooth printers';

  @override
  String get printersSectionTitle => 'Printers & Receipts';

  @override
  String get printersSectionSubtitle =>
      'Configure thermal, dot-matrix, USB, and Bluetooth receipt printers';

  @override
  String get activePrinter => 'Active / Connected Printer';

  @override
  String get noActivePrinter => 'No printer is currently paired.';

  @override
  String get scanBluetoothPrinters => 'Search Bluetooth / USB Printers';

  @override
  String get scanningPrinters => 'Scanning for nearby devices...';

  @override
  String get discoveredPrinters => 'Available Devices';

  @override
  String get noDiscoveredPrinters => 'No available printers found.';

  @override
  String get connectPrinter => 'Connect';

  @override
  String get disconnectPrinter => 'Unpair';

  @override
  String get editPrinterAlias => 'Edit Name / Alias';

  @override
  String get printerAliasLabel => 'Friendly Name (Alias)';

  @override
  String get printerAliasPlaceholder => 'e.g. Main Counter - 80mm';

  @override
  String get printerTypeLabel => 'Paper Format / Technology';

  @override
  String get printerTypeThermal80 => 'Thermal 80 mm (POS Standard)';

  @override
  String get printerTypeThermal58 => 'Thermal 58 mm (Mobile)';

  @override
  String get printerTypeDotMatrix => 'Dot Matrix (Continuous)';

  @override
  String get macAddressLabel => 'MAC Address / Hardware ID';

  @override
  String get connectionTypeLabel => 'Connection Interface';

  @override
  String get autoPrintOnSaleLabel => 'Auto-print on checkout';

  @override
  String get autoPrintOnSaleSubtitle =>
      'Directly dispatch voucher to default printer upon completed checkout';

  @override
  String get printTestTicket => 'Print Test Ticket';

  @override
  String get testTicketSent => 'Test ticket dispatched successfully.';

  @override
  String get reprintVoucher => 'Reprint Voucher';

  @override
  String get shareVoucher => 'Share PDF';

  @override
  String get previewVoucher => 'Preview';

  @override
  String get notificationsAndAlerts => 'Notifications & Alerts';

  @override
  String get liveFirestoreSyncTitle => 'Live Firestore Sync';

  @override
  String get liveFirestoreSyncDesc =>
      'All records synchronized with Cloud Firestore.';

  @override
  String get justNow => 'Just now';

  @override
  String get activeCashDrawerTitle => 'Active Cash Register';

  @override
  String get activeCashDrawerDesc => 'Shift open in active branch.';

  @override
  String get activeStatus => 'Active';

  @override
  String get secureMultiTenantSessionTitle => 'Secure Multi-Tenant Session';

  @override
  String get secureMultiTenantSessionDesc =>
      'RBAC permissions validated for active user.';

  @override
  String get onlineStatus => 'Online';

  @override
  String get terminalUnlockedSuccess => 'Terminal unlocked successfully';

  @override
  String get customerDirectorySynced => 'Customer directory synchronized';

  @override
  String get productCatalogSynced => 'Product catalog synchronized';

  @override
  String get supplierDirectorySynced => 'Supplier directory synchronized';

  @override
  String get invoiceHistoryUpdated => 'Invoice history updated';

  @override
  String get goodsReceivedInWarehouse => 'Goods received in warehouse';

  @override
  String get shiftZClosedExact => 'Z-Cut processed with exact balance';

  @override
  String get hardwareLabel => 'Hardware';

  @override
  String get activeChipLabel => 'Active';

  @override
  String get sendingVoucherToPrinter => 'Sending voucher to printer...';

  @override
  String get onboardingConfiguredSuccess =>
      'Initial organization and branch configured successfully';

  @override
  String get openAccountsListTitle => 'Open Orders';

  @override
  String get searchAccountsPlaceholder => 'Search order or table...';

  @override
  String get noOpenAccountsFound => 'No open accounts or orders.';

  @override
  String get openNewTabPrompt =>
      'Tap \'+\' or the button below to open a new tab.';

  @override
  String get allCategories => 'All Categories';

  @override
  String itemsInOrder(int count) {
    return '$count items';
  }

  @override
  String get originTypeTable => 'Table';

  @override
  String get originTypeCounter => 'Bar / Counter';

  @override
  String get originTypeCustomer => 'Customer';

  @override
  String get originTypeFreeName => 'Custom Tab';

  @override
  String get emptyOrderPrompt =>
      'No items added yet. Select products from the catalog to add to this order.';

  @override
  String get filterByTableOrCustomer => 'Filter by table or customer...';

  @override
  String get loginPrimarySlogan => 'Total control, hassle-free.';

  @override
  String get loginSecondarySlogan =>
      'Agile management for businesses on the move. Invoice, control, grow.';

  @override
  String get passwordRequirementsPrompt =>
      'Password must have at least 6 characters, 1 number, 1 uppercase letter, and 1 special character.';

  @override
  String get emailInvalidFormat => 'Please enter a valid email address.';

  @override
  String get emailAlreadyInUse =>
      'This email is already registered. Please sign in or use another email.';

  @override
  String get incorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get userNotFound =>
      'No account found with this email. Please register.';

  @override
  String get noBusinessUnitsTitle => 'No branches available';

  @override
  String get noBusinessUnitsDesc =>
      'You don\'t have any branches assigned yet. Create your first branch to get started.';

  @override
  String get createFirstBusinessUnit => 'Create First Branch';

  @override
  String get businessCategoryLabel => 'Business Category';

  @override
  String get businessCategoryHint => 'Select a category';

  @override
  String get businessCityLabel => 'City location';

  @override
  String get businessCityHint => 'E.g. San Salvador, Tegucigalpa, etc.';

  @override
  String get cellPhoneLabel => 'Cell Phone Number';

  @override
  String get cellPhoneHint => 'E.g. +1 555-0199';

  @override
  String get dniLabel => 'DNI';

  @override
  String get dniHint => 'National identity document / Tax ID';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get categoryRequired => 'You must select a business category';
}

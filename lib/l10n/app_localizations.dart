import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Logisto ERP & Smart POS'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Multi-Branch Commercial, Operations & Financial Management'**
  String get appTagline;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @billiards.
  ///
  /// In en, this message translates to:
  /// **'Billiards'**
  String get billiards;

  /// No description provided for @openAccounts.
  ///
  /// In en, this message translates to:
  /// **'Open Accounts'**
  String get openAccounts;

  /// No description provided for @pos.
  ///
  /// In en, this message translates to:
  /// **'POS Checkout'**
  String get pos;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen KDS'**
  String get kitchen;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash Shifts'**
  String get cash;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @kardex.
  ///
  /// In en, this message translates to:
  /// **'Kardex Ledger'**
  String get kardex;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @purchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get purchasing;

  /// No description provided for @receivables.
  ///
  /// In en, this message translates to:
  /// **'Receivables'**
  String get receivables;

  /// No description provided for @payables.
  ///
  /// In en, this message translates to:
  /// **'Payables'**
  String get payables;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports & BI'**
  String get reports;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users & Staff'**
  String get users;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @audit.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get audit;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @businessUnits.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get businessUnits;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name, SKU or ID...'**
  String get searchPlaceholder;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @seedDatabase.
  ///
  /// In en, this message translates to:
  /// **'Seed DB'**
  String get seedDatabase;

  /// No description provided for @databaseSeededSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database initialized successfully in Cloud Firestore.'**
  String get databaseSeededSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @switchBranch.
  ///
  /// In en, this message translates to:
  /// **'Switch Branch'**
  String get switchBranch;

  /// No description provided for @fastPin.
  ///
  /// In en, this message translates to:
  /// **'Fast PIN'**
  String get fastPin;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @printTicket.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get printTicket;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @openShift.
  ///
  /// In en, this message translates to:
  /// **'Open Shift'**
  String get openShift;

  /// No description provided for @closeShift.
  ///
  /// In en, this message translates to:
  /// **'Close Shift (Z-Cut)'**
  String get closeShift;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get addProduct;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get addCustomer;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'New Supplier'**
  String get addSupplier;

  /// No description provided for @addWarehouse.
  ///
  /// In en, this message translates to:
  /// **'New Warehouse'**
  String get addWarehouse;

  /// No description provided for @inviteUser.
  ///
  /// In en, this message translates to:
  /// **'Register Staff Member'**
  String get inviteUser;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @pinLabel.
  ///
  /// In en, this message translates to:
  /// **'Terminal PIN (4 digits)'**
  String get pinLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In to System'**
  String get loginButton;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get googleSignIn;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN'**
  String get enterPin;

  /// No description provided for @pinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter terminal PIN for quick user switch'**
  String get pinPrompt;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Logisto ERP'**
  String get welcomeTitle;

  /// No description provided for @welcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure your organization and initial branch to get started.'**
  String get welcomeDesc;

  /// No description provided for @createFirstBranch.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Create First Branch'**
  String get createFirstBranch;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get selectBusinessType;

  /// No description provided for @branchNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchNameLabel;

  /// No description provided for @initializeDefaults.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Initialize Catalogs'**
  String get initializeDefaults;

  /// No description provided for @sampleCatalogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Default products, warehouses, cash register and base settings will be created in Cloud Firestore.'**
  String get sampleCatalogPrompt;

  /// No description provided for @startUsingApp.
  ///
  /// In en, this message translates to:
  /// **'Start Operating'**
  String get startUsingApp;

  /// No description provided for @stepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepLabel(int current, int total);

  /// No description provided for @selectBranchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select an active branch to operate:'**
  String get selectBranchPrompt;

  /// No description provided for @noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No assigned branches found.'**
  String get noBranchesFound;

  /// No description provided for @activeBranchBadge.
  ///
  /// In en, this message translates to:
  /// **'Active Branch'**
  String get activeBranchBadge;

  /// No description provided for @todaySales.
  ///
  /// In en, this message translates to:
  /// **'Today Sales'**
  String get todaySales;

  /// No description provided for @weekSales.
  ///
  /// In en, this message translates to:
  /// **'Week Sales'**
  String get weekSales;

  /// No description provided for @monthSales.
  ///
  /// In en, this message translates to:
  /// **'Month Sales'**
  String get monthSales;

  /// No description provided for @activeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash in Till'**
  String get activeCash;

  /// No description provided for @openTabs.
  ///
  /// In en, this message translates to:
  /// **'Open Tabs'**
  String get openTabs;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Catalog SKUs'**
  String get totalProducts;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Registered Customers'**
  String get totalCustomers;

  /// No description provided for @topSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Products'**
  String get topSellingProducts;

  /// No description provided for @salesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Sales by Category'**
  String get salesByCategory;

  /// No description provided for @salesByTender.
  ///
  /// In en, this message translates to:
  /// **'Sales by Payment Tender'**
  String get salesByTender;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Sale Summary & Items'**
  String get cartTitle;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty. Add items from the catalog.'**
  String get emptyCart;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total;

  /// No description provided for @tenderCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get tenderCash;

  /// No description provided for @tenderCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get tenderCard;

  /// No description provided for @tenderCredit.
  ///
  /// In en, this message translates to:
  /// **'Customer Credit'**
  String get tenderCredit;

  /// No description provided for @tenderTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get tenderTransfer;

  /// No description provided for @changeDue.
  ///
  /// In en, this message translates to:
  /// **'Change Due'**
  String get changeDue;

  /// No description provided for @amountTendered.
  ///
  /// In en, this message translates to:
  /// **'Tendered'**
  String get amountTendered;

  /// No description provided for @referenceCode.
  ///
  /// In en, this message translates to:
  /// **'Payment Reference Code'**
  String get referenceCode;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get selectCustomer;

  /// No description provided for @consumidorFinal.
  ///
  /// In en, this message translates to:
  /// **'Consumidor Final (CF)'**
  String get consumidorFinal;

  /// No description provided for @creditAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Credit: {amount}'**
  String creditAvailable(String amount);

  /// No description provided for @creditExceeded.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds available credit limit.'**
  String get creditExceeded;

  /// No description provided for @invoiceCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number} generated successfully.'**
  String invoiceCreatedSuccess(String number);

  /// No description provided for @ticketHeader.
  ///
  /// In en, this message translates to:
  /// **'SALES RECEIPT'**
  String get ticketHeader;

  /// No description provided for @printSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thermal ticket sent to printer.'**
  String get printSuccess;

  /// No description provided for @tableNumber.
  ///
  /// In en, this message translates to:
  /// **'Table #{number}'**
  String tableNumber(int number);

  /// No description provided for @tableType.
  ///
  /// In en, this message translates to:
  /// **'Table Type'**
  String get tableType;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusAvailable;

  /// No description provided for @statusOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get statusOccupied;

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get statusMaintenance;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startSession;

  /// No description provided for @pauseSession.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseSession;

  /// No description provided for @resumeSession.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeSession;

  /// No description provided for @stopSession.
  ///
  /// In en, this message translates to:
  /// **'Stop & Bill'**
  String get stopSession;

  /// No description provided for @transferTable.
  ///
  /// In en, this message translates to:
  /// **'Transfer Table'**
  String get transferTable;

  /// No description provided for @selectDestinationTable.
  ///
  /// In en, this message translates to:
  /// **'Select destination table'**
  String get selectDestinationTable;

  /// No description provided for @elapsedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Elapsed: {minutes} min'**
  String elapsedMinutes(int minutes);

  /// No description provided for @currentAmount.
  ///
  /// In en, this message translates to:
  /// **'Current: {amount}'**
  String currentAmount(String amount);

  /// No description provided for @openTabsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Tabs'**
  String get openTabsTitle;

  /// No description provided for @openNewTab.
  ///
  /// In en, this message translates to:
  /// **'Open New Bar / Table Tab'**
  String get openNewTab;

  /// No description provided for @tabNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tab name or identifier...'**
  String get tabNamePlaceholder;

  /// No description provided for @tableAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assign Table (Optional)'**
  String get tableAssignment;

  /// No description provided for @addItemToTab.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItemToTab;

  /// No description provided for @sendToKitchen.
  ///
  /// In en, this message translates to:
  /// **'Send to Kitchen'**
  String get sendToKitchen;

  /// No description provided for @checkoutTab.
  ///
  /// In en, this message translates to:
  /// **'Checkout Tab'**
  String get checkoutTab;

  /// No description provided for @preReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print Pre-Bill'**
  String get preReceipt;

  /// No description provided for @splitTab.
  ///
  /// In en, this message translates to:
  /// **'Split Tab'**
  String get splitTab;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU Code'**
  String get sku;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productType;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price'**
  String get costPrice;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get salePrice;

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get stockQuantity;

  /// No description provided for @minStock.
  ///
  /// In en, this message translates to:
  /// **'Min Stock'**
  String get minStock;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @transferStock.
  ///
  /// In en, this message translates to:
  /// **'Transfer Stock'**
  String get transferStock;

  /// No description provided for @sourceWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Source Warehouse'**
  String get sourceWarehouse;

  /// No description provided for @destWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Destination Warehouse'**
  String get destWarehouse;

  /// No description provided for @adjustStock.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustment'**
  String get adjustStock;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / SSN'**
  String get taxId;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @creditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get creditLimit;

  /// No description provided for @currentDebt.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Debt'**
  String get currentDebt;

  /// No description provided for @creditBlocked.
  ///
  /// In en, this message translates to:
  /// **'Credit Blocked (Delinquent)'**
  String get creditBlocked;

  /// No description provided for @allowCredit.
  ///
  /// In en, this message translates to:
  /// **'Enable Credit Line'**
  String get allowCredit;

  /// No description provided for @customerSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Customer saved successfully.'**
  String get customerSavedSuccess;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Company Name'**
  String get supplierName;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @paymentTermsDays.
  ///
  /// In en, this message translates to:
  /// **'Payment Terms (Days)'**
  String get paymentTermsDays;

  /// No description provided for @supplierSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Supplier saved successfully.'**
  String get supplierSavedSuccess;

  /// No description provided for @activeShift.
  ///
  /// In en, this message translates to:
  /// **'Active Cash Shift'**
  String get activeShift;

  /// No description provided for @noActiveShift.
  ///
  /// In en, this message translates to:
  /// **'No active shift open in this branch.'**
  String get noActiveShift;

  /// No description provided for @startingCash.
  ///
  /// In en, this message translates to:
  /// **'Starting Cash Float'**
  String get startingCash;

  /// No description provided for @expectedCash.
  ///
  /// In en, this message translates to:
  /// **'System Expected Cash'**
  String get expectedCash;

  /// No description provided for @actualCash.
  ///
  /// In en, this message translates to:
  /// **'Actual Physical Cash'**
  String get actualCash;

  /// No description provided for @discrepancy.
  ///
  /// In en, this message translates to:
  /// **'Cash Discrepancy'**
  String get discrepancy;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @shortage.
  ///
  /// In en, this message translates to:
  /// **'Cash Shortage'**
  String get shortage;

  /// No description provided for @surplus.
  ///
  /// In en, this message translates to:
  /// **'Cash Surplus'**
  String get surplus;

  /// No description provided for @blindDropPrompt.
  ///
  /// In en, this message translates to:
  /// **'Blind Count: Enter counted bills and coins without viewing system total.'**
  String get blindDropPrompt;

  /// No description provided for @performBlindDrop.
  ///
  /// In en, this message translates to:
  /// **'Submit Blind Count'**
  String get performBlindDrop;

  /// No description provided for @xCut.
  ///
  /// In en, this message translates to:
  /// **'Partial X-Cut'**
  String get xCut;

  /// No description provided for @zCut.
  ///
  /// In en, this message translates to:
  /// **'Closing Z-Cut'**
  String get zCut;

  /// No description provided for @shiftClosedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cash shift closed successfully with Z-Cut.'**
  String get shiftClosedSuccess;

  /// No description provided for @kitchenOrders.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Orders'**
  String get kitchenOrders;

  /// No description provided for @barOrders.
  ///
  /// In en, this message translates to:
  /// **'Bar Orders'**
  String get barOrders;

  /// No description provided for @markCooking.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get markCooking;

  /// No description provided for @markReady.
  ///
  /// In en, this message translates to:
  /// **'Mark Ready'**
  String get markReady;

  /// No description provided for @markServed.
  ///
  /// In en, this message translates to:
  /// **'Mark Served'**
  String get markServed;

  /// No description provided for @elapsedOrderTime.
  ///
  /// In en, this message translates to:
  /// **'Elapsed: {time}'**
  String elapsedOrderTime(String time);

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Staff Member Name'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'Login Email'**
  String get userEmail;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'Branch Role'**
  String get userRole;

  /// No description provided for @superAdmin.
  ///
  /// In en, this message translates to:
  /// **'Global Super Administrator'**
  String get superAdmin;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign Role'**
  String get assignRole;

  /// No description provided for @terminalPin.
  ///
  /// In en, this message translates to:
  /// **'Terminal PIN'**
  String get terminalPin;

  /// No description provided for @roleUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully.'**
  String get roleUpdatedSuccess;

  /// No description provided for @userInvitedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Staff member registered successfully.'**
  String get userInvitedSuccess;

  /// No description provided for @companySettings.
  ///
  /// In en, this message translates to:
  /// **'Organization Settings'**
  String get companySettings;

  /// No description provided for @rbacMatrix.
  ///
  /// In en, this message translates to:
  /// **'RBAC Permission Matrix'**
  String get rbacMatrix;

  /// No description provided for @supervisorElevation.
  ///
  /// In en, this message translates to:
  /// **'Supervisor Authorization Required'**
  String get supervisorElevation;

  /// No description provided for @enterSupervisorPin.
  ///
  /// In en, this message translates to:
  /// **'Enter authorized supervisor PIN to proceed:'**
  String get enterSupervisorPin;

  /// No description provided for @pinVerified.
  ///
  /// In en, this message translates to:
  /// **'Authorization granted.'**
  String get pinVerified;

  /// No description provided for @pinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN or supervisor privilege missing.'**
  String get pinIncorrect;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Mode (White)'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkTheme;

  /// No description provided for @spanishLanguage.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanishLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @auditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get auditTrail;

  /// No description provided for @actionType.
  ///
  /// In en, this message translates to:
  /// **'Action Type'**
  String get actionType;

  /// No description provided for @performedBy.
  ///
  /// In en, this message translates to:
  /// **'Performed By'**
  String get performedBy;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @numberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid numeric value.'**
  String get numberRequired;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully.'**
  String get operationSuccessful;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation could not be completed. Check input.'**
  String get operationFailed;

  /// No description provided for @confirmationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to perform this action?'**
  String get confirmationPrompt;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record permanently?'**
  String get deleteConfirmation;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your current session?'**
  String get logoutConfirmation;

  /// No description provided for @recordDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Record deleted successfully.'**
  String get recordDeletedSuccess;

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @logistoEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Logisto Enterprise'**
  String get logistoEnterprise;

  /// No description provided for @corporatePortalLogin.
  ///
  /// In en, this message translates to:
  /// **'Corporate Portal Login'**
  String get corporatePortalLogin;

  /// No description provided for @welcomeBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Logisto Multiplatform ERP & POS'**
  String get welcomeBannerTitle;

  /// No description provided for @welcomeBannerDesc.
  ///
  /// In en, this message translates to:
  /// **'Unified enterprise operations for retail, billiard halls, pharmacies, and hospitality. Offline-first Firestore synchronization with high-density desktop controls.'**
  String get welcomeBannerDesc;

  /// No description provided for @fastPinAlert.
  ///
  /// In en, this message translates to:
  /// **'Fast Operator Switching enabled for multi-user POS.'**
  String get fastPinAlert;

  /// No description provided for @newOrgSetup.
  ///
  /// In en, this message translates to:
  /// **'New Org Setup'**
  String get newOrgSetup;

  /// No description provided for @fastPinSwitch.
  ///
  /// In en, this message translates to:
  /// **'Fast PIN Switch'**
  String get fastPinSwitch;

  /// No description provided for @enterPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit terminal PIN to unlock station:'**
  String get enterPinPrompt;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @invalidPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid 4-digit PIN.'**
  String get invalidPin;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @operationalControls.
  ///
  /// In en, this message translates to:
  /// **'Operational Controls'**
  String get operationalControls;

  /// No description provided for @liveEventStream.
  ///
  /// In en, this message translates to:
  /// **'Live Event Stream'**
  String get liveEventStream;

  /// No description provided for @registerNewBranch.
  ///
  /// In en, this message translates to:
  /// **'Register New Branch'**
  String get registerNewBranch;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchName;

  /// No description provided for @physicalAddress.
  ///
  /// In en, this message translates to:
  /// **'Physical Address'**
  String get physicalAddress;

  /// No description provided for @createBranch.
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get createBranch;

  /// No description provided for @manageBranches.
  ///
  /// In en, this message translates to:
  /// **'Manage Branches'**
  String get manageBranches;

  /// No description provided for @selectBranchToOperate.
  ///
  /// In en, this message translates to:
  /// **'Select an active branch to operate:'**
  String get selectBranchToOperate;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Logisto Onboarding Wizard'**
  String get onboardingTitle;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Enterprise Architecture Overview'**
  String get step1Title;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2: First Business Unit Branch'**
  String get step2Title;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Initial Station Infrastructure'**
  String get step3Title;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Operational Readiness'**
  String get step4Title;

  /// No description provided for @primaryBusinessSegment.
  ///
  /// In en, this message translates to:
  /// **'Primary Business Segment:'**
  String get primaryBusinessSegment;

  /// No description provided for @billiardSetupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Configure initial billiard rental tables:'**
  String get billiardSetupPrompt;

  /// No description provided for @retailSetupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Default warehouse and cash drawer setup:'**
  String get retailSetupPrompt;

  /// No description provided for @readyToLaunch.
  ///
  /// In en, this message translates to:
  /// **'Ready to launch your enterprise workspace.'**
  String get readyToLaunch;

  /// No description provided for @seedProductionDataPrompt.
  ///
  /// In en, this message translates to:
  /// **'Inject initial production seeds (products, warehouses, tables, customers, suppliers)'**
  String get seedProductionDataPrompt;

  /// No description provided for @completeAndStart.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup & Launch'**
  String get completeAndStart;

  /// No description provided for @createProduct.
  ///
  /// In en, this message translates to:
  /// **'Create Product'**
  String get createProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @stockWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses & Stock'**
  String get stockWarehouses;

  /// No description provided for @internalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Internal Warehouse Transfer'**
  String get internalTransfer;

  /// No description provided for @transferQuantity.
  ///
  /// In en, this message translates to:
  /// **'Transfer Quantity'**
  String get transferQuantity;

  /// No description provided for @confirmTransfer.
  ///
  /// In en, this message translates to:
  /// **'Confirm Transfer'**
  String get confirmTransfer;

  /// No description provided for @confirmAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Adjustment'**
  String get confirmAdjustment;

  /// No description provided for @adjustmentReason.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Reason'**
  String get adjustmentReason;

  /// No description provided for @newWarehouse.
  ///
  /// In en, this message translates to:
  /// **'New Warehouse'**
  String get newWarehouse;

  /// No description provided for @warehouseName.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Name'**
  String get warehouseName;

  /// No description provided for @warehouseCode.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Code'**
  String get warehouseCode;

  /// No description provided for @isDefaultSalesWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Default for Sales Dispatch'**
  String get isDefaultSalesWarehouse;

  /// No description provided for @startTable.
  ///
  /// In en, this message translates to:
  /// **'Start Table'**
  String get startTable;

  /// No description provided for @pauseTable.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseTable;

  /// No description provided for @resumeTable.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeTable;

  /// No description provided for @sendToTab.
  ///
  /// In en, this message translates to:
  /// **'Send to Tab'**
  String get sendToTab;

  /// No description provided for @tableStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get tableStatusAvailable;

  /// No description provided for @tableStatusOccupied.
  ///
  /// In en, this message translates to:
  /// **'In Play'**
  String get tableStatusOccupied;

  /// No description provided for @tableStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get tableStatusPaused;

  /// No description provided for @tableStatusBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get tableStatusBilling;

  /// No description provided for @ratePerHour.
  ///
  /// In en, this message translates to:
  /// **'Rate per hour'**
  String get ratePerHour;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player / Customer'**
  String get player;

  /// No description provided for @accrued.
  ///
  /// In en, this message translates to:
  /// **'Accrued'**
  String get accrued;

  /// No description provided for @tableReady.
  ///
  /// In en, this message translates to:
  /// **'Table ready for check-in'**
  String get tableReady;

  /// No description provided for @enterCustomerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name or table alias:'**
  String get enterCustomerPrompt;

  /// No description provided for @openAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Accounts & Bar Tabs'**
  String get openAccountsTitle;

  /// No description provided for @tabAliasPrompt.
  ///
  /// In en, this message translates to:
  /// **'Customer / Table Alias (e.g. Table 1, Bar Carlos)'**
  String get tabAliasPrompt;

  /// No description provided for @preBillPreview.
  ///
  /// In en, this message translates to:
  /// **'Pre-Bill Preview'**
  String get preBillPreview;

  /// No description provided for @totalToCollect.
  ///
  /// In en, this message translates to:
  /// **'Total to Collect'**
  String get totalToCollect;

  /// No description provided for @sendToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment / Checkout'**
  String get sendToCheckout;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @multiTenderPayment.
  ///
  /// In en, this message translates to:
  /// **'Multi-Tender Payment'**
  String get multiTenderPayment;

  /// No description provided for @customerSelectOrRegister.
  ///
  /// In en, this message translates to:
  /// **'Select or Register Customer'**
  String get customerSelectOrRegister;

  /// No description provided for @availableCredit.
  ///
  /// In en, this message translates to:
  /// **'Available Credit'**
  String get availableCredit;

  /// No description provided for @creditCeiling.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit Ceiling'**
  String get creditCeiling;

  /// No description provided for @changeCustomer.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeCustomer;

  /// No description provided for @quickCatalog.
  ///
  /// In en, this message translates to:
  /// **'Quick Product Catalog'**
  String get quickCatalog;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available in this branch.'**
  String get noProductsAvailable;

  /// No description provided for @confirmAndInvoice.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Print Invoice'**
  String get confirmAndInvoice;

  /// No description provided for @thermalReceipt.
  ///
  /// In en, this message translates to:
  /// **'Thermal Receipt (ESC/POS)'**
  String get thermalReceipt;

  /// No description provided for @printThermal.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get printThermal;

  /// No description provided for @newSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSale;

  /// No description provided for @cashShiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Shifts & Blind Drop Controls'**
  String get cashShiftsTitle;

  /// No description provided for @openNewShift.
  ///
  /// In en, this message translates to:
  /// **'Open New Shift'**
  String get openNewShift;

  /// No description provided for @openingFloat.
  ///
  /// In en, this message translates to:
  /// **'Initial Opening Cash Float'**
  String get openingFloat;

  /// No description provided for @recordCashMovement.
  ///
  /// In en, this message translates to:
  /// **'Record Cash Movement'**
  String get recordCashMovement;

  /// No description provided for @withdrawalSangria.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal (Sangría)'**
  String get withdrawalSangria;

  /// No description provided for @cashInflow.
  ///
  /// In en, this message translates to:
  /// **'Cash Inflow (Ingreso)'**
  String get cashInflow;

  /// No description provided for @blindDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Blind Drop & Z-Cut Closing'**
  String get blindDropTitle;

  /// No description provided for @physicalCashCount.
  ///
  /// In en, this message translates to:
  /// **'Physical Cash Counted'**
  String get physicalCashCount;

  /// No description provided for @closeShiftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close Shift & Lock Drawer'**
  String get closeShiftConfirm;

  /// No description provided for @taxIdRuc.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / RUC / Cédula'**
  String get taxIdRuc;

  /// No description provided for @creditBlockedStatus.
  ///
  /// In en, this message translates to:
  /// **'BLOCKED'**
  String get creditBlockedStatus;

  /// No description provided for @creditActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get creditActiveStatus;

  /// No description provided for @blockCredit.
  ///
  /// In en, this message translates to:
  /// **'Block Credit'**
  String get blockCredit;

  /// No description provided for @unblockCredit.
  ///
  /// In en, this message translates to:
  /// **'Unblock Credit'**
  String get unblockCredit;

  /// No description provided for @creditDays.
  ///
  /// In en, this message translates to:
  /// **'Credit Days'**
  String get creditDays;

  /// No description provided for @editRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @accountsReceivableTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable (CxC) & ROC'**
  String get accountsReceivableTitle;

  /// No description provided for @collectPaymentRoc.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment (ROC)'**
  String get collectPaymentRoc;

  /// No description provided for @accountsPayableTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable (CxP)'**
  String get accountsPayableTitle;

  /// No description provided for @paySupplier.
  ///
  /// In en, this message translates to:
  /// **'Pay Supplier'**
  String get paySupplier;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @totalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get totalDebt;

  /// No description provided for @balanceRemaining.
  ///
  /// In en, this message translates to:
  /// **'Balance Remaining'**
  String get balanceRemaining;

  /// No description provided for @emitReceiptAndApply.
  ///
  /// In en, this message translates to:
  /// **'Emit Receipt & Apply'**
  String get emitReceiptAndApply;

  /// No description provided for @disbursePayment.
  ///
  /// In en, this message translates to:
  /// **'Disburse Payment'**
  String get disbursePayment;

  /// No description provided for @purchasingTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders & Inbound Goods'**
  String get purchasingTitle;

  /// No description provided for @createPurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase Order'**
  String get createPurchaseOrder;

  /// No description provided for @receiveGoods.
  ///
  /// In en, this message translates to:
  /// **'Receive Inbound Goods'**
  String get receiveGoods;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @kitchenKdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kitchen & Bar Display System (KDS)'**
  String get kitchenKdsTitle;

  /// No description provided for @markInPreparation.
  ///
  /// In en, this message translates to:
  /// **'In Preparation'**
  String get markInPreparation;

  /// No description provided for @orderQueueEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders in this status queue.'**
  String get orderQueueEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & RBAC'**
  String get settingsTitle;

  /// No description provided for @corporateSettings.
  ///
  /// In en, this message translates to:
  /// **'Corporate & Fiscal'**
  String get corporateSettings;

  /// No description provided for @corporateTaxConfig.
  ///
  /// In en, this message translates to:
  /// **'Corporate & Tax Configuration'**
  String get corporateTaxConfig;

  /// No description provided for @rbacSecurity.
  ///
  /// In en, this message translates to:
  /// **'RBAC Security'**
  String get rbacSecurity;

  /// No description provided for @appearanceAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Language'**
  String get appearanceAndLanguage;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeLabel;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light (White)'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get languageLabel;

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español (Spanish)'**
  String get langSpanish;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English (Inglés)'**
  String get langEnglish;

  /// No description provided for @currencyExchange.
  ///
  /// In en, this message translates to:
  /// **'Currency & Exchange Rates'**
  String get currencyExchange;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get changesSavedSuccess;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get filterWeek;

  /// No description provided for @filterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get filterMonth;

  /// No description provided for @filterYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterYear;

  /// No description provided for @navSectionCoreOperations.
  ///
  /// In en, this message translates to:
  /// **'Core Operations'**
  String get navSectionCoreOperations;

  /// No description provided for @navSectionInventoryOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations & Inventory'**
  String get navSectionInventoryOperations;

  /// No description provided for @navSectionCatalogsPartners.
  ///
  /// In en, this message translates to:
  /// **'Catalogs & Partners'**
  String get navSectionCatalogsPartners;

  /// No description provided for @navSectionFinanceLedgers.
  ///
  /// In en, this message translates to:
  /// **'Finance & Ledgers'**
  String get navSectionFinanceLedgers;

  /// No description provided for @navSectionSystemManagement.
  ///
  /// In en, this message translates to:
  /// **'System Management'**
  String get navSectionSystemManagement;

  /// No description provided for @navOffcanvasTitle.
  ///
  /// In en, this message translates to:
  /// **'Logisto ERP Modules'**
  String get navOffcanvasTitle;

  /// No description provided for @defaultBranchName.
  ///
  /// In en, this message translates to:
  /// **'Central Branch'**
  String get defaultBranchName;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get selectBranch;

  /// No description provided for @filterAuditLogsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Filter audit logs...'**
  String get filterAuditLogsPlaceholder;

  /// No description provided for @tableHeaderTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get tableHeaderTimestamp;

  /// No description provided for @tableHeaderUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get tableHeaderUser;

  /// No description provided for @tableHeaderAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get tableHeaderAction;

  /// No description provided for @tableHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tableHeaderDescription;

  /// No description provided for @tableHeaderBeforeAfter.
  ///
  /// In en, this message translates to:
  /// **'Before / After'**
  String get tableHeaderBeforeAfter;

  /// No description provided for @tableHeaderClientIp.
  ///
  /// In en, this message translates to:
  /// **'Client IP'**
  String get tableHeaderClientIp;

  /// No description provided for @tableCustomerAliasPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Carlos M.'**
  String get tableCustomerAliasPlaceholder;

  /// No description provided for @billiardFloorPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Billiard Stations & Floor Plan'**
  String get billiardFloorPlanTitle;

  /// No description provided for @selectDestinationTablePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select an available destination table:'**
  String get selectDestinationTablePrompt;

  /// No description provided for @noTablesAvailableForTransfer.
  ///
  /// In en, this message translates to:
  /// **'No other available tables at this moment.'**
  String get noTablesAvailableForTransfer;

  /// No description provided for @currentShiftSummary.
  ///
  /// In en, this message translates to:
  /// **'Current Shift Summary'**
  String get currentShiftSummary;

  /// No description provided for @openingFloatPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter initial opening cash float:'**
  String get openingFloatPrompt;

  /// No description provided for @amountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Amount (e.g. 50.00)'**
  String get amountPlaceholder;

  /// No description provided for @tableHeaderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get tableHeaderTime;

  /// No description provided for @tableHeaderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tableHeaderType;

  /// No description provided for @tableHeaderAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get tableHeaderAmount;

  /// No description provided for @tableHeaderReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get tableHeaderReason;

  /// No description provided for @blindDropShiftClosure.
  ///
  /// In en, this message translates to:
  /// **'Blind Drop Shift Closure (Corte Z)'**
  String get blindDropShiftClosure;

  /// No description provided for @expectedBalance.
  ///
  /// In en, this message translates to:
  /// **'Expected Balance:'**
  String get expectedBalance;

  /// No description provided for @physicalCashCountedPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter actual physical cash counted in cash drawer (USD):'**
  String get physicalCashCountedPrompt;

  /// No description provided for @physicalCountedAmountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Physical Counted Amount (e.g. 520.00)'**
  String get physicalCountedAmountPlaceholder;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found matching search.'**
  String get noCustomersFound;

  /// No description provided for @placeholderFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get placeholderFirstName;

  /// No description provided for @placeholderLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get placeholderLastName;

  /// No description provided for @placeholderTaxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / SSN / RUC'**
  String get placeholderTaxId;

  /// No description provided for @placeholderPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get placeholderPhone;

  /// No description provided for @placeholderEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get placeholderEmail;

  /// No description provided for @placeholderCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit (\$)'**
  String get placeholderCreditLimit;

  /// No description provided for @tableHeaderTaxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / RUC'**
  String get tableHeaderTaxId;

  /// No description provided for @tableHeaderCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get tableHeaderCustomerName;

  /// No description provided for @tableHeaderAvailableHeadroom.
  ///
  /// In en, this message translates to:
  /// **'Available Headroom'**
  String get tableHeaderAvailableHeadroom;

  /// No description provided for @tableHeaderStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tableHeaderStatus;

  /// No description provided for @tableHeaderActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tableHeaderActions;

  /// No description provided for @kpiRealtime.
  ///
  /// In en, this message translates to:
  /// **'Realtime'**
  String get kpiRealtime;

  /// No description provided for @kpiAuditReady.
  ///
  /// In en, this message translates to:
  /// **'Audit Ready'**
  String get kpiAuditReady;

  /// No description provided for @tableHeaderQtySold.
  ///
  /// In en, this message translates to:
  /// **'Qty Sold'**
  String get tableHeaderQtySold;

  /// No description provided for @tableHeaderRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get tableHeaderRevenue;

  /// No description provided for @filterLogsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Filter logs or telemetry...'**
  String get filterLogsPlaceholder;

  /// No description provided for @tableHeaderService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get tableHeaderService;

  /// No description provided for @tableHeaderTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get tableHeaderTarget;

  /// No description provided for @telemetryAndStatus.
  ///
  /// In en, this message translates to:
  /// **'Telemetry & Status'**
  String get telemetryAndStatus;

  /// No description provided for @processedTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Processed Tasks:'**
  String get processedTasksLabel;

  /// No description provided for @telemetryNodeOperational.
  ///
  /// In en, this message translates to:
  /// **'Multiplatform node operational on current target.'**
  String get telemetryNodeOperational;

  /// No description provided for @transferSourceBodega.
  ///
  /// In en, this message translates to:
  /// **'Source: Bodega Central de Reserva'**
  String get transferSourceBodega;

  /// No description provided for @transferDestBarra.
  ///
  /// In en, this message translates to:
  /// **'Destination: Barra Principal (Piso de Venta)'**
  String get transferDestBarra;

  /// No description provided for @auditedStockCountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter audited physical stock count:'**
  String get auditedStockCountPrompt;

  /// No description provided for @transferQuantityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Transfer Quantity (Units)'**
  String get transferQuantityPlaceholder;

  /// No description provided for @newTotalQuantityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'New Total Quantity'**
  String get newTotalQuantityPlaceholder;

  /// No description provided for @tableHeaderAvailableStock.
  ///
  /// In en, this message translates to:
  /// **'Available Stock'**
  String get tableHeaderAvailableStock;

  /// No description provided for @tableHeaderReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get tableHeaderReserved;

  /// No description provided for @noKardexMovements.
  ///
  /// In en, this message translates to:
  /// **'No Kardex movements recorded.'**
  String get noKardexMovements;

  /// No description provided for @tableHeaderMovementType.
  ///
  /// In en, this message translates to:
  /// **'Movement Type'**
  String get tableHeaderMovementType;

  /// No description provided for @tableHeaderQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get tableHeaderQuantity;

  /// No description provided for @tableHeaderTotalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get tableHeaderTotalValue;

  /// No description provided for @tableHeaderReferenceNotes.
  ///
  /// In en, this message translates to:
  /// **'Reference / Notes'**
  String get tableHeaderReferenceNotes;

  /// No description provided for @voidInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Void Sales Invoice'**
  String get voidInvoiceTitle;

  /// No description provided for @voidInvoiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to void this sales invoice? Stock movements will be reversed and an audit entry recorded.'**
  String get voidInvoiceConfirmation;

  /// No description provided for @searchInvoicePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search invoice # or customer...'**
  String get searchInvoicePlaceholder;

  /// No description provided for @noInvoicesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No sales invoices recorded yet.'**
  String get noInvoicesRecorded;

  /// No description provided for @tableHeaderInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get tableHeaderInvoiceNumber;

  /// No description provided for @tableHeaderCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get tableHeaderCustomer;

  /// No description provided for @tableHeaderCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get tableHeaderCashier;

  /// No description provided for @tableHeaderPaymentTender.
  ///
  /// In en, this message translates to:
  /// **'Payment Tender'**
  String get tableHeaderPaymentTender;

  /// No description provided for @kdsOrderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed.'**
  String get kdsOrderCompleted;

  /// No description provided for @kdsOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled.'**
  String get kdsOrderCancelled;

  /// No description provided for @hourlyRatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate (e.g. 10.00)'**
  String get hourlyRatePlaceholder;

  /// No description provided for @fastCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Fast Bar / Kitchen Catalog'**
  String get fastCatalogTitle;

  /// No description provided for @tapItemToAddPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap an item to add immediately to current tab:'**
  String get tapItemToAddPrompt;

  /// No description provided for @activeTabOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Tab Order'**
  String get activeTabOrderTitle;

  /// No description provided for @noTabSelected.
  ///
  /// In en, this message translates to:
  /// **'No tab selected. Select or create an open account.'**
  String get noTabSelected;

  /// No description provided for @noConsumablesLoaded.
  ///
  /// In en, this message translates to:
  /// **'No consumables loaded yet. Click items on the left to add.'**
  String get noConsumablesLoaded;

  /// No description provided for @noSupplierLiabilities.
  ///
  /// In en, this message translates to:
  /// **'No supplier liabilities recorded.'**
  String get noSupplierLiabilities;

  /// No description provided for @paymentAmountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount (\$)'**
  String get paymentAmountPlaceholder;

  /// No description provided for @tableHeaderSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get tableHeaderSupplier;

  /// No description provided for @tableHeaderSupplierInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Supplier Invoice #'**
  String get tableHeaderSupplierInvoiceNumber;

  /// No description provided for @tableHeaderPaidToDate.
  ///
  /// In en, this message translates to:
  /// **'Paid to Date'**
  String get tableHeaderPaidToDate;

  /// No description provided for @consumidorFinalWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Consumidor Final (Walk-in)'**
  String get consumidorFinalWalkIn;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @tableHeaderItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get tableHeaderItem;

  /// No description provided for @tableHeaderQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get tableHeaderQty;

  /// No description provided for @productNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Product name...'**
  String get productNamePlaceholder;

  /// No description provided for @skuPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'SKU-001'**
  String get skuPlaceholder;

  /// No description provided for @tableHeaderSkuBarcode.
  ///
  /// In en, this message translates to:
  /// **'SKU / Barcode'**
  String get tableHeaderSkuBarcode;

  /// No description provided for @noPurchaseOrdersRegistered.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders registered.'**
  String get noPurchaseOrdersRegistered;

  /// No description provided for @estimatedOrderValuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total Order Value (\$)'**
  String get estimatedOrderValuePlaceholder;

  /// No description provided for @tableHeaderOrderRef.
  ///
  /// In en, this message translates to:
  /// **'Order Ref'**
  String get tableHeaderOrderRef;

  /// No description provided for @tableHeaderOrderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get tableHeaderOrderDate;

  /// No description provided for @noOutstandingReceivables.
  ///
  /// In en, this message translates to:
  /// **'No outstanding accounts receivable.'**
  String get noOutstandingReceivables;

  /// No description provided for @tableHeaderBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get tableHeaderBalanceDue;

  /// No description provided for @reportExportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report Exported Successfully'**
  String get reportExportedSuccess;

  /// No description provided for @reportExportedDesc.
  ///
  /// In en, this message translates to:
  /// **'The financial ledger and operational metrics have been compiled into CSV format.\n\nReady for corporate audit archive.'**
  String get reportExportedDesc;

  /// No description provided for @tableHeaderItemConcept.
  ///
  /// In en, this message translates to:
  /// **'Item / Concept'**
  String get tableHeaderItemConcept;

  /// No description provided for @tableHeaderDetailsSku.
  ///
  /// In en, this message translates to:
  /// **'Details / SKU'**
  String get tableHeaderDetailsSku;

  /// No description provided for @tableHeaderMetric1.
  ///
  /// In en, this message translates to:
  /// **'Metric 1'**
  String get tableHeaderMetric1;

  /// No description provided for @tableHeaderMetric2.
  ///
  /// In en, this message translates to:
  /// **'Metric 2'**
  String get tableHeaderMetric2;

  /// No description provided for @tableHeaderStatusRatio.
  ///
  /// In en, this message translates to:
  /// **'Status / Ratio'**
  String get tableHeaderStatusRatio;

  /// No description provided for @tabAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get tabAppearance;

  /// No description provided for @legalNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal Name:'**
  String get legalNameLabel;

  /// No description provided for @commercialBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Commercial Brand:'**
  String get commercialBrandLabel;

  /// No description provided for @salesTaxRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Sales Tax Rate (%):'**
  String get salesTaxRateLabel;

  /// No description provided for @rbacMatrixTitle.
  ///
  /// In en, this message translates to:
  /// **'RBAC Security & Permission Matrix'**
  String get rbacMatrixTitle;

  /// No description provided for @tableHeaderRoleKey.
  ///
  /// In en, this message translates to:
  /// **'Role Key'**
  String get tableHeaderRoleKey;

  /// No description provided for @tableHeaderAccessibleModules.
  ///
  /// In en, this message translates to:
  /// **'Accessible Modules'**
  String get tableHeaderAccessibleModules;

  /// No description provided for @tableHeaderSensitivePermissions.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Permissions'**
  String get tableHeaderSensitivePermissions;

  /// No description provided for @supervisorPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'This action requires elevated supervisor permissions. Please enter authorized 4-digit PIN:'**
  String get supervisorPinPrompt;

  /// No description provided for @noSuppliersFound.
  ///
  /// In en, this message translates to:
  /// **'No suppliers found.'**
  String get noSuppliersFound;

  /// No description provided for @placeholderCompanyLegalName.
  ///
  /// In en, this message translates to:
  /// **'Company Legal Name'**
  String get placeholderCompanyLegalName;

  /// No description provided for @placeholderContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get placeholderContactPerson;

  /// No description provided for @placeholderPaymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Payment Terms (e.g. 30 Days)'**
  String get placeholderPaymentTerms;

  /// No description provided for @tableHeaderCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get tableHeaderCompanyName;

  /// No description provided for @tableHeaderContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get tableHeaderContactPerson;

  /// No description provided for @tableHeaderCreditTerms.
  ///
  /// In en, this message translates to:
  /// **'Credit Terms'**
  String get tableHeaderCreditTerms;

  /// No description provided for @tableHeaderPayableBalance.
  ///
  /// In en, this message translates to:
  /// **'Payable Balance'**
  String get tableHeaderPayableBalance;

  /// No description provided for @tableHeaderUserName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tableHeaderUserName;

  /// No description provided for @tableHeaderUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get tableHeaderUserEmail;

  /// No description provided for @tableHeaderSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get tableHeaderSuperAdmin;

  /// No description provided for @tableHeaderAssignedBranches.
  ///
  /// In en, this message translates to:
  /// **'Assigned Branches'**
  String get tableHeaderAssignedBranches;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get statusInactive;

  /// No description provided for @statusActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActiveTitle;

  /// No description provided for @statusInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactiveTitle;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @placeholderFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name...'**
  String get placeholderFullName;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// No description provided for @companyEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'admin@company.com'**
  String get companyEmailPlaceholder;

  /// No description provided for @userEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'user@logisto.com'**
  String get userEmailPlaceholder;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editSupplier;

  /// No description provided for @startTableNamed.
  ///
  /// In en, this message translates to:
  /// **'Start {name}'**
  String startTableNamed(String name);

  /// No description provided for @transferTableNamed.
  ///
  /// In en, this message translates to:
  /// **'Transfer {name}'**
  String transferTableNamed(String name);

  /// No description provided for @openCashShiftRegister.
  ///
  /// In en, this message translates to:
  /// **'Open Cash Shift (Register #{number})'**
  String openCashShiftRegister(int number);

  /// No description provided for @reconciliationStatus.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation Status: {status}'**
  String reconciliationStatus(String status);

  /// No description provided for @registerActiveShift.
  ///
  /// In en, this message translates to:
  /// **'Register #{number} • Active Shift'**
  String registerActiveShift(int number);

  /// No description provided for @customerDebtAmount.
  ///
  /// In en, this message translates to:
  /// **'Debt: \${amount}'**
  String customerDebtAmount(String amount);

  /// No description provided for @telemetryTasksProcessed.
  ///
  /// In en, this message translates to:
  /// **'Active telemetry tasks processed: {count}'**
  String telemetryTasksProcessed(int count);

  /// No description provided for @kardexValueAmount.
  ///
  /// In en, this message translates to:
  /// **'Val: \${amount}'**
  String kardexValueAmount(String amount);

  /// No description provided for @invoiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice #{number}'**
  String invoiceDetailsTitle(String number);

  /// No description provided for @invoiceCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String invoiceCustomerLabel(String name);

  /// No description provided for @invoiceCashierLabel.
  ///
  /// In en, this message translates to:
  /// **'Cashier: {cashier}'**
  String invoiceCashierLabel(String cashier);

  /// No description provided for @kdsItemNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String kdsItemNote(String note);

  /// No description provided for @preBillPreviewCode.
  ///
  /// In en, this message translates to:
  /// **'Pre-Bill Preview: {code}'**
  String preBillPreviewCode(String code);

  /// No description provided for @customerDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String customerDisplayName(String name);

  /// No description provided for @paySupplierNamed.
  ///
  /// In en, this message translates to:
  /// **'Pay Supplier: {name}'**
  String paySupplierNamed(String name);

  /// No description provided for @payableInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice: {number}'**
  String payableInvoiceLabel(String number);

  /// No description provided for @remainingDebtLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Debt: '**
  String remainingDebtLabel(String amount);

  /// No description provided for @collectPaymentCustomer.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment (ROC): {customer}'**
  String collectPaymentCustomer(String customer);

  /// No description provided for @outstandingBalanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance: \${amount}'**
  String outstandingBalanceAmount(String amount);

  /// No description provided for @authorizeActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Authorize: {action}'**
  String authorizeActionTitle(String action);

  /// No description provided for @supplierDueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due: \${amount}'**
  String supplierDueAmount(String amount);

  /// No description provided for @branchCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Branch(es)'**
  String branchCountLabel(int count);

  /// No description provided for @editStaffNamed.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff: {name}'**
  String editStaffNamed(String name);

  /// No description provided for @superAdminStatus.
  ///
  /// In en, this message translates to:
  /// **'Super Admin: {status}'**
  String superAdminStatus(String status);

  /// No description provided for @taxAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax ({percent}%):'**
  String taxAmountLabel(int percent);

  /// No description provided for @taxReceiptLabel.
  ///
  /// In en, this message translates to:
  /// **'IVA / Tax ({percent}%):'**
  String taxReceiptLabel(int percent);

  /// No description provided for @invoiceReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'INVOICE: {number}'**
  String invoiceReceiptNumber(String number);

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All Events'**
  String get allEvents;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @finishPrintZCut.
  ///
  /// In en, this message translates to:
  /// **'Finish & Print Z-Cut'**
  String get finishPrintZCut;

  /// No description provided for @submitBlindCount.
  ///
  /// In en, this message translates to:
  /// **'Submit Blind Count'**
  String get submitBlindCount;

  /// No description provided for @blindDropSecurityRule.
  ///
  /// In en, this message translates to:
  /// **'Security Rule: Enter total physical cash counted in drawer. Expected totals remain hidden until count is confirmed.'**
  String get blindDropSecurityRule;

  /// No description provided for @physicalCountedLabel.
  ///
  /// In en, this message translates to:
  /// **'Physical Counted:'**
  String get physicalCountedLabel;

  /// No description provided for @varianceDiscrepancyLabel.
  ///
  /// In en, this message translates to:
  /// **'Variance / Discrepancy:'**
  String get varianceDiscrepancyLabel;

  /// No description provided for @shiftOpen.
  ///
  /// In en, this message translates to:
  /// **'Shift Open'**
  String get shiftOpen;

  /// No description provided for @openingFloatBase.
  ///
  /// In en, this message translates to:
  /// **'Opening Float (Base):'**
  String get openingFloatBase;

  /// No description provided for @cashSalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Sales:'**
  String get cashSalesLabel;

  /// No description provided for @cardSalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Card / POS Sales:'**
  String get cardSalesLabel;

  /// No description provided for @cashInjectionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Injections:'**
  String get cashInjectionsLabel;

  /// No description provided for @withdrawalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals (Sangrías):'**
  String get withdrawalsLabel;

  /// No description provided for @calculatedCashInTill.
  ///
  /// In en, this message translates to:
  /// **'Calculated Cash in Till:'**
  String get calculatedCashInTill;

  /// No description provided for @cashMovementButton.
  ///
  /// In en, this message translates to:
  /// **'Cash Movement (+ / -)'**
  String get cashMovementButton;

  /// No description provided for @closeShiftBlindDropButton.
  ///
  /// In en, this message translates to:
  /// **'Close Shift (Blind Drop / Corte Z)'**
  String get closeShiftBlindDropButton;

  /// No description provided for @noActiveShiftPrompt.
  ///
  /// In en, this message translates to:
  /// **'No cash shift currently open on this workstation.'**
  String get noActiveShiftPrompt;

  /// No description provided for @openShiftInitialFloat.
  ///
  /// In en, this message translates to:
  /// **'Open Shift with Initial Float'**
  String get openShiftInitialFloat;

  /// No description provided for @closedShiftHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Closed Shift Audit History'**
  String get closedShiftHistoryTitle;

  /// No description provided for @tableHeaderRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get tableHeaderRegister;

  /// No description provided for @tableHeaderExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get tableHeaderExpected;

  /// No description provided for @tableHeaderCounted.
  ///
  /// In en, this message translates to:
  /// **'Counted'**
  String get tableHeaderCounted;

  /// No description provided for @tableHeaderVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get tableHeaderVariance;

  /// No description provided for @counterDefault.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterDefault;

  /// No description provided for @tableRatePerHour.
  ///
  /// In en, this message translates to:
  /// **'Rate: /hr ({type})'**
  String tableRatePerHour(String rate, String type);

  /// No description provided for @tablePlayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Player: {name}'**
  String tablePlayerLabel(String name);

  /// No description provided for @tableAccruedAmount.
  ///
  /// In en, this message translates to:
  /// **'Accrued: '**
  String tableAccruedAmount(String amount);

  /// No description provided for @startSessionAction.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSessionAction;

  /// No description provided for @selectOperatingBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Select Operating Business Unit'**
  String get selectOperatingBusinessUnit;

  /// No description provided for @addBranch.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get addBranch;

  /// No description provided for @registerCustomer.
  ///
  /// In en, this message translates to:
  /// **'Register Customer'**
  String get registerCustomer;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get saveCustomer;

  /// No description provided for @collect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collect;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @registerSupplier.
  ///
  /// In en, this message translates to:
  /// **'Register Supplier'**
  String get registerSupplier;

  /// No description provided for @saveSupplier.
  ///
  /// In en, this message translates to:
  /// **'Save Supplier'**
  String get saveSupplier;

  /// No description provided for @issueOrder.
  ///
  /// In en, this message translates to:
  /// **'Issue Order'**
  String get issueOrder;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @kpiSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get kpiSynced;

  /// No description provided for @kpiMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get kpiMonthly;

  /// No description provided for @kpiPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get kpiPending;

  /// No description provided for @kpiCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get kpiCatalog;

  /// No description provided for @tableHeaderUnitsSold.
  ///
  /// In en, this message translates to:
  /// **'Units Sold'**
  String get tableHeaderUnitsSold;

  /// No description provided for @revenueByCategory.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Category'**
  String get revenueByCategory;

  /// No description provided for @revenueByTender.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Payment Tender'**
  String get revenueByTender;

  /// No description provided for @topSellingProductsAndServices.
  ///
  /// In en, this message translates to:
  /// **'Top 10 Selling Products & Services'**
  String get topSellingProductsAndServices;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metrics;

  /// No description provided for @erpSuite.
  ///
  /// In en, this message translates to:
  /// **'ERP Suite'**
  String get erpSuite;

  /// No description provided for @systemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Info'**
  String get systemInfo;

  /// No description provided for @filterLogsOrTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Filter logs or telemetry...'**
  String get filterLogsOrTelemetry;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get increment;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @processedTasks.
  ///
  /// In en, this message translates to:
  /// **'Processed Tasks:'**
  String get processedTasks;

  /// No description provided for @serviceCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get serviceCore;

  /// No description provided for @targetDarwinWin32.
  ///
  /// In en, this message translates to:
  /// **'Darwin/Win32'**
  String get targetDarwinWin32;

  /// No description provided for @serviceWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get serviceWeb;

  /// No description provided for @targetWasmMobile.
  ///
  /// In en, this message translates to:
  /// **'WASM/Mobile'**
  String get targetWasmMobile;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @internalTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer: {productName}'**
  String internalTransferTitle(String productName);

  /// No description provided for @confirmTransferGuide.
  ///
  /// In en, this message translates to:
  /// **'Confirm Transfer Guide'**
  String get confirmTransferGuide;

  /// No description provided for @stockAdjustmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory Stock Adjustment: {productName}'**
  String stockAdjustmentTitle(String productName);

  /// No description provided for @newTotalQuantity.
  ///
  /// In en, this message translates to:
  /// **'New Total Quantity'**
  String get newTotalQuantity;

  /// No description provided for @saveAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Save Adjustment'**
  String get saveAdjustment;

  /// No description provided for @warehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get warehouses;

  /// No description provided for @stockLevels.
  ///
  /// In en, this message translates to:
  /// **'Stock Levels'**
  String get stockLevels;

  /// No description provided for @kardexLedger.
  ///
  /// In en, this message translates to:
  /// **'Kardex Ledger'**
  String get kardexLedger;

  /// No description provided for @stockLevelsWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Stock Levels: {warehouse}'**
  String stockLevelsWarehouse(String warehouse);

  /// No description provided for @kardexLedgerHeader.
  ///
  /// In en, this message translates to:
  /// **'Permanent Kardex Movement Ledger (Entries, Exits, Transfers & Audits)'**
  String get kardexLedgerHeader;

  /// No description provided for @tableHeaderProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get tableHeaderProduct;

  /// No description provided for @tableHeaderUnitCost.
  ///
  /// In en, this message translates to:
  /// **'Unit Cost'**
  String get tableHeaderUnitCost;

  /// No description provided for @tableHeaderSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get tableHeaderSku;

  /// No description provided for @tableHeaderProductItem.
  ///
  /// In en, this message translates to:
  /// **'Product Item'**
  String get tableHeaderProductItem;

  /// No description provided for @tableHeaderMinStock.
  ///
  /// In en, this message translates to:
  /// **'Min Stock'**
  String get tableHeaderMinStock;

  /// No description provided for @tableHeaderCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get tableHeaderCost;

  /// No description provided for @tableHeaderSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get tableHeaderSalePrice;

  /// No description provided for @tableHeaderTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get tableHeaderTotalAmount;

  /// No description provided for @tableHeaderDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get tableHeaderDueDate;

  /// No description provided for @tableHeaderTotalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get tableHeaderTotalDebt;

  /// No description provided for @tableHeaderProductName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get tableHeaderProductName;

  /// No description provided for @tableHeaderRucTaxId.
  ///
  /// In en, this message translates to:
  /// **'RUC / Tax ID'**
  String get tableHeaderRucTaxId;

  /// No description provided for @tableHeaderPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get tableHeaderPhone;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice {invoiceNumber}'**
  String invoiceTitle(String invoiceNumber);

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer: {customer}'**
  String customerLabel(String customer);

  /// No description provided for @cashierLabel.
  ///
  /// In en, this message translates to:
  /// **'Cashier: {cashier}'**
  String cashierLabel(String cashier);

  /// No description provided for @startPreparation.
  ///
  /// In en, this message translates to:
  /// **'Start Preparation'**
  String get startPreparation;

  /// No description provided for @readyToServe.
  ///
  /// In en, this message translates to:
  /// **'Ready to Serve'**
  String get readyToServe;

  /// No description provided for @served.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get served;

  /// No description provided for @openAccountsAndTabs.
  ///
  /// In en, this message translates to:
  /// **'Open Accounts & Tabs'**
  String get openAccountsAndTabs;

  /// No description provided for @openNewTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Open New Bar / Table Tab'**
  String get openNewTabTitle;

  /// No description provided for @openTabAction.
  ///
  /// In en, this message translates to:
  /// **'Open Tab'**
  String get openTabAction;

  /// No description provided for @fastCatalogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap an item to add immediately to current tab:'**
  String get fastCatalogPrompt;

  /// No description provided for @activeTabOrder.
  ///
  /// In en, this message translates to:
  /// **'Active Tab Order'**
  String get activeTabOrder;

  /// No description provided for @timerAction.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerAction;

  /// No description provided for @preBillPrint.
  ///
  /// In en, this message translates to:
  /// **'Pre-Bill Print'**
  String get preBillPrint;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @paySupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay Supplier: {supplier}'**
  String paySupplierTitle(String supplier);

  /// No description provided for @invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice: {invoiceNumber}'**
  String invoiceLabel(String invoiceNumber);

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @outstandingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance: '**
  String get outstandingBalanceLabel;

  /// No description provided for @reportsAndBi.
  ///
  /// In en, this message translates to:
  /// **'Reports & BI'**
  String get reportsAndBi;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @reportExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Report Exported Successfully'**
  String get reportExportedSuccessfully;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @settingsAndRbac.
  ///
  /// In en, this message translates to:
  /// **'Settings & RBAC'**
  String get settingsAndRbac;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @corporateAndFiscal.
  ///
  /// In en, this message translates to:
  /// **'Corporate & Fiscal'**
  String get corporateAndFiscal;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get systemLanguage;

  /// No description provided for @corporateAndTaxConfig.
  ///
  /// In en, this message translates to:
  /// **'Corporate & Tax Configuration'**
  String get corporateAndTaxConfig;

  /// No description provided for @legalName.
  ///
  /// In en, this message translates to:
  /// **'Legal Name:'**
  String get legalName;

  /// No description provided for @commercialBrand.
  ///
  /// In en, this message translates to:
  /// **'Commercial Brand:'**
  String get commercialBrand;

  /// No description provided for @taxIdRucLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / RUC:'**
  String get taxIdRucLabel;

  /// No description provided for @salesTaxRatePercent.
  ///
  /// In en, this message translates to:
  /// **'Sales Tax Rate (%):'**
  String get salesTaxRatePercent;

  /// No description provided for @defaultOperatingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default Operating Currency:'**
  String get defaultOperatingCurrency;

  /// No description provided for @rbacSecurityMatrix.
  ///
  /// In en, this message translates to:
  /// **'RBAC Security & Permission Matrix'**
  String get rbacSecurityMatrix;

  /// No description provided for @authorizeActionNamed.
  ///
  /// In en, this message translates to:
  /// **'Authorize: {action}'**
  String authorizeActionNamed(String action);

  /// No description provided for @authorizeAction.
  ///
  /// In en, this message translates to:
  /// **'Authorize Action'**
  String get authorizeAction;

  /// No description provided for @invalidSupervisorPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid supervisor authorization PIN.'**
  String get invalidSupervisorPin;

  /// No description provided for @companyNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Company name...'**
  String get companyNamePrompt;

  /// No description provided for @usersAndStaff.
  ///
  /// In en, this message translates to:
  /// **'Users & Staff'**
  String get usersAndStaff;

  /// No description provided for @inviteEmployee.
  ///
  /// In en, this message translates to:
  /// **'Invite Employee'**
  String get inviteEmployee;

  /// No description provided for @inviteNewEmployee.
  ///
  /// In en, this message translates to:
  /// **'Invite New Employee'**
  String get inviteNewEmployee;

  /// No description provided for @fullNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Full name...'**
  String get fullNamePrompt;

  /// No description provided for @superAdminYes.
  ///
  /// In en, this message translates to:
  /// **'Super Admin: YES'**
  String get superAdminYes;

  /// No description provided for @superAdminNo.
  ///
  /// In en, this message translates to:
  /// **'Super Admin: NO'**
  String get superAdminNo;

  /// No description provided for @editStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Staff: {name}'**
  String editStaffTitle(String name);

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @productCatalog.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productCatalog;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get newProduct;

  /// No description provided for @productNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Product name...'**
  String get productNamePrompt;

  /// No description provided for @quickProductCatalog.
  ///
  /// In en, this message translates to:
  /// **'Quick Product Catalog'**
  String get quickProductCatalog;

  /// No description provided for @noProductsAvailablePrompt.
  ///
  /// In en, this message translates to:
  /// **'No products available. Add items in catalog or seed database.'**
  String get noProductsAvailablePrompt;

  /// No description provided for @selectOrRegisterCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select or Register Customer'**
  String get selectOrRegisterCustomer;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @saleSummaryAndItems.
  ///
  /// In en, this message translates to:
  /// **'Sale Summary & Items'**
  String get saleSummaryAndItems;

  /// No description provided for @cartIsEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty. Add items from the catalog.'**
  String get cartIsEmptyPrompt;

  /// No description provided for @itemHeader.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemHeader;

  /// No description provided for @qtyHeader.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qtyHeader;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @finalizeSale.
  ///
  /// In en, this message translates to:
  /// **'Finalize Sale'**
  String get finalizeSale;

  /// No description provided for @walkInCustomer.
  ///
  /// In en, this message translates to:
  /// **'Consumidor Final (Walk-in)'**
  String get walkInCustomer;

  /// No description provided for @creditAvail.
  ///
  /// In en, this message translates to:
  /// **'Credit Avail.'**
  String get creditAvail;

  /// No description provided for @changeAction.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeAction;

  /// No description provided for @salesReceipt.
  ///
  /// In en, this message translates to:
  /// **'Sales Receipt'**
  String get salesReceipt;

  /// No description provided for @thankYouForBusiness.
  ///
  /// In en, this message translates to:
  /// **'*** THANK YOU FOR YOUR BUSINESS ***'**
  String get thankYouForBusiness;

  /// No description provided for @printAction.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printAction;

  /// No description provided for @newSaleAction.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSaleAction;

  /// No description provided for @tax15Percent.
  ///
  /// In en, this message translates to:
  /// **'IVA / Tax (15%):'**
  String get tax15Percent;

  /// No description provided for @onboardingWizardTitle.
  ///
  /// In en, this message translates to:
  /// **'Logisto Onboarding Wizard'**
  String get onboardingWizardTitle;

  /// No description provided for @stepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4'**
  String stepCounter(int step);

  /// No description provided for @previousStep.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousStep;

  /// No description provided for @launchSystem.
  ///
  /// In en, this message translates to:
  /// **'Launch System'**
  String get launchSystem;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Logisto isolates global corporate masters (Customers, Suppliers, Users) at the Organization level, while transactional activities (POS, Kitchen, Warehouses, Tables) execute inside specific Business Units.'**
  String get step1Desc;

  /// No description provided for @step1Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Corporate Legal Name (e.g. Inversiones Castillo S.A.)'**
  String get step1Placeholder;

  /// No description provided for @step2Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Branch Name (e.g. Downtown Billiards or Central Pharmacy)'**
  String get step2Placeholder;

  /// No description provided for @step2Segment.
  ///
  /// In en, this message translates to:
  /// **'Primary Business Segment:'**
  String get step2Segment;

  /// No description provided for @step3Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate (e.g. 10.00)'**
  String get step3Placeholder;

  /// No description provided for @adjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get adjust;

  /// No description provided for @itemsBilled.
  ///
  /// In en, this message translates to:
  /// **'Items Billed:'**
  String get itemsBilled;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid:'**
  String get totalPaid;

  /// No description provided for @confirmVoid.
  ///
  /// In en, this message translates to:
  /// **'Confirm Void'**
  String get confirmVoid;

  /// No description provided for @searchInvoiceOrCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search invoice # or customer...'**
  String get searchInvoiceOrCustomer;

  /// No description provided for @voidAction.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get voidAction;

  /// No description provided for @voidInvoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Supervisor confirmation required. Voiding this invoice will reverse sales metrics and audit the cancellation.'**
  String get voidInvoiceDesc;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @pendingFilter.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingFilter;

  /// No description provided for @inPrepFilter.
  ///
  /// In en, this message translates to:
  /// **'In Prep'**
  String get inPrepFilter;

  /// No description provided for @readyFilter.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get readyFilter;

  /// No description provided for @noOrdersInQueue.
  ///
  /// In en, this message translates to:
  /// **'No orders in this status queue.'**
  String get noOrdersInQueue;

  /// No description provided for @customerTableAliasPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Customer / Table Alias (e.g. Barra Carlos)'**
  String get customerTableAliasPlaceholder;

  /// No description provided for @accountTotal.
  ///
  /// In en, this message translates to:
  /// **'Account Total:'**
  String get accountTotal;

  /// No description provided for @paymentAmountDollar.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount (\$)'**
  String get paymentAmountDollar;

  /// No description provided for @estimatedTotalOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total Order Value (\$)'**
  String get estimatedTotalOrderValue;

  /// No description provided for @createPurchaseOrderAction.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase Order'**
  String get createPurchaseOrderAction;

  /// No description provided for @exchangeRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate (USD -> NIO):'**
  String get exchangeRateLabel;

  /// No description provided for @supervisorPermissionPrompt.
  ///
  /// In en, this message translates to:
  /// **'This action requires elevated supervisor permissions. Please enter authorized 4-digit PIN:'**
  String get supervisorPermissionPrompt;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed.'**
  String get orderCompleted;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled.'**
  String get orderCancelled;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @newTab.
  ///
  /// In en, this message translates to:
  /// **'New Tab'**
  String get newTab;

  /// No description provided for @noTabSelectedPrompt.
  ///
  /// In en, this message translates to:
  /// **'No tab selected. Select or create an open account.'**
  String get noTabSelectedPrompt;

  /// No description provided for @noSupplierLiabilitiesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No supplier liabilities recorded.'**
  String get noSupplierLiabilitiesRecorded;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'SETTLED'**
  String get settled;

  /// No description provided for @noPurchaseOrdersRecorded.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders recorded.'**
  String get noPurchaseOrdersRecorded;

  /// No description provided for @statusReceived.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED'**
  String get statusReceived;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get statusPending;

  /// No description provided for @salesReport8020.
  ///
  /// In en, this message translates to:
  /// **'Sales 80/20'**
  String get salesReport8020;

  /// No description provided for @cashShifts.
  ///
  /// In en, this message translates to:
  /// **'Cash Shifts'**
  String get cashShifts;

  /// No description provided for @creditAging.
  ///
  /// In en, this message translates to:
  /// **'Credit & Aging'**
  String get creditAging;

  /// No description provided for @csvReportGenerated.
  ///
  /// In en, this message translates to:
  /// **'CSV formatted report generated ({count} rows):'**
  String csvReportGenerated(String count);

  /// No description provided for @reportSalesPareto.
  ///
  /// In en, this message translates to:
  /// **'Sales & Pareto Contribution (80/20)'**
  String get reportSalesPareto;

  /// No description provided for @reportInventoryValuation.
  ///
  /// In en, this message translates to:
  /// **'Inventory Valuation & Reorder Point'**
  String get reportInventoryValuation;

  /// No description provided for @reportBilliardsUtilization.
  ///
  /// In en, this message translates to:
  /// **'Billiard Station Utilization & Hourly Rent'**
  String get reportBilliardsUtilization;

  /// No description provided for @reportCashDrawerCuts.
  ///
  /// In en, this message translates to:
  /// **'Cash Drawer Cuts (Z-Report Audit)'**
  String get reportCashDrawerCuts;

  /// No description provided for @reportReceivablesAging.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable & Aging (CxC)'**
  String get reportReceivablesAging;

  /// No description provided for @noneRequiresSupervisorPin.
  ///
  /// In en, this message translates to:
  /// **'None (Requires Supervisor PIN)'**
  String get noneRequiresSupervisorPin;

  /// No description provided for @companyLegalName.
  ///
  /// In en, this message translates to:
  /// **'Company Legal Name'**
  String get companyLegalName;

  /// No description provided for @contactRepresentative.
  ///
  /// In en, this message translates to:
  /// **'Contact Representative'**
  String get contactRepresentative;

  /// No description provided for @creditDaysExample.
  ///
  /// In en, this message translates to:
  /// **'Credit Days (e.g. 15, 30)'**
  String get creditDaysExample;

  /// No description provided for @searchSupplierPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search supplier name or tax ID...'**
  String get searchSupplierPlaceholder;

  /// No description provided for @rucTaxIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'RUC / Tax ID'**
  String get rucTaxIdPlaceholder;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String daysCount(int count);

  /// No description provided for @superAdminShort.
  ///
  /// In en, this message translates to:
  /// **'SuperAdmin'**
  String get superAdminShort;

  /// No description provided for @noProductsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No products registered in this organization.'**
  String get noProductsRegistered;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @creditLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get creditLimitLabel;

  /// No description provided for @debtLabel.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debtLabel;

  /// No description provided for @tableHeaderPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get tableHeaderPrice;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount:'**
  String get totalAmountLabel;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get subtotalLabel;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @cashTendered.
  ///
  /// In en, this message translates to:
  /// **'Cash Tendered'**
  String get cashTendered;

  /// No description provided for @cardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card Payment'**
  String get cardPayment;

  /// No description provided for @customerCredit.
  ///
  /// In en, this message translates to:
  /// **'Customer Credit'**
  String get customerCredit;

  /// No description provided for @addedToCustomerDebt.
  ///
  /// In en, this message translates to:
  /// **'Added to Customer Debt:'**
  String get addedToCustomerDebt;

  /// No description provided for @creditAvailablePrefix.
  ///
  /// In en, this message translates to:
  /// **'Credit Avail.'**
  String get creditAvailablePrefix;

  /// No description provided for @step3Alert.
  ///
  /// In en, this message translates to:
  /// **'Auto-provisioning \"Main Warehouse\" and \"Register 01\".'**
  String get step3Alert;

  /// No description provided for @productionSeedsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Production Seeds: ENABLED'**
  String get productionSeedsEnabled;

  /// No description provided for @productionSeedsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Production Seeds: DISABLED'**
  String get productionSeedsDisabled;

  /// No description provided for @unitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String unitsCount(int count);

  /// No description provided for @inStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String inStockCount(int count);

  /// No description provided for @minStockCount.
  ///
  /// In en, this message translates to:
  /// **'Min: {count}'**
  String minStockCount(int count);

  /// No description provided for @stockStatusLow.
  ///
  /// In en, this message translates to:
  /// **'LOW STOCK'**
  String get stockStatusLow;

  /// No description provided for @stockStatusOptimal.
  ///
  /// In en, this message translates to:
  /// **'OPTIMAL'**
  String get stockStatusOptimal;

  /// No description provided for @defaultCustomerFirstName.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get defaultCustomerFirstName;

  /// No description provided for @defaultCustomerLastName.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get defaultCustomerLastName;

  /// No description provided for @defaultSupplierName.
  ///
  /// In en, this message translates to:
  /// **'New Supplier'**
  String get defaultSupplierName;

  /// No description provided for @defaultContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get defaultContactName;

  /// No description provided for @defaultProductName.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get defaultProductName;

  /// No description provided for @auditPhysicalCountReason.
  ///
  /// In en, this message translates to:
  /// **'Physical count audit'**
  String get auditPhysicalCountReason;

  /// No description provided for @mainWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainWarehouse;

  /// No description provided for @kdsMinutesPending.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min (Pending)'**
  String kdsMinutesPending(int minutes);

  /// No description provided for @kdsMinutesCooking.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min (Cooking)'**
  String kdsMinutesCooking(int minutes);

  /// No description provided for @kdsNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String kdsNote(String note);

  /// No description provided for @priceEach.
  ///
  /// In en, this message translates to:
  /// **'\${price} each'**
  String priceEach(String price);

  /// No description provided for @totalLiabilitiesAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Liabilities: \${amount}'**
  String totalLiabilitiesAmount(String amount);

  /// No description provided for @authErrorEmailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get authErrorEmailPasswordRequired;

  /// No description provided for @authErrorPinFourDigits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be exactly 4 digits.'**
  String get authErrorPinFourDigits;

  /// No description provided for @businessTypeBilliard.
  ///
  /// In en, this message translates to:
  /// **'Billiards & Entertainment'**
  String get businessTypeBilliard;

  /// No description provided for @businessTypeRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail & Store'**
  String get businessTypeRetail;

  /// No description provided for @businessTypePharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy & Health'**
  String get businessTypePharmacy;

  /// No description provided for @businessTypeRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant & Bar'**
  String get businessTypeRestaurant;

  /// No description provided for @businessTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Commercial'**
  String get businessTypeGeneral;

  /// No description provided for @productTypeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get productTypeStandard;

  /// No description provided for @productTypeCombo.
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get productTypeCombo;

  /// No description provided for @productTypeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get productTypeService;

  /// No description provided for @productTypeRawMaterial.
  ///
  /// In en, this message translates to:
  /// **'Raw Material'**
  String get productTypeRawMaterial;

  /// No description provided for @productTypePack.
  ///
  /// In en, this message translates to:
  /// **'Pack / Bundle'**
  String get productTypePack;

  /// No description provided for @productTypeRecipeBom.
  ///
  /// In en, this message translates to:
  /// **'Recipe / BOM'**
  String get productTypeRecipeBom;

  /// No description provided for @roleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Administrator'**
  String get roleSuperAdmin;

  /// No description provided for @roleAdminBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Branch Manager'**
  String get roleAdminBusinessUnit;

  /// No description provided for @roleSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Floor Supervisor'**
  String get roleSupervisor;

  /// No description provided for @roleCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get roleCashier;

  /// No description provided for @roleWaiter.
  ///
  /// In en, this message translates to:
  /// **'Waiter / Server'**
  String get roleWaiter;

  /// No description provided for @roleInventoryManager.
  ///
  /// In en, this message translates to:
  /// **'Inventory Manager'**
  String get roleInventoryManager;

  /// No description provided for @roleKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen / KDS'**
  String get roleKitchen;

  /// No description provided for @auditActionVoidItem.
  ///
  /// In en, this message translates to:
  /// **'void item'**
  String get auditActionVoidItem;

  /// No description provided for @auditActionVoidInvoice.
  ///
  /// In en, this message translates to:
  /// **'void invoice'**
  String get auditActionVoidInvoice;

  /// No description provided for @auditActionApplyDiscount.
  ///
  /// In en, this message translates to:
  /// **'apply discount'**
  String get auditActionApplyDiscount;

  /// No description provided for @auditActionOpenDrawer.
  ///
  /// In en, this message translates to:
  /// **'open drawer'**
  String get auditActionOpenDrawer;

  /// No description provided for @auditActionTransferTable.
  ///
  /// In en, this message translates to:
  /// **'transfer table'**
  String get auditActionTransferTable;

  /// No description provided for @auditActionSplitBill.
  ///
  /// In en, this message translates to:
  /// **'split bill'**
  String get auditActionSplitBill;

  /// No description provided for @auditActionBlindDrop.
  ///
  /// In en, this message translates to:
  /// **'blind drop'**
  String get auditActionBlindDrop;

  /// No description provided for @auditActionReorderPoint.
  ///
  /// In en, this message translates to:
  /// **'reorder point'**
  String get auditActionReorderPoint;

  /// No description provided for @auditActionForceSync.
  ///
  /// In en, this message translates to:
  /// **'force sync'**
  String get auditActionForceSync;

  /// No description provided for @auditActionRateChange.
  ///
  /// In en, this message translates to:
  /// **'rate change'**
  String get auditActionRateChange;

  /// No description provided for @auditActionCreditOverride.
  ///
  /// In en, this message translates to:
  /// **'credit override'**
  String get auditActionCreditOverride;

  /// No description provided for @auditActionStockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'stock adjustment'**
  String get auditActionStockAdjustment;

  /// No description provided for @auditActionCloseShift.
  ///
  /// In en, this message translates to:
  /// **'close shift'**
  String get auditActionCloseShift;

  /// No description provided for @movementPurchaseReceipt.
  ///
  /// In en, this message translates to:
  /// **'Purchase Receipt'**
  String get movementPurchaseReceipt;

  /// No description provided for @movementSalesDeduction.
  ///
  /// In en, this message translates to:
  /// **'Sales Deduction'**
  String get movementSalesDeduction;

  /// No description provided for @movementInternalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer'**
  String get movementInternalTransfer;

  /// No description provided for @movementWasteAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Waste Adjustment'**
  String get movementWasteAdjustment;

  /// No description provided for @movementInitialCount.
  ///
  /// In en, this message translates to:
  /// **'Initial Count'**
  String get movementInitialCount;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodCustomerCredit.
  ///
  /// In en, this message translates to:
  /// **'Customer Credit'**
  String get paymentMethodCustomerCredit;

  /// No description provided for @paymentMethodBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentMethodBankTransfer;

  /// No description provided for @paymentMethodMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed / Split'**
  String get paymentMethodMixed;

  /// No description provided for @discrepancyBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get discrepancyBalanced;

  /// No description provided for @discrepancyShortage.
  ///
  /// In en, this message translates to:
  /// **'Shortage'**
  String get discrepancyShortage;

  /// No description provided for @discrepancySurplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus'**
  String get discrepancySurplus;

  /// No description provided for @tableTypePool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get tableTypePool;

  /// No description provided for @tableTypeCarambola.
  ///
  /// In en, this message translates to:
  /// **'Carambola'**
  String get tableTypeCarambola;

  /// No description provided for @tableTypeSnooker.
  ///
  /// In en, this message translates to:
  /// **'Snooker'**
  String get tableTypeSnooker;

  /// No description provided for @tableTypeVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get tableTypeVip;

  /// No description provided for @reportTagLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock: {count} Units'**
  String reportTagLowStock(int count);

  /// No description provided for @reportTagInStock.
  ///
  /// In en, this message translates to:
  /// **'{count} In Stock'**
  String reportTagInStock(int count);

  /// No description provided for @reportTagShortage.
  ///
  /// In en, this message translates to:
  /// **'Shortage -\${amount}'**
  String reportTagShortage(String amount);

  /// No description provided for @reportTagBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced \$0.00'**
  String get reportTagBalanced;

  /// No description provided for @reportTagActiveCredit.
  ///
  /// In en, this message translates to:
  /// **'Active Credit'**
  String get reportTagActiveCredit;

  /// No description provided for @reportTagBlockedOverdue.
  ///
  /// In en, this message translates to:
  /// **'BLOCKED (Overdue >30d)'**
  String get reportTagBlockedOverdue;

  /// No description provided for @reportTagOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy: {percent}%'**
  String reportTagOccupancy(int percent);

  /// No description provided for @reportTagTopPareto.
  ///
  /// In en, this message translates to:
  /// **'Top 80%'**
  String get reportTagTopPareto;

  /// No description provided for @reportMetricCostVal.
  ///
  /// In en, this message translates to:
  /// **'Cost Val: \${amount}'**
  String reportMetricCostVal(String amount);

  /// No description provided for @reportMetricSaleVal.
  ///
  /// In en, this message translates to:
  /// **'Sale Val: \${amount}'**
  String reportMetricSaleVal(String amount);

  /// No description provided for @reportMetricExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected: \${amount}'**
  String reportMetricExpected(String amount);

  /// No description provided for @reportMetricCounted.
  ///
  /// In en, this message translates to:
  /// **'Counted: \${amount}'**
  String reportMetricCounted(String amount);

  /// No description provided for @reportMetricCurrentDebt.
  ///
  /// In en, this message translates to:
  /// **'Current Debt: \${amount}'**
  String reportMetricCurrentDebt(String amount);

  /// No description provided for @reportMetricDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'Days Overdue: {days}'**
  String reportMetricDaysOverdue(int days);

  /// No description provided for @reportMetricTimeSales.
  ///
  /// In en, this message translates to:
  /// **'Time Sales: \${amount}'**
  String reportMetricTimeSales(String amount);

  /// No description provided for @reportMetricBarConsumed.
  ///
  /// In en, this message translates to:
  /// **'Bar Consumed: \${amount}'**
  String reportMetricBarConsumed(String amount);

  /// No description provided for @reportMetricRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue: \${amount}'**
  String reportMetricRevenue(String amount);

  /// No description provided for @reportMetricMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin: {percent}%'**
  String reportMetricMargin(String percent);

  /// No description provided for @reportSubShiftHours.
  ///
  /// In en, this message translates to:
  /// **'Opened {opened} • Closed {closed}'**
  String reportSubShiftHours(String opened, String closed);

  /// No description provided for @reportSubTableRateHours.
  ///
  /// In en, this message translates to:
  /// **'Rate: \${rate}/h • {hours} Hours Active'**
  String reportSubTableRateHours(String rate, String hours);

  /// No description provided for @reportSubParetoRankUnits.
  ///
  /// In en, this message translates to:
  /// **'Pareto Rank #{rank} • {units} Units Sold'**
  String reportSubParetoRankUnits(int rank, int units);

  /// No description provided for @reportSubSkuMin.
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku} • Min: {min} units'**
  String reportSubSkuMin(String sku, int min);

  /// No description provided for @reportSubRucLimit.
  ///
  /// In en, this message translates to:
  /// **'RUC: {ruc} • Limit: \${limit}'**
  String reportSubRucLimit(String ruc, String limit);

  /// No description provided for @reportShiftCashier.
  ///
  /// In en, this message translates to:
  /// **'Shift #{number} • Cashier: {name}'**
  String reportShiftCashier(String number, String name);

  /// No description provided for @categoryBeverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get categoryBeverages;

  /// No description provided for @categoryCocktails.
  ///
  /// In en, this message translates to:
  /// **'Cocktails'**
  String get categoryCocktails;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @forgotPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordPrompt;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your corporate email address to receive password recovery instructions.'**
  String get forgotPasswordDesc;

  /// No description provided for @resetPasswordEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions sent to your email.'**
  String get resetPasswordEmailSent;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @authSubtitleHint.
  ///
  /// In en, this message translates to:
  /// **'Multi-tenant access to operations & POS'**
  String get authSubtitleHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember session'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @demoProfilesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Quick access demo profiles:'**
  String get demoProfilesPrompt;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUp;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register a new enterprise user account'**
  String get signUpSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNamePlaceholder;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get accountCreatedSuccess;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailPrompt.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification email to {email}. Please verify your email to access all corporate features.'**
  String verifyEmailPrompt(String email);

  /// No description provided for @resendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerificationEmail;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent. Please check your inbox.'**
  String get verificationEmailSent;

  /// No description provided for @iHaveVerified.
  ///
  /// In en, this message translates to:
  /// **'I have verified my email'**
  String get iHaveVerified;

  /// No description provided for @emailNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified yet. Please check your inbox or click resend.'**
  String get emailNotVerifiedYet;

  /// No description provided for @printerManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Printer Management'**
  String get printerManagementTitle;

  /// No description provided for @printerManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configuration and pairing of thermal, USB, and Bluetooth printers'**
  String get printerManagementSubtitle;

  /// No description provided for @printersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Printers & Receipts'**
  String get printersSectionTitle;

  /// No description provided for @printersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure thermal, dot-matrix, USB, and Bluetooth receipt printers'**
  String get printersSectionSubtitle;

  /// No description provided for @activePrinter.
  ///
  /// In en, this message translates to:
  /// **'Active / Connected Printer'**
  String get activePrinter;

  /// No description provided for @noActivePrinter.
  ///
  /// In en, this message translates to:
  /// **'No printer is currently paired.'**
  String get noActivePrinter;

  /// No description provided for @scanBluetoothPrinters.
  ///
  /// In en, this message translates to:
  /// **'Search Bluetooth / USB Printers'**
  String get scanBluetoothPrinters;

  /// No description provided for @scanningPrinters.
  ///
  /// In en, this message translates to:
  /// **'Scanning for nearby devices...'**
  String get scanningPrinters;

  /// No description provided for @discoveredPrinters.
  ///
  /// In en, this message translates to:
  /// **'Available Devices'**
  String get discoveredPrinters;

  /// No description provided for @noDiscoveredPrinters.
  ///
  /// In en, this message translates to:
  /// **'No available printers found.'**
  String get noDiscoveredPrinters;

  /// No description provided for @connectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectPrinter;

  /// No description provided for @disconnectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get disconnectPrinter;

  /// No description provided for @editPrinterAlias.
  ///
  /// In en, this message translates to:
  /// **'Edit Name / Alias'**
  String get editPrinterAlias;

  /// No description provided for @printerAliasLabel.
  ///
  /// In en, this message translates to:
  /// **'Friendly Name (Alias)'**
  String get printerAliasLabel;

  /// No description provided for @printerAliasPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Counter - 80mm'**
  String get printerAliasPlaceholder;

  /// No description provided for @printerTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Paper Format / Technology'**
  String get printerTypeLabel;

  /// No description provided for @printerTypeThermal80.
  ///
  /// In en, this message translates to:
  /// **'Thermal 80 mm (POS Standard)'**
  String get printerTypeThermal80;

  /// No description provided for @printerTypeThermal58.
  ///
  /// In en, this message translates to:
  /// **'Thermal 58 mm (Mobile)'**
  String get printerTypeThermal58;

  /// No description provided for @printerTypeDotMatrix.
  ///
  /// In en, this message translates to:
  /// **'Dot Matrix (Continuous)'**
  String get printerTypeDotMatrix;

  /// No description provided for @macAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'MAC Address / Hardware ID'**
  String get macAddressLabel;

  /// No description provided for @connectionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Connection Interface'**
  String get connectionTypeLabel;

  /// No description provided for @autoPrintOnSaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto-print on checkout'**
  String get autoPrintOnSaleLabel;

  /// No description provided for @autoPrintOnSaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Directly dispatch voucher to default printer upon completed checkout'**
  String get autoPrintOnSaleSubtitle;

  /// No description provided for @printTestTicket.
  ///
  /// In en, this message translates to:
  /// **'Print Test Ticket'**
  String get printTestTicket;

  /// No description provided for @testTicketSent.
  ///
  /// In en, this message translates to:
  /// **'Test ticket dispatched successfully.'**
  String get testTicketSent;

  /// No description provided for @reprintVoucher.
  ///
  /// In en, this message translates to:
  /// **'Reprint Voucher'**
  String get reprintVoucher;

  /// No description provided for @shareVoucher.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get shareVoucher;

  /// No description provided for @previewVoucher.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewVoucher;

  /// No description provided for @notificationsAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get notificationsAndAlerts;

  /// No description provided for @liveFirestoreSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Firestore Sync'**
  String get liveFirestoreSyncTitle;

  /// No description provided for @liveFirestoreSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'All records synchronized with Cloud Firestore.'**
  String get liveFirestoreSyncDesc;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @activeCashDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Cash Register'**
  String get activeCashDrawerTitle;

  /// No description provided for @activeCashDrawerDesc.
  ///
  /// In en, this message translates to:
  /// **'Shift open in active branch.'**
  String get activeCashDrawerDesc;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @secureMultiTenantSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Multi-Tenant Session'**
  String get secureMultiTenantSessionTitle;

  /// No description provided for @secureMultiTenantSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'RBAC permissions validated for active user.'**
  String get secureMultiTenantSessionDesc;

  /// No description provided for @onlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineStatus;

  /// No description provided for @terminalUnlockedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Terminal unlocked successfully'**
  String get terminalUnlockedSuccess;

  /// No description provided for @customerDirectorySynced.
  ///
  /// In en, this message translates to:
  /// **'Customer directory synchronized'**
  String get customerDirectorySynced;

  /// No description provided for @productCatalogSynced.
  ///
  /// In en, this message translates to:
  /// **'Product catalog synchronized'**
  String get productCatalogSynced;

  /// No description provided for @supplierDirectorySynced.
  ///
  /// In en, this message translates to:
  /// **'Supplier directory synchronized'**
  String get supplierDirectorySynced;

  /// No description provided for @invoiceHistoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Invoice history updated'**
  String get invoiceHistoryUpdated;

  /// No description provided for @goodsReceivedInWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Goods received in warehouse'**
  String get goodsReceivedInWarehouse;

  /// No description provided for @shiftZClosedExact.
  ///
  /// In en, this message translates to:
  /// **'Z-Cut processed with exact balance'**
  String get shiftZClosedExact;

  /// No description provided for @hardwareLabel.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get hardwareLabel;

  /// No description provided for @activeChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeChipLabel;

  /// No description provided for @sendingVoucherToPrinter.
  ///
  /// In en, this message translates to:
  /// **'Sending voucher to printer...'**
  String get sendingVoucherToPrinter;

  /// No description provided for @onboardingConfiguredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Initial organization and branch configured successfully'**
  String get onboardingConfiguredSuccess;

  /// No description provided for @openAccountsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Orders'**
  String get openAccountsListTitle;

  /// No description provided for @searchAccountsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search order or table...'**
  String get searchAccountsPlaceholder;

  /// No description provided for @noOpenAccountsFound.
  ///
  /// In en, this message translates to:
  /// **'No open accounts or orders.'**
  String get noOpenAccountsFound;

  /// No description provided for @openNewTabPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap \'+\' or the button below to open a new tab.'**
  String get openNewTabPrompt;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @itemsInOrder.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsInOrder(int count);

  /// No description provided for @originTypeTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get originTypeTable;

  /// No description provided for @originTypeCounter.
  ///
  /// In en, this message translates to:
  /// **'Bar / Counter'**
  String get originTypeCounter;

  /// No description provided for @originTypeCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get originTypeCustomer;

  /// No description provided for @originTypeFreeName.
  ///
  /// In en, this message translates to:
  /// **'Custom Tab'**
  String get originTypeFreeName;

  /// No description provided for @emptyOrderPrompt.
  ///
  /// In en, this message translates to:
  /// **'No items added yet. Select products from the catalog to add to this order.'**
  String get emptyOrderPrompt;

  /// No description provided for @filterByTableOrCustomer.
  ///
  /// In en, this message translates to:
  /// **'Filter by table or customer...'**
  String get filterByTableOrCustomer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

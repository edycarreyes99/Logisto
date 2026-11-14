// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Logisto ERP & Smart POS';

  @override
  String get appTagline =>
      'Gestión Comercial, Operativa y Financiera Multi-Sucursal';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get billiards => 'Billares';

  @override
  String get openAccounts => 'Cuentas';

  @override
  String get pos => 'Punto de Venta';

  @override
  String get kitchen => 'Cocina KDS';

  @override
  String get cash => 'Caja y Turnos';

  @override
  String get products => 'Productos';

  @override
  String get inventory => 'Inventario';

  @override
  String get kardex => 'Kardex';

  @override
  String get customers => 'Clientes';

  @override
  String get invoices => 'Facturas';

  @override
  String get suppliers => 'Proveedores';

  @override
  String get purchasing => 'Compras';

  @override
  String get receivables => 'Cobros';

  @override
  String get payables => 'Pagos';

  @override
  String get reports => 'Reportes';

  @override
  String get users => 'Personal';

  @override
  String get settings => 'Ajustes';

  @override
  String get audit => 'Auditoría';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get onboarding => 'Asistente';

  @override
  String get businessUnits => 'Sucursales';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get accept => 'Aceptar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Crear';

  @override
  String get search => 'Buscar';

  @override
  String get searchPlaceholder =>
      'Buscar por nombre, código o identificación...';

  @override
  String get filter => 'Filtrar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get finish => 'Finalizar';

  @override
  String get seedDatabase => 'Sembrar BD';

  @override
  String get databaseSeededSuccess =>
      'Base de datos inicializada con éxito en Cloud Firestore.';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get switchBranch => 'Cambiar Sucursal';

  @override
  String get fastPin => 'PIN Rápido';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get printTicket => 'Imprimir Ticket';

  @override
  String get pay => 'Pagar';

  @override
  String get openShift => 'Abrir Turno';

  @override
  String get closeShift => 'Cerrar Turno (Corte Z)';

  @override
  String get transfer => 'Trasladar';

  @override
  String get addProduct => 'Nuevo Producto';

  @override
  String get addCustomer => 'Nuevo Cliente';

  @override
  String get addSupplier => 'Nuevo Proveedor';

  @override
  String get addWarehouse => 'Nueva Bodega';

  @override
  String get inviteUser => 'Registrar Colaborador';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get pinLabel => 'PIN de Terminal (4 dígitos)';

  @override
  String get loginButton => 'Ingresar al Sistema';

  @override
  String get googleSignIn => 'Ingresar con Google';

  @override
  String get switchAccount => 'Cambiar de Cuenta';

  @override
  String get invalidCredentials =>
      'Credenciales inválidas. Por favor intente de nuevo.';

  @override
  String get enterPin => 'Ingrese su PIN de 4 dígitos';

  @override
  String get pinPrompt => 'Ingrese el PIN para cambio rápido de usuario';

  @override
  String get welcomeTitle => 'Bienvenido a Logisto ERP';

  @override
  String get welcomeDesc =>
      'Configure su organización y su primera sucursal para comenzar.';

  @override
  String get createFirstBranch => 'Paso 1: Crear Primera Sucursal';

  @override
  String get selectBusinessType => 'Tipo de Giro Comercial';

  @override
  String get branchNameLabel => 'Nombre de la Sucursal';

  @override
  String get initializeDefaults => 'Paso 2: Inicializar Catálogos Operativos';

  @override
  String get sampleCatalogPrompt =>
      'Se cargarán productos, bodegas, cajas y configuraciones base en Cloud Firestore.';

  @override
  String get startUsingApp => 'Comenzar a Operar';

  @override
  String stepLabel(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get selectBranchPrompt => 'Seleccione la sucursal activa para operar:';

  @override
  String get noBranchesFound => 'No se encontraron sucursales asignadas.';

  @override
  String get activeBranchBadge => 'Sucursal Activa';

  @override
  String get todaySales => 'Ventas Hoy';

  @override
  String get weekSales => 'Ventas Semana';

  @override
  String get monthSales => 'Ventas Mes';

  @override
  String get activeCash => 'Efectivo en Caja';

  @override
  String get openTabs => 'Cuentas Abiertas';

  @override
  String get totalProducts => 'Total Productos';

  @override
  String get totalCustomers => 'Clientes Registrados';

  @override
  String get topSellingProducts => 'Top Productos Más Vendidos';

  @override
  String get salesByCategory => 'Ventas por Categoría';

  @override
  String get salesByTender => 'Ventas por Método de Pago';

  @override
  String get cartTitle => 'Resumen de Venta e Ítems';

  @override
  String get emptyCart =>
      'El carrito está vacío. Agregue productos del catálogo.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Descuento';

  @override
  String get total => 'Total a Pagar';

  @override
  String get tenderCash => 'Efectivo';

  @override
  String get tenderCard => 'Tarjeta';

  @override
  String get tenderCredit => 'Crédito a Cliente';

  @override
  String get tenderTransfer => 'Transferencia';

  @override
  String get changeDue => 'Cambio / Vuelto';

  @override
  String get amountTendered => 'Entregado';

  @override
  String get referenceCode => 'Código / Referencia de Pago';

  @override
  String get selectCustomer => 'Cliente';

  @override
  String get consumidorFinal => 'Consumidor Final (CF)';

  @override
  String creditAvailable(String amount) {
    return 'Crédito Disponible: $amount';
  }

  @override
  String get creditExceeded =>
      'El monto supera el límite de crédito disponible.';

  @override
  String invoiceCreatedSuccess(String number) {
    return 'Factura #$number generada con éxito.';
  }

  @override
  String get ticketHeader => 'COMPROBANTE DE VENTA';

  @override
  String get printSuccess => 'Ticket térmico enviado a la impresora.';

  @override
  String tableNumber(int number) {
    return 'Mesa #$number';
  }

  @override
  String get tableType => 'Tipo de Mesa';

  @override
  String get hourlyRate => 'Tarifa por Hora';

  @override
  String get statusAvailable => 'Disponible';

  @override
  String get statusOccupied => 'Ocupada';

  @override
  String get statusPaused => 'En Pausa';

  @override
  String get statusMaintenance => 'Mantenimiento';

  @override
  String get startSession => 'Iniciar Tiempo';

  @override
  String get pauseSession => 'Pausar';

  @override
  String get resumeSession => 'Reanudar';

  @override
  String get stopSession => 'Detener y Cobrar';

  @override
  String get transferTable => 'Transferir Mesa';

  @override
  String get selectDestinationTable => 'Seleccionar mesa de destino';

  @override
  String elapsedMinutes(int minutes) {
    return 'Tiempo: $minutes min';
  }

  @override
  String currentAmount(String amount) {
    return 'Monto: $amount';
  }

  @override
  String get openTabsTitle => 'Cuentas Activas';

  @override
  String get openNewTab => 'Abrir Nueva Cuenta de Mesa / Barra';

  @override
  String get tabNamePlaceholder => 'Nombre o Identificador de Cuenta...';

  @override
  String get tableAssignment => 'Asignar Mesa (Opcional)';

  @override
  String get addItemToTab => 'Agregar Ítem';

  @override
  String get sendToKitchen => 'Enviar a Comanda';

  @override
  String get checkoutTab => 'Cobrar Cuenta';

  @override
  String get preReceipt => 'Imprimir Pre-Cuenta';

  @override
  String get splitTab => 'Dividir Cuenta';

  @override
  String get sku => 'Código SKU';

  @override
  String get barcode => 'Código de Barras';

  @override
  String get productName => 'Nombre del Producto';

  @override
  String get category => 'Categoría';

  @override
  String get productType => 'Tipo de Producto';

  @override
  String get costPrice => 'Precio de Costo';

  @override
  String get salePrice => 'Precio de Venta';

  @override
  String get stockQuantity => 'Existencias';

  @override
  String get minStock => 'Stock Mínimo';

  @override
  String get warehouse => 'Bodega';

  @override
  String get transferStock => 'Trasladar Mercancía';

  @override
  String get sourceWarehouse => 'Almacén Origen';

  @override
  String get destWarehouse => 'Almacén Destino';

  @override
  String get adjustStock => 'Ajuste de Inventario';

  @override
  String get customerName => 'Nombre del Cliente';

  @override
  String get taxId => 'RUC / Cédula';

  @override
  String get phone => 'Teléfono';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get creditLimit => 'Límite de Crédito';

  @override
  String get currentDebt => 'Saldo Deudor';

  @override
  String get creditBlocked => 'Crédito Bloqueado por Mora';

  @override
  String get allowCredit => 'Habilitar Línea de Crédito';

  @override
  String get customerSavedSuccess => 'Cliente guardado exitosamente.';

  @override
  String get supplierName => 'Razón Social Proveedor';

  @override
  String get contactPerson => 'Contacto / Ejecutivo';

  @override
  String get paymentTermsDays => 'Días de Crédito';

  @override
  String get supplierSavedSuccess => 'Proveedor guardado exitosamente.';

  @override
  String get activeShift => 'Turno de Caja Activo';

  @override
  String get noActiveShift =>
      'No hay un turno de caja abierto en esta sucursal.';

  @override
  String get startingCash => 'Fondo Inicial de Caja';

  @override
  String get expectedCash => 'Efectivo Esperado en Sistema';

  @override
  String get actualCash => 'Conteo Físico Real';

  @override
  String get discrepancy => 'Diferencia de Arqueo';

  @override
  String get balanced => 'Cuadrado Exacto';

  @override
  String get shortage => 'Faltante de Caja';

  @override
  String get surplus => 'Sobrante de Caja';

  @override
  String get blindDropPrompt =>
      'Arqueo Ciego: Ingrese el conteo físico de billetes y monedas sin visualizar el saldo de sistema.';

  @override
  String get performBlindDrop => 'Registrar Arqueo Ciego';

  @override
  String get xCut => 'Corte Parcial X';

  @override
  String get zCut => 'Corte de Cierre Z';

  @override
  String get shiftClosedSuccess => 'Turno cerrado exitosamente con Corte Z.';

  @override
  String get kitchenOrders => 'Comandas de Cocina';

  @override
  String get barOrders => 'Comandas de Barra';

  @override
  String get markCooking => 'En Preparación';

  @override
  String get markReady => 'Marcar Listo';

  @override
  String get markServed => 'Marcar Servido';

  @override
  String elapsedOrderTime(String time) {
    return 'Transcurrido: $time';
  }

  @override
  String get userName => 'Nombre del Colaborador';

  @override
  String get userEmail => 'Correo de Acceso';

  @override
  String get userRole => 'Rol en Sucursal';

  @override
  String get superAdmin => 'Super Administrador Global';

  @override
  String get assignRole => 'Asignar Rol';

  @override
  String get terminalPin => 'PIN de Terminal';

  @override
  String get roleUpdatedSuccess => 'Rol actualizado exitosamente.';

  @override
  String get userInvitedSuccess => 'Colaborador registrado exitosamente.';

  @override
  String get companySettings => 'Parámetros de la Organización';

  @override
  String get rbacMatrix => 'Matriz de Permisos RBAC';

  @override
  String get supervisorElevation => 'Autorización de Supervisor Requerida';

  @override
  String get enterSupervisorPin =>
      'Ingrese el PIN de un supervisor autorizado para continuar:';

  @override
  String get pinVerified => 'Autorización aprobada.';

  @override
  String get pinIncorrect => 'PIN incorrecto o sin privilegios de supervisor.';

  @override
  String get lightTheme => 'Modo Claro (Blanco)';

  @override
  String get darkTheme => 'Modo Oscuro';

  @override
  String get spanishLanguage => 'Español';

  @override
  String get englishLanguage => 'English';

  @override
  String get auditTrail => 'Auditoría';

  @override
  String get actionType => 'Tipo de Acción';

  @override
  String get performedBy => 'Ejecutado Por';

  @override
  String get timestamp => 'Fecha y Hora';

  @override
  String get details => 'Detalles';

  @override
  String get requiredField => 'Este campo es requerido.';

  @override
  String get invalidEmail => 'Ingrese un correo electrónico válido.';

  @override
  String get numberRequired => 'Ingrese un valor numérico válido.';

  @override
  String get operationSuccessful => 'Operación realizada con éxito.';

  @override
  String get operationFailed =>
      'La operación no pudo completarse. Revise los datos.';

  @override
  String get confirmationPrompt => '¿Está seguro de realizar esta acción?';

  @override
  String get deleteConfirmation =>
      '¿Está seguro de eliminar este registro permanentemente?';

  @override
  String get logoutConfirmation =>
      '¿Está seguro de que desea cerrar la sesión actual?';

  @override
  String get recordDeletedSuccess => 'Registro eliminado con éxito.';

  @override
  String get modules => 'Módulos';

  @override
  String get logistoEnterprise => 'Logisto Empresarial';

  @override
  String get corporatePortalLogin => 'Portal Corporativo - Iniciar Sesión';

  @override
  String get welcomeBannerTitle => 'Logisto ERP y POS Multiplataforma';

  @override
  String get welcomeBannerDesc =>
      'Operaciones empresariales unificadas para comercio, salas de billar, farmacias y hostelería. Sincronización Firestore offline-first con controles de alta densidad para escritorio.';

  @override
  String get fastPinAlert =>
      'Cambio Rápido de Operador habilitado para POS multiusuario.';

  @override
  String get newOrgSetup => 'Configurar Nueva Empresa';

  @override
  String get fastPinSwitch => 'Cambio Rápido por PIN';

  @override
  String get enterPinPrompt =>
      'Ingrese el PIN de 4 dígitos para desbloquear la estación:';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get invalidPin => 'PIN de 4 dígitos inválido.';

  @override
  String get systemInformation => 'Información del Sistema';

  @override
  String get operationalControls => 'Controles Operativos';

  @override
  String get liveEventStream => 'Flujo de Eventos en Vivo';

  @override
  String get registerNewBranch => 'Registrar Nueva Sucursal';

  @override
  String get branchName => 'Nombre de Sucursal';

  @override
  String get physicalAddress => 'Dirección Física';

  @override
  String get createBranch => 'Crear Sucursal';

  @override
  String get manageBranches => 'Gestionar Sucursales';

  @override
  String get selectBranchToOperate =>
      'Seleccione una sucursal activa para operar:';

  @override
  String get onboardingTitle => 'Asistente de Configuración Logisto';

  @override
  String get step1Title => 'Paso 1: Arquitectura Empresarial';

  @override
  String get step2Title => 'Paso 2: Primera Sucursal Operativa';

  @override
  String get step3Title => 'Paso 3: Infraestructura Inicial de Estación';

  @override
  String get step4Title => 'Paso 4: Disponibilidad Operativa';

  @override
  String get primaryBusinessSegment => 'Giro de Negocio Principal:';

  @override
  String get billiardSetupPrompt =>
      'Configurar mesas iniciales de alquiler de billar:';

  @override
  String get retailSetupPrompt =>
      'Configuración inicial de almacén y gaveta de dinero:';

  @override
  String get readyToLaunch =>
      'Todo listo para iniciar su espacio de trabajo empresarial.';

  @override
  String get seedProductionDataPrompt =>
      'Inyectar semillas iniciales de producción (productos, almacenes, mesas, clientes, proveedores)';

  @override
  String get completeAndStart => 'Completar Configuración e Iniciar';

  @override
  String get createProduct => 'Crear Producto';

  @override
  String get editProduct => 'Editar Producto';

  @override
  String get stockWarehouses => 'Almacenes y Stock';

  @override
  String get internalTransfer => 'Transferencia Interna entre Almacenes';

  @override
  String get transferQuantity => 'Cantidad a Transferir';

  @override
  String get confirmTransfer => 'Confirmar Transferencia';

  @override
  String get confirmAdjustment => 'Confirmar Ajuste';

  @override
  String get adjustmentReason => 'Motivo del Ajuste';

  @override
  String get newWarehouse => 'Nuevo Almacén';

  @override
  String get warehouseName => 'Nombre del Almacén';

  @override
  String get warehouseCode => 'Código del Almacén';

  @override
  String get isDefaultSalesWarehouse => 'Almacén Predeterminado para Despacho';

  @override
  String get startTable => 'Iniciar Mesa';

  @override
  String get pauseTable => 'Pausar';

  @override
  String get resumeTable => 'Reanudar';

  @override
  String get sendToTab => 'Cargar a Cuenta';

  @override
  String get tableStatusAvailable => 'Disponible';

  @override
  String get tableStatusOccupied => 'En Juego';

  @override
  String get tableStatusPaused => 'Pausada';

  @override
  String get tableStatusBilling => 'En Cobro';

  @override
  String get ratePerHour => 'Tarifa por hora';

  @override
  String get player => 'Jugador / Cliente';

  @override
  String get accrued => 'Acumulado';

  @override
  String get tableReady => 'Mesa lista para check-in';

  @override
  String get enterCustomerPrompt =>
      'Ingrese nombre del cliente o alias de mesa:';

  @override
  String get openAccountsTitle => 'Cuentas Abiertas y Cuentas de Barra';

  @override
  String get tabAliasPrompt =>
      'Cliente / Alias de Mesa (ej. Mesa 1, Barra Carlos)';

  @override
  String get preBillPreview => 'Vista Previa de Pre-Cuenta';

  @override
  String get totalToCollect => 'Total a Cobrar';

  @override
  String get sendToCheckout => 'Proceder al Pago / Caja';

  @override
  String get addItem => 'Agregar Artículo';

  @override
  String get multiTenderPayment => 'Pago Multi-Método';

  @override
  String get customerSelectOrRegister => 'Seleccionar o Registrar Cliente';

  @override
  String get availableCredit => 'Crédito Disponible';

  @override
  String get creditCeiling => 'Límite de Crédito';

  @override
  String get changeCustomer => 'Cambiar';

  @override
  String get quickCatalog => 'Catálogo Rápido de Productos';

  @override
  String get noProductsAvailable =>
      'No hay productos disponibles en esta sucursal.';

  @override
  String get confirmAndInvoice => 'Confirmar y Emitir Factura';

  @override
  String get thermalReceipt => 'Ticket Térmico (ESC/POS)';

  @override
  String get printThermal => 'Imprimir Ticket';

  @override
  String get newSale => 'Nueva Venta';

  @override
  String get cashShiftsTitle => 'Turnos de Caja y Controles de Corte Ciego';

  @override
  String get openNewShift => 'Abrir Nuevo Turno';

  @override
  String get openingFloat => 'Fondo de Caja Inicial';

  @override
  String get recordCashMovement => 'Registrar Movimiento de Efectivo';

  @override
  String get withdrawalSangria => 'Retiro (Sangría)';

  @override
  String get cashInflow => 'Ingreso de Efectivo';

  @override
  String get blindDropTitle => 'Corte Ciego y Cierre Z';

  @override
  String get physicalCashCount => 'Efectivo Físico Contado';

  @override
  String get closeShiftConfirm => 'Cerrar Turno y Bloquear Gaveta';

  @override
  String get taxIdRuc => 'Identificación Fiscal / RUC / Cédula';

  @override
  String get creditBlockedStatus => 'BLOQUEADO';

  @override
  String get creditActiveStatus => 'ACTIVO';

  @override
  String get blockCredit => 'Bloquear Crédito';

  @override
  String get unblockCredit => 'Desbloquear Crédito';

  @override
  String get creditDays => 'Días de Crédito';

  @override
  String get editRole => 'Editar Rol';

  @override
  String get deleteUser => 'Eliminar Usuario';

  @override
  String get accountsReceivableTitle => 'Cuentas por Cobrar (CxC) y ROC';

  @override
  String get collectPaymentRoc => 'Cobrar Recibo Oficial de Caja (ROC)';

  @override
  String get accountsPayableTitle => 'Cuentas por Pagar (CxP)';

  @override
  String get paySupplier => 'Pagar a Proveedor';

  @override
  String get dueDate => 'Fecha de Vencimiento';

  @override
  String get totalDebt => 'Deuda Total';

  @override
  String get balanceRemaining => 'Saldo Pendiente';

  @override
  String get emitReceiptAndApply => 'Emitir Recibo y Aplicar';

  @override
  String get disbursePayment => 'Desembolsar Pago';

  @override
  String get purchasingTitle => 'Órdenes de Compra y Recepción de Mercadería';

  @override
  String get createPurchaseOrder => 'Crear Orden de Compra';

  @override
  String get receiveGoods => 'Recibir Mercadería Entrante';

  @override
  String get orderStatus => 'Estado de la Orden';

  @override
  String get kitchenKdsTitle => 'Sistema de Pantallas de Cocina y Barra (KDS)';

  @override
  String get markInPreparation => 'En Preparación';

  @override
  String get orderQueueEmpty => 'No hay órdenes en esta cola de estado.';

  @override
  String get settingsTitle => 'Ajustes y RBAC';

  @override
  String get corporateSettings => 'Corporativo y Fiscal';

  @override
  String get corporateTaxConfig => 'Configuración Corporativa y Fiscal';

  @override
  String get rbacSecurity => 'Seguridad RBAC';

  @override
  String get appearanceAndLanguage => 'Apariencia e Idioma';

  @override
  String get themeModeLabel => 'Modo de Tema';

  @override
  String get themeLight => 'Claro (Blanco)';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get languageLabel => 'Idioma del Sistema';

  @override
  String get langSpanish => 'Español';

  @override
  String get langEnglish => 'English (Inglés)';

  @override
  String get currencyExchange => 'Moneda y Tipos de Cambio';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get changesSavedSuccess => 'Configuración guardada con éxito.';

  @override
  String get filterToday => 'Hoy';

  @override
  String get filterWeek => 'Semana';

  @override
  String get filterMonth => 'Mes';

  @override
  String get filterYear => 'Año';

  @override
  String get navSectionCoreOperations => 'Operaciones Principales';

  @override
  String get navSectionInventoryOperations => 'Inventario y Operaciones';

  @override
  String get navSectionCatalogsPartners => 'Catálogos y Directorios';

  @override
  String get navSectionFinanceLedgers => 'Finanzas y Contabilidad';

  @override
  String get navSectionSystemManagement => 'Administración y Sistema';

  @override
  String get navOffcanvasTitle => 'Módulos de Logisto ERP';

  @override
  String get defaultBranchName => 'Sucursal Central';

  @override
  String get menu => 'Menú';

  @override
  String get selectBranch => 'Seleccionar Sucursal';

  @override
  String get filterAuditLogsPlaceholder => 'Filtrar registros de auditoría...';

  @override
  String get tableHeaderTimestamp => 'Fecha / Hora';

  @override
  String get tableHeaderUser => 'Usuario';

  @override
  String get tableHeaderAction => 'Acción';

  @override
  String get tableHeaderDescription => 'Descripción';

  @override
  String get tableHeaderBeforeAfter => 'Antes / Después';

  @override
  String get tableHeaderClientIp => 'IP del Cliente';

  @override
  String get tableCustomerAliasPlaceholder => 'ej. Carlos M.';

  @override
  String get billiardFloorPlanTitle => 'Mesas de Billar y Distribución';

  @override
  String get selectDestinationTablePrompt =>
      'Seleccione una mesa de destino disponible:';

  @override
  String get noTablesAvailableForTransfer =>
      'No hay otras mesas disponibles en este momento.';

  @override
  String get currentShiftSummary => 'Resumen del Turno Actual';

  @override
  String get openingFloatPrompt => 'Ingrese el fondo fijo de apertura de caja:';

  @override
  String get amountPlaceholder => 'Monto (ej. 50.00)';

  @override
  String get tableHeaderTime => 'Hora';

  @override
  String get tableHeaderType => 'Tipo';

  @override
  String get tableHeaderAmount => 'Monto';

  @override
  String get tableHeaderReason => 'Motivo';

  @override
  String get blindDropShiftClosure => 'Cierre de Turno a Ciegas (Corte Z)';

  @override
  String get expectedBalance => 'Saldo Esperado:';

  @override
  String get physicalCashCountedPrompt =>
      'Ingrese el efectivo físico total contado en gaveta (USD):';

  @override
  String get physicalCountedAmountPlaceholder =>
      'Monto Físico Contado (ej. 520.00)';

  @override
  String get noCustomersFound =>
      'No se encontraron clientes coincidentes con la búsqueda.';

  @override
  String get placeholderFirstName => 'Nombres';

  @override
  String get placeholderLastName => 'Apellidos';

  @override
  String get placeholderTaxId => 'RUC / Cédula / Identificación';

  @override
  String get placeholderPhone => 'Número de Teléfono';

  @override
  String get placeholderEmail => 'Correo Electrónico';

  @override
  String get placeholderCreditLimit => 'Límite de Crédito (\$)';

  @override
  String get tableHeaderTaxId => 'Identificación / RUC';

  @override
  String get tableHeaderCustomerName => 'Nombre del Cliente';

  @override
  String get tableHeaderAvailableHeadroom => 'Cupo Disponible';

  @override
  String get tableHeaderStatus => 'Estado';

  @override
  String get tableHeaderActions => 'Acciones';

  @override
  String get kpiRealtime => 'Tiempo Real';

  @override
  String get kpiAuditReady => 'Auditado';

  @override
  String get tableHeaderQtySold => 'Cant. Vendida';

  @override
  String get tableHeaderRevenue => 'Ingresos';

  @override
  String get filterLogsPlaceholder => 'Filtrar registros o telemetría...';

  @override
  String get tableHeaderService => 'Servicio';

  @override
  String get tableHeaderTarget => 'Destino';

  @override
  String get telemetryAndStatus => 'Telemetría y Estado';

  @override
  String get processedTasksLabel => 'Tareas Procesadas:';

  @override
  String get telemetryNodeOperational =>
      'Nodo multiplataforma operativo en el entorno actual.';

  @override
  String get transferSourceBodega => 'Origen: Bodega Central de Reserva';

  @override
  String get transferDestBarra => 'Destino: Barra Principal (Piso de Venta)';

  @override
  String get auditedStockCountPrompt =>
      'Ingrese el conteo de inventario físico auditado:';

  @override
  String get transferQuantityPlaceholder => 'Cantidad a Transferir (Unidades)';

  @override
  String get newTotalQuantityPlaceholder => 'Nueva Cantidad Total';

  @override
  String get tableHeaderAvailableStock => 'Stock Disponible';

  @override
  String get tableHeaderReserved => 'Reservado';

  @override
  String get noKardexMovements => 'No hay movimientos de Kardex registrados.';

  @override
  String get tableHeaderMovementType => 'Tipo de Movimiento';

  @override
  String get tableHeaderQuantity => 'Cantidad';

  @override
  String get tableHeaderTotalValue => 'Valor Total';

  @override
  String get tableHeaderReferenceNotes => 'Referencia / Notas';

  @override
  String get voidInvoiceTitle => 'Anular Factura de Venta';

  @override
  String get voidInvoiceConfirmation =>
      '¿Está seguro de que desea anular esta factura de venta? Los movimientos de inventario se revertirán y se registrará una entrada de auditoría.';

  @override
  String get searchInvoicePlaceholder => 'Buscar factura # o cliente...';

  @override
  String get noInvoicesRecorded => 'No hay facturas de venta registradas aún.';

  @override
  String get tableHeaderInvoiceNumber => 'Factura #';

  @override
  String get tableHeaderCustomer => 'Cliente';

  @override
  String get tableHeaderCashier => 'Cajero';

  @override
  String get tableHeaderPaymentTender => 'Método de Pago';

  @override
  String get kdsOrderCompleted => 'Orden completada.';

  @override
  String get kdsOrderCancelled => 'Orden cancelada.';

  @override
  String get hourlyRatePlaceholder => 'Tarifa por hora (ej. 10.00)';

  @override
  String get fastCatalogTitle => 'Catálogo Rápido Bar / Cocina';

  @override
  String get tapItemToAddPrompt =>
      'Toque un artículo para agregar inmediatamente a la cuenta actual:';

  @override
  String get activeTabOrderTitle => 'Orden de la Cuenta Activa';

  @override
  String get noTabSelected =>
      'Ninguna cuenta seleccionada. Seleccione o cree una cuenta abierta.';

  @override
  String get noConsumablesLoaded =>
      'No hay consumibles cargados aún. Haga clic en los ítems a la izquierda para agregar.';

  @override
  String get noSupplierLiabilities =>
      'No hay pasivos con proveedores registrados.';

  @override
  String get paymentAmountPlaceholder => 'Monto del Pago (\$)';

  @override
  String get tableHeaderSupplier => 'Proveedor';

  @override
  String get tableHeaderSupplierInvoiceNumber => 'Factura Proveedor #';

  @override
  String get tableHeaderPaidToDate => 'Pagado a la Fecha';

  @override
  String get consumidorFinalWalkIn => 'Consumidor Final';

  @override
  String get errorTitle => 'Error';

  @override
  String get tableHeaderItem => 'Artículo';

  @override
  String get tableHeaderQty => 'Cant.';

  @override
  String get productNamePlaceholder => 'Nombre del producto...';

  @override
  String get skuPlaceholder => 'SKU-001';

  @override
  String get tableHeaderSkuBarcode => 'SKU / Código';

  @override
  String get noPurchaseOrdersRegistered =>
      'No hay órdenes de compra registradas.';

  @override
  String get estimatedOrderValuePlaceholder =>
      'Valor Estimado de la Orden (\$)';

  @override
  String get tableHeaderOrderRef => 'Ref. de Orden';

  @override
  String get tableHeaderOrderDate => 'Fecha de Orden';

  @override
  String get noOutstandingReceivables =>
      'No hay cuentas por cobrar pendientes.';

  @override
  String get tableHeaderBalanceDue => 'Saldo por Cobrar';

  @override
  String get reportExportedSuccess => 'Reporte Exportado Exitosamente';

  @override
  String get reportExportedDesc =>
      'El libro financiero y las métricas operativas se han compilado en formato CSV.\n\nListo para archivo de auditoría corporativa.';

  @override
  String get tableHeaderItemConcept => 'Ítem / Concepto';

  @override
  String get tableHeaderDetailsSku => 'Detalles / SKU';

  @override
  String get tableHeaderMetric1 => 'Métrica 1';

  @override
  String get tableHeaderMetric2 => 'Métrica 2';

  @override
  String get tableHeaderStatusRatio => 'Estado / Ratio';

  @override
  String get tabAppearance => 'Apariencia';

  @override
  String get legalNameLabel => 'Razón Social:';

  @override
  String get commercialBrandLabel => 'Nombre Comercial:';

  @override
  String get salesTaxRateLabel => 'Tasa de Impuesto IVA (%):';

  @override
  String get rbacMatrixTitle => 'Matriz de Seguridad y Permisos RBAC';

  @override
  String get tableHeaderRoleKey => 'Clave de Rol';

  @override
  String get tableHeaderAccessibleModules => 'Módulos Accesibles';

  @override
  String get tableHeaderSensitivePermissions => 'Permisos Sensibles';

  @override
  String get supervisorPinPrompt =>
      'Esta acción requiere permisos elevados de supervisor. Ingrese el PIN de 4 dígitos autorizado:';

  @override
  String get noSuppliersFound => 'No se encontraron proveedores.';

  @override
  String get placeholderCompanyLegalName => 'Razón Social de la Empresa';

  @override
  String get placeholderContactPerson => 'Persona de Contacto';

  @override
  String get placeholderPaymentTerms => 'Plazo de Pago (ej. 30 Días)';

  @override
  String get tableHeaderCompanyName => 'Nombre de Empresa';

  @override
  String get tableHeaderContactPerson => 'Persona de Contacto';

  @override
  String get tableHeaderCreditTerms => 'Plazo de Crédito';

  @override
  String get tableHeaderPayableBalance => 'Saldo por Pagar';

  @override
  String get tableHeaderUserName => 'Colaborador';

  @override
  String get tableHeaderUserEmail => 'Correo';

  @override
  String get tableHeaderSuperAdmin => 'Super Admin';

  @override
  String get tableHeaderAssignedBranches => 'Sucursales Asignadas';

  @override
  String get yes => 'SÍ';

  @override
  String get no => 'NO';

  @override
  String get statusActive => 'ACTIVO';

  @override
  String get statusInactive => 'INACTIVO';

  @override
  String get statusActiveTitle => 'Activo';

  @override
  String get statusInactiveTitle => 'Inactivo';

  @override
  String get staff => 'Personal';

  @override
  String get placeholderFullName => 'Nombre completo...';

  @override
  String get sendInvite => 'Enviar Invitación';

  @override
  String get companyEmailPlaceholder => 'admin@empresa.com';

  @override
  String get userEmailPlaceholder => 'colaborador@logisto.com';

  @override
  String get editCustomer => 'Editar Cliente';

  @override
  String get editSupplier => 'Editar Proveedor';

  @override
  String startTableNamed(String name) {
    return 'Iniciar $name';
  }

  @override
  String transferTableNamed(String name) {
    return 'Transferir $name';
  }

  @override
  String openCashShiftRegister(int number) {
    return 'Apertura de Caja (Caja #$number)';
  }

  @override
  String reconciliationStatus(String status) {
    return 'Estado de Conciliación: $status';
  }

  @override
  String registerActiveShift(int number) {
    return 'Caja #$number • Turno Activo';
  }

  @override
  String customerDebtAmount(String amount) {
    return 'Deuda: \$$amount';
  }

  @override
  String telemetryTasksProcessed(int count) {
    return 'Tareas de telemetría procesadas: $count';
  }

  @override
  String kardexValueAmount(String amount) {
    return 'Val: \$$amount';
  }

  @override
  String invoiceDetailsTitle(String number) {
    return 'Factura #$number';
  }

  @override
  String invoiceCustomerLabel(String name) {
    return 'Cliente: $name';
  }

  @override
  String invoiceCashierLabel(String cashier) {
    return 'Cajero: $cashier';
  }

  @override
  String kdsItemNote(String note) {
    return 'Nota: $note';
  }

  @override
  String preBillPreviewCode(String code) {
    return 'Vista Previa Pre-Cuenta: $code';
  }

  @override
  String customerDisplayName(String name) {
    return 'Cliente: $name';
  }

  @override
  String paySupplierNamed(String name) {
    return 'Pagar a Proveedor: $name';
  }

  @override
  String payableInvoiceLabel(String number) {
    return 'Factura: $number';
  }

  @override
  String remainingDebtLabel(String amount) {
    return 'Deuda Restante: ';
  }

  @override
  String collectPaymentCustomer(String customer) {
    return 'Cobrar a Cliente (ROC): $customer';
  }

  @override
  String outstandingBalanceAmount(String amount) {
    return 'Saldo Pendiente: \$$amount';
  }

  @override
  String authorizeActionTitle(String action) {
    return 'Autorizar: $action';
  }

  @override
  String supplierDueAmount(String amount) {
    return 'Saldo: \$$amount';
  }

  @override
  String branchCountLabel(int count) {
    return '$count Sucursal(es)';
  }

  @override
  String editStaffNamed(String name) {
    return 'Editar Personal: $name';
  }

  @override
  String superAdminStatus(String status) {
    return 'Super Admin: $status';
  }

  @override
  String taxAmountLabel(int percent) {
    return 'IVA ($percent%):';
  }

  @override
  String taxReceiptLabel(int percent) {
    return 'IVA ($percent%):';
  }

  @override
  String invoiceReceiptNumber(String number) {
    return 'FAC: $number';
  }

  @override
  String get allEvents => 'Todos los Eventos';

  @override
  String get unknown => 'Desconocido';

  @override
  String get finishPrintZCut => 'Finalizar e Imprimir Corte Z';

  @override
  String get submitBlindCount => 'Confirmar Conteo a Ciegas';

  @override
  String get blindDropSecurityRule =>
      'Regla de Seguridad: Ingrese el total del efectivo físico contado en la gaveta. Los totales esperados permanecen ocultos hasta que se confirme el conteo.';

  @override
  String get physicalCountedLabel => 'Efectivo Físico Contado:';

  @override
  String get varianceDiscrepancyLabel => 'Diferencia / Discrepancia:';

  @override
  String get shiftOpen => 'Turno Abierto';

  @override
  String get openingFloatBase => 'Fondo Inicial (Base):';

  @override
  String get cashSalesLabel => 'Ventas en Efectivo:';

  @override
  String get cardSalesLabel => 'Ventas con Tarjeta / POS:';

  @override
  String get cashInjectionsLabel => 'Ingresos de Efectivo:';

  @override
  String get withdrawalsLabel => 'Retiros (Sangrías):';

  @override
  String get calculatedCashInTill => 'Efectivo Calculado en Caja:';

  @override
  String get cashMovementButton => 'Movimiento de Caja (+ / -)';

  @override
  String get closeShiftBlindDropButton => 'Cerrar Turno (Corte Z / Arqueo)';

  @override
  String get noActiveShiftPrompt =>
      'No hay turno de caja abierto actualmente en esta estación.';

  @override
  String get openShiftInitialFloat => 'Abrir Turno con Fondo Inicial';

  @override
  String get closedShiftHistoryTitle => 'Historial de Turnos Cerrados';

  @override
  String get tableHeaderRegister => 'Caja';

  @override
  String get tableHeaderExpected => 'Esperado';

  @override
  String get tableHeaderCounted => 'Contado';

  @override
  String get tableHeaderVariance => 'Diferencia';

  @override
  String get counterDefault => 'Barra';

  @override
  String tableRatePerHour(String rate, String type) {
    return 'Tarifa: /hr ($type)';
  }

  @override
  String tablePlayerLabel(String name) {
    return 'Jugador: $name';
  }

  @override
  String tableAccruedAmount(String amount) {
    return 'Acumulado: ';
  }

  @override
  String get startSessionAction => 'Iniciar Sesión';

  @override
  String get selectOperatingBusinessUnit => 'Seleccione Sucursal Operativa';

  @override
  String get addBranch => 'Crear Sucursal';

  @override
  String get registerCustomer => 'Registrar Cliente';

  @override
  String get saveCustomer => 'Guardar Cliente';

  @override
  String get collect => 'Cobrar';

  @override
  String get view => 'Ver';

  @override
  String get registerSupplier => 'Registrar Proveedor';

  @override
  String get saveSupplier => 'Guardar Proveedor';

  @override
  String get issueOrder => 'Emitir Orden';

  @override
  String get block => 'Bloquear';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get kpiSynced => 'Sincronizado';

  @override
  String get kpiMonthly => 'Mensual';

  @override
  String get kpiPending => 'Pendientes';

  @override
  String get kpiCatalog => 'Catálogo';

  @override
  String get tableHeaderUnitsSold => 'Unidades Vendidas';

  @override
  String get revenueByCategory => 'Ingresos por Categoría';

  @override
  String get revenueByTender => 'Ingresos por Método de Pago';

  @override
  String get topSellingProductsAndServices =>
      'Top 10 Productos y Servicios Más Vendidos';

  @override
  String get dismiss => 'Descartar';

  @override
  String get overview => 'Resumen';

  @override
  String get metrics => 'Métricas';

  @override
  String get erpSuite => 'Suite ERP';

  @override
  String get systemInfo => 'Info del Sistema';

  @override
  String get filterLogsOrTelemetry => 'Filtrar registros o telemetría...';

  @override
  String get increment => 'Incrementar';

  @override
  String get reset => 'Restablecer';

  @override
  String get processedTasks => 'Tareas Procesadas:';

  @override
  String get serviceCore => 'Núcleo';

  @override
  String get targetDarwinWin32 => 'Darwin/Win32';

  @override
  String get serviceWeb => 'Web';

  @override
  String get targetWasmMobile => 'WASM/Móvil';

  @override
  String get statusReady => 'Listo';

  @override
  String internalTransferTitle(String productName) {
    return 'Transferencia Interna: $productName';
  }

  @override
  String get confirmTransferGuide => 'Confirmar Guía de Transferencia';

  @override
  String stockAdjustmentTitle(String productName) {
    return 'Ajuste de Stock de Inventario: $productName';
  }

  @override
  String get newTotalQuantity => 'Nueva Cantidad Total';

  @override
  String get saveAdjustment => 'Guardar Ajuste';

  @override
  String get warehouses => 'Bodegas';

  @override
  String get stockLevels => 'Niveles de Existencias';

  @override
  String get kardexLedger => 'Libro Kardex';

  @override
  String stockLevelsWarehouse(String warehouse) {
    return 'Niveles de Stock: $warehouse';
  }

  @override
  String get kardexLedgerHeader =>
      'Libro Mayor de Movimientos Kardex Permanente (Entradas, Salidas, Transferencias y Auditorías)';

  @override
  String get tableHeaderProduct => 'Producto';

  @override
  String get tableHeaderUnitCost => 'Costo Unitario';

  @override
  String get tableHeaderSku => 'SKU';

  @override
  String get tableHeaderProductItem => 'Artículo de Producto';

  @override
  String get tableHeaderMinStock => 'Stock Mínimo';

  @override
  String get tableHeaderCost => 'Costo';

  @override
  String get tableHeaderSalePrice => 'Precio Venta';

  @override
  String get tableHeaderTotalAmount => 'Monto Total';

  @override
  String get tableHeaderDueDate => 'Fecha de Vencimiento';

  @override
  String get tableHeaderTotalDebt => 'Deuda Total';

  @override
  String get tableHeaderProductName => 'Descripción Producto';

  @override
  String get tableHeaderRucTaxId => 'RUC / Identificación Fiscal';

  @override
  String get tableHeaderPhone => 'Teléfono';

  @override
  String invoiceTitle(String invoiceNumber) {
    return 'Factura $invoiceNumber';
  }

  @override
  String customerLabel(String customer) {
    return 'Cliente: $customer';
  }

  @override
  String cashierLabel(String cashier) {
    return 'Cajero: $cashier';
  }

  @override
  String get startPreparation => 'Iniciar Preparación';

  @override
  String get readyToServe => 'Listo para Servir';

  @override
  String get served => 'Servido';

  @override
  String get openAccountsAndTabs => 'Cuentas y Comandas Abiertas';

  @override
  String get openNewTabTitle => 'Abrir Nueva Comanda de Barra / Mesa';

  @override
  String get openTabAction => 'Abrir Comanda';

  @override
  String get fastCatalogPrompt =>
      'Toque un artículo para agregarlo a la comanda actual:';

  @override
  String get activeTabOrder => 'Orden de Comanda Activa';

  @override
  String get timerAction => 'Cronómetro';

  @override
  String get preBillPrint => 'Imprimir Pre-Cuenta';

  @override
  String get proceedToCheckout => 'Proceder al Cobro';

  @override
  String paySupplierTitle(String supplier) {
    return 'Pagar a Proveedor: $supplier';
  }

  @override
  String invoiceLabel(String invoiceNumber) {
    return 'Factura: $invoiceNumber';
  }

  @override
  String get paid => 'Pagado';

  @override
  String get receive => 'Recibir';

  @override
  String get delivered => 'Entregado';

  @override
  String get outstandingBalanceLabel => 'Saldo Pendiente: ';

  @override
  String get reportsAndBi => 'Reportes y BI';

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get reportExportedSuccessfully => 'Reporte Exportado Exitosamente';

  @override
  String get done => 'Hecho';

  @override
  String get settingsAndRbac => 'Ajustes y RBAC';

  @override
  String get appearance => 'Apariencia';

  @override
  String get corporateAndFiscal => 'Corporativo y Fiscal';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get systemLanguage => 'Idioma del Sistema';

  @override
  String get corporateAndTaxConfig => 'Configuración Corporativa y Fiscal';

  @override
  String get legalName => 'Razón Social:';

  @override
  String get commercialBrand => 'Nombre Comercial:';

  @override
  String get taxIdRucLabel => 'Identificación Fiscal / RUC:';

  @override
  String get salesTaxRatePercent => 'Tasa de Impuesto IVA (%):';

  @override
  String get defaultOperatingCurrency => 'Moneda Principal de Operación:';

  @override
  String get rbacSecurityMatrix => 'Matriz de Permisos y Seguridad RBAC';

  @override
  String authorizeActionNamed(String action) {
    return 'Autorizar: $action';
  }

  @override
  String get authorizeAction => 'Autorizar Acción';

  @override
  String get invalidSupervisorPin =>
      'PIN de autorización de supervisor no válido.';

  @override
  String get companyNamePrompt => 'Razón social...';

  @override
  String get usersAndStaff => 'Personal y Roles';

  @override
  String get inviteEmployee => 'Registrar Colaborador';

  @override
  String get inviteNewEmployee => 'Registrar Colaborador';

  @override
  String get fullNamePrompt => 'Nombre completo...';

  @override
  String get superAdminYes => 'Super Admin: SÍ';

  @override
  String get superAdminNo => 'Super Admin: NO';

  @override
  String editStaffTitle(String name) {
    return 'Editar Personal: $name';
  }

  @override
  String get roles => 'Roles';

  @override
  String get productCatalog => 'Catálogo de Productos';

  @override
  String get newProduct => 'Nuevo Producto';

  @override
  String get productNamePrompt => 'Nombre del producto...';

  @override
  String get quickProductCatalog => 'Catálogo Rápido de Productos';

  @override
  String get noProductsAvailablePrompt =>
      'No hay productos disponibles. Cree productos en el catálogo o siembre la base de datos.';

  @override
  String get selectOrRegisterCustomer => 'Seleccionar o Registrar Cliente';

  @override
  String get limit => 'Límite';

  @override
  String get balance => 'Saldo';

  @override
  String get saleSummaryAndItems => 'Resumen de Venta e Ítems';

  @override
  String get cartIsEmptyPrompt =>
      'El carrito está vacío. Agregue productos del catálogo.';

  @override
  String get itemHeader => 'Artículo';

  @override
  String get qtyHeader => 'Cant.';

  @override
  String get clear => 'Limpiar';

  @override
  String get finalizeSale => 'Confirmar y Facturar';

  @override
  String get walkInCustomer => 'Consumidor Final (Walk-in)';

  @override
  String get creditAvail => 'Crédito Disp.';

  @override
  String get changeAction => 'Cambiar';

  @override
  String get salesReceipt => 'Comprobante de Venta';

  @override
  String get thankYouForBusiness => '*** GRACIAS POR SU PREFERENCIA ***';

  @override
  String get printAction => 'Imprimir';

  @override
  String get newSaleAction => 'Nueva Venta';

  @override
  String get tax15Percent => 'IVA / Impuesto (15%):';

  @override
  String get onboardingWizardTitle => 'Asistente de Configuración Logisto';

  @override
  String stepCounter(int step) {
    return 'Paso $step de 4';
  }

  @override
  String get previousStep => 'Atrás';

  @override
  String get launchSystem => 'Completar e Iniciar';

  @override
  String get nextStep => 'Siguiente';

  @override
  String get step1Desc =>
      'Logisto aísla los maestros corporativos (Clientes, Proveedores, Usuarios) a nivel de Organización, mientras que las transacciones operativas (POS, Cocina KDS, Almacenes, Mesas de Billar) se ejecutan dentro de cada Sucursal.';

  @override
  String get step1Placeholder =>
      'Razón Social Corporativa (ej. Inversiones Castillo S.A.)';

  @override
  String get step2Placeholder =>
      'Nombre de Sucursal (ej. Sucursal Central o Farmacia Matriz)';

  @override
  String get step2Segment => 'Giro de Negocio Principal:';

  @override
  String get step3Placeholder => 'Tarifa por hora (ej. 10.00)';

  @override
  String get adjust => 'Ajustar';

  @override
  String get itemsBilled => 'Artículos Facturados:';

  @override
  String get totalPaid => 'Total Pagado:';

  @override
  String get confirmVoid => 'Confirmar Anulación';

  @override
  String get searchInvoiceOrCustomer => 'Buscar factura # o cliente...';

  @override
  String get voidAction => 'Anular';

  @override
  String get voidInvoiceDesc =>
      'Se requiere confirmación de supervisor. La anulación revertirá métricas de ventas y registrará una auditoría.';

  @override
  String get allFilter => 'Todos';

  @override
  String get pendingFilter => 'Pendientes';

  @override
  String get inPrepFilter => 'En Prep';

  @override
  String get readyFilter => 'Listos';

  @override
  String get noOrdersInQueue => 'No hay órdenes en esta cola de estado.';

  @override
  String get customerTableAliasPlaceholder =>
      'Alias de Cliente / Mesa (ej. Barra Carlos)';

  @override
  String get accountTotal => 'Total de la Cuenta:';

  @override
  String get paymentAmountDollar => 'Monto de Pago (\$)';

  @override
  String get estimatedTotalOrderValue => 'Valor Total Estimado de Orden (\$)';

  @override
  String get createPurchaseOrderAction => 'Crear Orden de Compra';

  @override
  String get exchangeRateLabel => 'Tipo de Cambio (USD -> NIO):';

  @override
  String get supervisorPermissionPrompt =>
      'Esta acción requiere permisos de supervisor. Ingrese el PIN de 4 dígitos:';

  @override
  String get orderCompleted => 'Orden completada.';

  @override
  String get orderCancelled => 'Orden cancelada.';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get newTab => 'Nueva Comanda';

  @override
  String get noTabSelectedPrompt =>
      'Ninguna comanda seleccionada. Seleccione o cree una cuenta abierta.';

  @override
  String get noSupplierLiabilitiesRecorded =>
      'No hay pasivos de proveedores registrados.';

  @override
  String get settled => 'LIQUIDADO';

  @override
  String get noPurchaseOrdersRecorded =>
      'No hay órdenes de compra registradas.';

  @override
  String get statusReceived => 'RECIBIDO';

  @override
  String get statusPending => 'PENDIENTE';

  @override
  String get salesReport8020 => 'Ventas 80/20';

  @override
  String get cashShifts => 'Turnos de Caja';

  @override
  String get creditAging => 'Crédito y Cartera';

  @override
  String csvReportGenerated(String count) {
    return 'Reporte en formato CSV generado ($count filas):';
  }

  @override
  String get reportSalesPareto => 'Ventas y Contribución Pareto (80/20)';

  @override
  String get reportInventoryValuation =>
      'Valoración de Inventario y Punto de Reorden';

  @override
  String get reportBilliardsUtilization =>
      'Utilización de Estaciones de Billar y Renta por Hora';

  @override
  String get reportCashDrawerCuts => 'Cortes de Caja (Auditoría Reporte Z)';

  @override
  String get reportReceivablesAging => 'Cuentas por Cobrar y Antigüedad (CxC)';

  @override
  String get noneRequiresSupervisorPin =>
      'Ninguno (Requiere PIN de Supervisor)';

  @override
  String get companyLegalName => 'Razón Social de la Empresa';

  @override
  String get contactRepresentative => 'Representante de Contacto';

  @override
  String get creditDaysExample => 'Días de Crédito (ej. 15, 30)';

  @override
  String get searchSupplierPlaceholder =>
      'Buscar por nombre de proveedor o RUC...';

  @override
  String get rucTaxIdPlaceholder => 'RUC / Identificación Fiscal';

  @override
  String daysCount(int count) {
    return '$count Días';
  }

  @override
  String get superAdminShort => 'SuperAdmin';

  @override
  String get noProductsRegistered =>
      'No hay productos registrados en esta organización.';

  @override
  String get saveProduct => 'Guardar Producto';

  @override
  String get select => 'Seleccionar';

  @override
  String get add => 'Agregar';

  @override
  String get error => 'Error';

  @override
  String get creditLimitLabel => 'Límite';

  @override
  String get debtLabel => 'Saldo';

  @override
  String get tableHeaderPrice => 'Precio';

  @override
  String get totalAmountLabel => 'Total a Pagar:';

  @override
  String get subtotalLabel => 'Subtotal:';

  @override
  String get customer => 'Cliente';

  @override
  String get cashTendered => 'Efectivo Entregado';

  @override
  String get cardPayment => 'Tarjeta (POS Débito/Crédito)';

  @override
  String get customerCredit => 'Crédito Directo a Cliente';

  @override
  String get addedToCustomerDebt => 'Trasladado a Deuda Crédito:';

  @override
  String get creditAvailablePrefix => 'Crédito Disp.';

  @override
  String get step3Alert =>
      'Auto-configuración de \"Almacén Central\" y \"Gaveta Caja 01\".';

  @override
  String get productionSeedsEnabled => 'Semillas de Producción: ACTIVADAS';

  @override
  String get productionSeedsDisabled => 'Semillas de Producción: DESACTIVADAS';

  @override
  String unitsCount(int count) {
    return '$count unidades';
  }

  @override
  String inStockCount(int count) {
    return '$count en stock';
  }

  @override
  String minStockCount(int count) {
    return 'Mín: $count';
  }

  @override
  String get stockStatusLow => 'BAJO STOCK';

  @override
  String get stockStatusOptimal => 'ÓPTIMO';

  @override
  String get defaultCustomerFirstName => 'Nuevo';

  @override
  String get defaultCustomerLastName => 'Cliente';

  @override
  String get defaultSupplierName => 'Nuevo Proveedor';

  @override
  String get defaultContactName => 'Contacto';

  @override
  String get defaultProductName => 'Nuevo Producto';

  @override
  String get auditPhysicalCountReason => 'Auditoría de conteo físico';

  @override
  String get mainWarehouse => 'Principal';

  @override
  String kdsMinutesPending(int minutes) {
    return '$minutes min (Pendiente)';
  }

  @override
  String kdsMinutesCooking(int minutes) {
    return '$minutes min (Cocinando)';
  }

  @override
  String kdsNote(String note) {
    return 'Nota: $note';
  }

  @override
  String priceEach(String price) {
    return '\$$price c/u';
  }

  @override
  String totalLiabilitiesAmount(String amount) {
    return 'Total Pasivos: \$$amount';
  }

  @override
  String get authErrorEmailPasswordRequired =>
      'El correo electrónico y la contraseña son requeridos.';

  @override
  String get authErrorPinFourDigits =>
      'El PIN debe tener exactamente 4 dígitos.';

  @override
  String get businessTypeBilliard => 'Billar y Entretenimiento';

  @override
  String get businessTypeRetail => 'Comercio Minorista';

  @override
  String get businessTypePharmacy => 'Farmacia y Salud';

  @override
  String get businessTypeRestaurant => 'Restaurante y Bar';

  @override
  String get businessTypeGeneral => 'Comercial General';

  @override
  String get productTypeStandard => 'Estándar';

  @override
  String get productTypeCombo => 'Combo';

  @override
  String get productTypeService => 'Servicio';

  @override
  String get productTypeRawMaterial => 'Materia Prima';

  @override
  String get productTypePack => 'Paquete / Combo';

  @override
  String get productTypeRecipeBom => 'Receta / Insumos';

  @override
  String get roleSuperAdmin => 'Super Administrador';

  @override
  String get roleAdminBusinessUnit => 'Gerente de Sucursal';

  @override
  String get roleSupervisor => 'Supervisor de Turno';

  @override
  String get roleCashier => 'Cajero';

  @override
  String get roleWaiter => 'Mesero / Salonero';

  @override
  String get roleInventoryManager => 'Encargado de Inventario';

  @override
  String get roleKitchen => 'Cocina / KDS';

  @override
  String get auditActionVoidItem => 'anular ítem';

  @override
  String get auditActionVoidInvoice => 'anular factura';

  @override
  String get auditActionApplyDiscount => 'aplicar descuento';

  @override
  String get auditActionOpenDrawer => 'abrir gaveta';

  @override
  String get auditActionTransferTable => 'transferir mesa';

  @override
  String get auditActionSplitBill => 'dividir cuenta';

  @override
  String get auditActionBlindDrop => 'arqueo ciego';

  @override
  String get auditActionReorderPoint => 'punto de reorden';

  @override
  String get auditActionForceSync => 'forzar sincronización';

  @override
  String get auditActionRateChange => 'cambio de tarifa';

  @override
  String get auditActionCreditOverride => 'sobregiro de crédito';

  @override
  String get auditActionStockAdjustment => 'ajuste de inventario';

  @override
  String get auditActionCloseShift => 'cierre de turno';

  @override
  String get movementPurchaseReceipt => 'Recepción de Compra';

  @override
  String get movementSalesDeduction => 'Deducción por Venta';

  @override
  String get movementInternalTransfer => 'Transferencia Interna';

  @override
  String get movementWasteAdjustment => 'Ajuste por Merma';

  @override
  String get movementInitialCount => 'Conteo Inicial';

  @override
  String get paymentMethodCash => 'Efectivo';

  @override
  String get paymentMethodCard => 'Tarjeta';

  @override
  String get paymentMethodCustomerCredit => 'Crédito Cliente';

  @override
  String get paymentMethodBankTransfer => 'Transferencia Bancaria';

  @override
  String get paymentMethodMixed => 'Mixto / Dividido';

  @override
  String get discrepancyBalanced => 'Cuadrado';

  @override
  String get discrepancyShortage => 'Faltante';

  @override
  String get discrepancySurplus => 'Sobrante';

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
    return 'Bajo Stock: $count Unidades';
  }

  @override
  String reportTagInStock(int count) {
    return '$count En Stock';
  }

  @override
  String reportTagShortage(String amount) {
    return 'Faltante -\$$amount';
  }

  @override
  String get reportTagBalanced => 'Cuadrado \$0.00';

  @override
  String get reportTagActiveCredit => 'Crédito Activo';

  @override
  String get reportTagBlockedOverdue => 'BLOQUEADO (Mora >30d)';

  @override
  String reportTagOccupancy(int percent) {
    return 'Ocupación: $percent%';
  }

  @override
  String get reportTagTopPareto => 'Top 80%';

  @override
  String reportMetricCostVal(String amount) {
    return 'Val. Costo: \$$amount';
  }

  @override
  String reportMetricSaleVal(String amount) {
    return 'Val. Venta: \$$amount';
  }

  @override
  String reportMetricExpected(String amount) {
    return 'Esperado: \$$amount';
  }

  @override
  String reportMetricCounted(String amount) {
    return 'Contado: \$$amount';
  }

  @override
  String reportMetricCurrentDebt(String amount) {
    return 'Deuda Actual: \$$amount';
  }

  @override
  String reportMetricDaysOverdue(int days) {
    return 'Días en Mora: $days';
  }

  @override
  String reportMetricTimeSales(String amount) {
    return 'Venta Tiempo: \$$amount';
  }

  @override
  String reportMetricBarConsumed(String amount) {
    return 'Consumo Barra: \$$amount';
  }

  @override
  String reportMetricRevenue(String amount) {
    return 'Ingresos: \$$amount';
  }

  @override
  String reportMetricMargin(String percent) {
    return 'Margen: $percent%';
  }

  @override
  String reportSubShiftHours(String opened, String closed) {
    return 'Apertura $opened • Cierre $closed';
  }

  @override
  String reportSubTableRateHours(String rate, String hours) {
    return 'Tarifa: \$$rate/h • $hours Horas Activa';
  }

  @override
  String reportSubParetoRankUnits(int rank, int units) {
    return 'Rango Pareto #$rank • $units Unidades Vendidas';
  }

  @override
  String reportSubSkuMin(String sku, int min) {
    return 'SKU: $sku • Mín: $min unidades';
  }

  @override
  String reportSubRucLimit(String ruc, String limit) {
    return 'RUC: $ruc • Límite: \$$limit';
  }

  @override
  String reportShiftCashier(String number, String name) {
    return 'Turno #$number • Cajero: $name';
  }

  @override
  String get categoryBeverages => 'Bebidas';

  @override
  String get categoryCocktails => 'Cocteles';

  @override
  String get categoryFood => 'Comida';

  @override
  String get forgotPasswordPrompt => 'Restablecer Contraseña';

  @override
  String get forgotPasswordDesc =>
      'Ingrese su correo corporativo para recibir las instrucciones de recuperación.';

  @override
  String get resetPasswordEmailSent =>
      'Instrucciones para restablecer contraseña enviadas a su correo.';

  @override
  String get send => 'Enviar';

  @override
  String get authSubtitleHint => 'Acceso multiempresa a operaciones y POS';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get rememberMe => 'Recordar sesión';

  @override
  String get forgotPassword => '¿Olvidó su contraseña?';

  @override
  String get demoProfilesPrompt => 'Perfiles demo de acceso rápido:';

  @override
  String get signUp => 'Crear Cuenta';

  @override
  String get signUpSubtitle =>
      'Registre una nueva cuenta de usuario empresarial';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get fullNamePlaceholder => 'Carlos Machado';

  @override
  String get alreadyHaveAccount => '¿Ya tiene una cuenta? Iniciar Sesión';

  @override
  String get dontHaveAccount => '¿No tiene una cuenta? Registrarse';

  @override
  String get accountCreatedSuccess => 'Cuenta creada exitosamente.';

  @override
  String get verifyEmailTitle => 'Verifique su Correo Electrónico';

  @override
  String verifyEmailPrompt(String email) {
    return 'Hemos enviado un correo de verificación a $email. Por favor verifique su correo para acceder a todas las funciones empresariales.';
  }

  @override
  String get resendVerificationEmail => 'Reenviar Correo de Verificación';

  @override
  String get verificationEmailSent =>
      'Correo de verificación reenviado. Por favor revise su bandeja de entrada.';

  @override
  String get iHaveVerified => 'Ya verifiqué mi correo';

  @override
  String get emailNotVerifiedYet =>
      'El correo aún no ha sido verificado. Revise su bandeja o solicite reenvío.';

  @override
  String get printerManagementTitle => 'Administración de Impresoras';

  @override
  String get printerManagementSubtitle =>
      'Configuración y conexión de impresoras térmicas, USB y Bluetooth';

  @override
  String get printersSectionTitle => 'Impresoras y Tickets';

  @override
  String get printersSectionSubtitle =>
      'Configurar tickets térmicos, matriciales, USB y Bluetooth';

  @override
  String get activePrinter => 'Impresora Conectada / Activa';

  @override
  String get noActivePrinter =>
      'No hay ninguna impresora vinculada actualmente.';

  @override
  String get scanBluetoothPrinters => 'Buscar Impresoras Bluetooth / USB';

  @override
  String get scanningPrinters => 'Buscando dispositivos cercanos...';

  @override
  String get discoveredPrinters => 'Dispositivos Disponibles';

  @override
  String get noDiscoveredPrinters =>
      'No se encontraron impresoras disponibles.';

  @override
  String get connectPrinter => 'Conectar';

  @override
  String get disconnectPrinter => 'Desvincular';

  @override
  String get editPrinterAlias => 'Editar Nombre / Alias';

  @override
  String get printerAliasLabel => 'Nombre amigable (Alias)';

  @override
  String get printerAliasPlaceholder => 'Ej. Caja Principal - Mostrador';

  @override
  String get printerTypeLabel => 'Formato de Papel / Tecnología';

  @override
  String get printerTypeThermal80 => 'Térmica 80 mm (Estándar POS)';

  @override
  String get printerTypeThermal58 => 'Térmica 58 mm (Portátil)';

  @override
  String get printerTypeDotMatrix => 'Matricial (Papel Continuo)';

  @override
  String get macAddressLabel => 'Dirección MAC / Identificador';

  @override
  String get connectionTypeLabel => 'Tipo de Conexión';

  @override
  String get autoPrintOnSaleLabel => 'Impresión automática al cobrar';

  @override
  String get autoPrintOnSaleSubtitle =>
      'Enviar el comprobante directamente a la impresora al completar una venta';

  @override
  String get printTestTicket => 'Imprimir Prueba';

  @override
  String get testTicketSent => 'Ticket de prueba enviado con éxito.';

  @override
  String get reprintVoucher => 'Reimprimir Voucher';

  @override
  String get shareVoucher => 'Compartir PDF';

  @override
  String get previewVoucher => 'Vista Previa';
}

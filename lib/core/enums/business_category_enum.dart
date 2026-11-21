import 'business_type_enum.dart';

/// Strongly-typed business category discriminator covering 62 standardized business verticals.
enum BusinessCategoryEnum {
  /// Billar
  billar(displayName: 'Billar', storageKey: 'billar'),

  /// Agricultura y ganadería
  agriculturaYGanaderia(
    displayName: 'Agricultura y ganadería',
    storageKey: 'agricultura_y_ganaderia',
  ),

  /// Venta por catálogo
  ventaPorCatalogo(
    displayName: 'Venta por catálogo',
    storageKey: 'venta_por_catalogo',
  ),

  /// Juguetería
  jugueteria(displayName: 'Juguetería', storageKey: 'jugueteria'),

  /// Ropa y calzado
  ropaYCalzado(displayName: 'Ropa y calzado', storageKey: 'ropa_y_calzado'),

  /// Restaurante o comida rápida
  restauranteOComidaRapida(
    displayName: 'Restaurante o comida rápida',
    storageKey: 'restaurante_o_comida_rapida',
  ),

  /// Artículos de belleza
  articulosDeBelleza(
    displayName: 'Artículos de belleza',
    storageKey: 'articulos_de_belleza',
  ),

  /// Pulpería
  pulperia(displayName: 'Pulpería', storageKey: 'pulperia'),

  /// Minimercado
  minimercado(displayName: 'Minimercado', storageKey: 'minimercado'),

  /// Electrónica e informática
  electronicaEInformatica(
    displayName: 'Electrónica e informática',
    storageKey: 'electronica_e_informatica',
  ),

  /// Industria o manufactura
  industriaOManufactura(
    displayName: 'Industria o manufactura',
    storageKey: 'industria_o_manufactura',
  ),

  /// Servicios profesionales
  serviciosProfesionales(
    displayName: 'Servicios profesionales',
    storageKey: 'servicios_profesionales',
  ),

  /// Farmacia y droguería
  farmaciaYDrogueria(
    displayName: 'Farmacia y droguería',
    storageKey: 'farmacia_y_drogueria',
  ),

  /// Veterinaria
  veterinaria(displayName: 'Veterinaria', storageKey: 'veterinaria'),

  /// Tienda de mascotas
  tiendaDeMascotas(
    displayName: 'Tienda de mascotas',
    storageKey: 'tienda_de_mascotas',
  ),

  /// Peluquería de mascotas
  peluqueriaDeMascotas(
    displayName: 'Peluquería de mascotas',
    storageKey: 'peluqueria_de_mascotas',
  ),

  /// Ferretería y construcción
  ferreteriaYConstruccion(
    displayName: 'Ferretería y construcción',
    storageKey: 'ferreteria_y_construccion',
  ),

  /// Papelería y libros
  papeleriaYLibros(
    displayName: 'Papelería y libros',
    storageKey: 'papeleria_y_libros',
  ),

  /// Licorería
  licoreria(displayName: 'Licorería', storageKey: 'licoreria'),

  /// Hoteles y turismo
  hotelesYTurismo(
    displayName: 'Hoteles y turismo',
    storageKey: 'hoteles_y_turismo',
  ),

  /// Cafetería
  cafeteria(displayName: 'Cafetería', storageKey: 'cafeteria'),

  /// Bar
  bar(displayName: 'Bar', storageKey: 'bar'),

  /// Transporte y logística
  transporteYLogistica(
    displayName: 'Transporte y logística',
    storageKey: 'transporte_y_logistica',
  ),

  /// Artículos para el hogar
  articulosParaElHogar(
    displayName: 'Artículos para el hogar',
    storageKey: 'articulos_para_el_hogar',
  ),

  /// Panadería y Repostería
  panaderiaYReposteria(
    displayName: 'Panadería y Repostería',
    storageKey: 'panaderia_y_reposteria',
  ),

  /// Taller automotriz
  tallerAutomotriz(
    displayName: 'Taller automotriz',
    storageKey: 'taller_automotriz',
  ),

  /// Artículos deportivos
  articulosDeportivos(
    displayName: 'Artículos deportivos',
    storageKey: 'articulos_deportivos',
  ),

  /// Diseño, impresión y personalizados
  disenoImpresionYPersonalizados(
    displayName: 'Diseño, impresión y personalizados',
    storageKey: 'diseno_impresion_y_personalizados',
  ),

  /// Gimnasio
  gimnasio(displayName: 'Gimnasio', storageKey: 'gimnasio'),

  /// Tatuajes y piercings
  tatuajesYPiercings(
    displayName: 'Tatuajes y piercings',
    storageKey: 'tatuajes_y_piercings',
  ),

  /// Reparaciones y mantenimiento
  reparacionesYMantenimiento(
    displayName: 'Reparaciones y mantenimiento',
    storageKey: 'reparaciones_y_mantenimiento',
  ),

  /// Servicios educativos
  serviciosEducativos(
    displayName: 'Servicios educativos',
    storageKey: 'servicios_educativos',
  ),

  /// Organización de eventos
  organizacionDeEventos(
    displayName: 'Organización de eventos',
    storageKey: 'organizacion_de_eventos',
  ),

  /// Estética y salud
  esteticaYSalud(displayName: 'Estética y salud', storageKey: 'estetica_y_salud'),

  /// Barbería y peluquería
  barberiaYPeluqueria(
    displayName: 'Barbería y peluquería',
    storageKey: 'barberia_y_peluqueria',
  ),

  /// Tienda naturista y/o suplementos
  tiendaNaturistaYOSuplementos(
    displayName: 'Tienda naturista y/o suplementos',
    storageKey: 'tienda_naturista_y_o_suplementos',
  ),

  /// Tiendas de regalos
  tiendasDeRegalos(
    displayName: 'Tiendas de regalos',
    storageKey: 'tiendas_de_regalos',
  ),

  /// Accesorios y bisutería
  accesoriosYBisuteria(
    displayName: 'Accesorios y bisutería',
    storageKey: 'accesorios_y_bisuteria',
  ),

  /// Distribuidora / Mayorista
  distribuidoraMayorista(
    displayName: 'Distribuidora / Mayorista',
    storageKey: 'distribuidora_mayorista',
  ),

  /// Charcutería
  charcuteria(displayName: 'Charcutería', storageKey: 'charcuteria'),

  /// Carnicería
  carniceria(displayName: 'Carnicería', storageKey: 'carniceria'),

  /// Artículos automotrices
  articulosAutomotrices(
    displayName: 'Artículos automotrices',
    storageKey: 'articulos_automotrices',
  ),

  /// Préstamos y financiamiento
  prestamosYFinanciamiento(
    displayName: 'Préstamos y financiamiento',
    storageKey: 'prestamos_y_financiamiento',
  ),

  /// Entretenimiento y ocio
  entretenimientoYOcio(
    displayName: 'Entretenimiento y ocio',
    storageKey: 'entretenimiento_y_ocio',
  ),

  /// Insumos agropecuarios
  insumosAgropecuarios(
    displayName: 'Insumos agropecuarios',
    storageKey: 'insumos_agropecuarios',
  ),

  /// Venta de automóviles
  ventaDeAutomoviles(
    displayName: 'Venta de automóviles',
    storageKey: 'venta_de_automoviles',
  ),

  /// Productos de aseo y limpieza
  productosDeAseoYLimpieza(
    displayName: 'Productos de aseo y limpieza',
    storageKey: 'productos_de_aseo_y_limpieza',
  ),

  /// Vape, tabaquería y smoke shop
  vapeTabaqueriaYSmokeShop(
    displayName: 'Vape, tabaquería y smoke shop',
    storageKey: 'vape_tabaqueria_y_smoke_shop',
  ),

  /// Heladería, jugos y postres
  heladeriaJugosYPostres(
    displayName: 'Heladería, jugos y postres',
    storageKey: 'heladeria_jugos_y_postres',
  ),

  /// Variedades y bazares
  variedadesYBazares(
    displayName: 'Variedades y bazares',
    storageKey: 'variedades_y_bazares',
  ),

  /// Artesanías y manualidades
  artesaniasYManualidades(
    displayName: 'Artesanías y manualidades',
    storageKey: 'artesanias_y_manualidades',
  ),

  /// Uñas, pestañas y cejas
  unasPestanasYCejas(
    displayName: 'Uñas, pestañas y cejas',
    storageKey: 'unas_pestanas_y_cejas',
  ),

  /// Floristería y vivero
  floristeriaYVivero(
    displayName: 'Floristería y vivero',
    storageKey: 'floristeria_y_vivero',
  ),

  /// Agua, hielo y gas
  aguaHieloYGas(displayName: 'Agua, hielo y gas', storageKey: 'agua_hielo_y_gas'),

  /// Lavadero de autos y detailing
  lavaderoDeAutosYDetailing(
    displayName: 'Lavadero de autos y detailing',
    storageKey: 'lavadero_de_autos_y_detailing',
  ),

  /// Arriendos y administración de propiedades
  arriendosYAdministracionDePropiedades(
    displayName: 'Arriendos y administración de propiedades',
    storageKey: 'arriendos_y_administracion_de_propiedades',
  ),

  /// Artículos religiosos y esotéricos
  articulosReligiososYEsotericos(
    displayName: 'Artículos religiosos y esotéricos',
    storageKey: 'articulos_religiosos_y_esotericos',
  ),

  /// Lavandería y tintorería
  lavanderiaYTintoreria(
    displayName: 'Lavandería y tintorería',
    storageKey: 'lavanderia_y_tintoreria',
  ),

  /// Sex shop
  sexShop(displayName: 'Sex shop', storageKey: 'sex_shop'),

  /// Sastrería, modistería y arreglos
  sastreriaModisteriaYArreglos(
    displayName: 'Sastrería, modistería y arreglos',
    storageKey: 'sastreria_modisteria_y_arreglos',
  ),

  /// Recargas, giros y loterías
  recargasGirosYLoterias(
    displayName: 'Recargas, giros y loterías',
    storageKey: 'recargas_giros_y_loterias',
  ),

  /// Reciclaje y chatarra
  reciclajeYChatarra(
    displayName: 'Reciclaje y chatarra',
    storageKey: 'reciclaje_y_chatarra',
  );

  /// Exact display string for the category.
  final String displayName;

  /// String key stored in Firestore document fields.
  final String storageKey;

  const BusinessCategoryEnum({
    required this.displayName,
    required this.storageKey,
  });

  /// Resolves [BusinessCategoryEnum] safely from [storageKey] or [displayName].
  static BusinessCategoryEnum fromStorageKey(String? key) {
    if (key == null || key.isEmpty) return BusinessCategoryEnum.minimercado;
    return BusinessCategoryEnum.values.firstWhere(
      (e) =>
          e.storageKey == key ||
          e.displayName.toLowerCase() == key.toLowerCase(),
      orElse: () => BusinessCategoryEnum.minimercado,
    );
  }

  /// Resolves [BusinessCategoryEnum] safely from [displayName].
  static BusinessCategoryEnum fromDisplayName(String? name) {
    if (name == null || name.isEmpty) return BusinessCategoryEnum.minimercado;
    return BusinessCategoryEnum.values.firstWhere(
      (e) =>
          e.displayName.toLowerCase() == name.toLowerCase() ||
          e.storageKey == name,
      orElse: () => BusinessCategoryEnum.minimercado,
    );
  }

  /// Maps the vertical category to its default operational [BusinessTypeEnum].
  BusinessTypeEnum get defaultBusinessType {
    switch (this) {
      case BusinessCategoryEnum.billar:
        return BusinessTypeEnum.billiard;
      case BusinessCategoryEnum.restauranteOComidaRapida:
      case BusinessCategoryEnum.cafeteria:
      case BusinessCategoryEnum.bar:
      case BusinessCategoryEnum.heladeriaJugosYPostres:
        return BusinessTypeEnum.restaurant;
      case BusinessCategoryEnum.farmaciaYDrogueria:
        return BusinessTypeEnum.pharmacy;
      case BusinessCategoryEnum.serviciosProfesionales:
      case BusinessCategoryEnum.serviciosEducativos:
      case BusinessCategoryEnum.organizacionDeEventos:
      case BusinessCategoryEnum.transporteYLogistica:
      case BusinessCategoryEnum.prestamosYFinanciamiento:
      case BusinessCategoryEnum.arriendosYAdministracionDePropiedades:
      case BusinessCategoryEnum.recargasGirosYLoterias:
        return BusinessTypeEnum.general;
      default:
        return BusinessTypeEnum.retail;
    }
  }
}

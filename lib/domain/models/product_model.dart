import '../../core/enums/product_type_enum.dart';

/// Pure domain model for an ingredient line in a Bill of Materials (BOM) or pack recipe.
class RecipeItemModel {
  final String productId;
  final double quantity;

  const RecipeItemModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'productId': productId, 'quantity': quantity};
  }

  factory RecipeItemModel.fromMap(Map<String, dynamic> map) {
    return RecipeItemModel(
      productId: map['productId'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

/// Pure domain model representing an inventory master catalog item.
class ProductModel {
  final String id;
  final String orgId;
  final String sku;
  final String barcode;
  final String name;
  final String categoryId;
  final ProductTypeEnum productType;
  final double costPrice;
  final double salePrice;
  final double taxRate;
  final bool isActive;
  final List<RecipeItemModel> recipe;
  final String? batchNumber;
  final DateTime? expirationDate;

  const ProductModel({
    required this.id,
    required this.orgId,
    required this.sku,
    this.barcode = '',
    required this.name,
    required this.categoryId,
    required this.productType,
    required this.costPrice,
    required this.salePrice,
    this.taxRate = 0.15,
    this.isActive = true,
    this.recipe = const [],
    this.batchNumber,
    this.expirationDate,
  });

  ProductModel copyWith({
    String? id,
    String? orgId,
    String? sku,
    String? barcode,
    String? name,
    String? categoryId,
    ProductTypeEnum? productType,
    double? costPrice,
    double? salePrice,
    double? taxRate,
    bool? isActive,
    List<RecipeItemModel>? recipe,
    String? batchNumber,
    DateTime? expirationDate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      productType: productType ?? this.productType,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      taxRate: taxRate ?? this.taxRate,
      isActive: isActive ?? this.isActive,
      recipe: recipe ?? this.recipe,
      batchNumber: batchNumber ?? this.batchNumber,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'sku': sku,
      'barcode': barcode,
      'name': name,
      'categoryId': categoryId,
      'productType': productType.storageKey,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'taxRate': taxRate,
      'isActive': isActive,
      'recipe': recipe.map((e) => e.toMap()).toList(),
      'batchNumber': batchNumber,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawRecipe = map['recipe'] as List<dynamic>? ?? [];
    return ProductModel(
      id: docId ?? (map['id'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      sku: map['sku'] as String? ?? '',
      barcode: map['barcode'] as String? ?? '',
      name: map['name'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      productType: ProductTypeEnum.fromStorageKey(
        map['productType'] as String?,
      ),
      costPrice: (map['costPrice'] as num?)?.toDouble() ?? 0.0,
      salePrice: (map['salePrice'] as num?)?.toDouble() ?? 0.0,
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.15,
      isActive: map['isActive'] as bool? ?? true,
      recipe: rawRecipe
          .map(
            (e) => RecipeItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      batchNumber: map['batchNumber'] as String?,
      expirationDate: map['expirationDate'] != null
          ? DateTime.tryParse(map['expirationDate'].toString())
          : null,
    );
  }
}

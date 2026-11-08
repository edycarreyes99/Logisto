import 'generic_item_model.dart';

/// Abstract contract for item repository operations.
abstract class IGenericItemRepository {
  Stream<List<GenericItemModel>> watchAll();
  Future<List<GenericItemModel>> getAll();
  Future<GenericItemModel?> getById(String id);
  Future<String> save(GenericItemModel item);
  Future<void> delete(String id);
}

/// Domain service orchestrating business rules and operations for items.
class GenericItemService {
  /// The underlying repository dependency.
  final IGenericItemRepository repository;

  /// Creates a [GenericItemService] instance.
  GenericItemService({required this.repository});

  /// Subscribes to real-time stream of domain items.
  Stream<List<GenericItemModel>> watchItems() => repository.watchAll();

  /// Performs a one-shot query to load all items.
  Future<List<GenericItemModel>> loadItems() => repository.getAll();

  /// Retrieves an item by its unique document identifier.
  Future<GenericItemModel?> getItemById(String id) => repository.getById(id);

  /// Enforces business validation rules and saves an item via the repository.
  Future<String> saveItem(GenericItemModel item) async {
    if (item.title.trim().isEmpty) {
      throw ArgumentError('Item title cannot be empty.');
    }
    if (item.value < 0) {
      throw ArgumentError('Item value cannot be negative.');
    }
    return repository.save(item);
  }

  /// Validates and deletes an item by document identifier.
  Future<void> deleteItem(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('Item ID cannot be empty.');
    }
    await repository.delete(id);
  }
}

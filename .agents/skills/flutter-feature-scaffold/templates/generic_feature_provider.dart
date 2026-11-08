import 'dart:async';
import 'package:flutter/foundation.dart';
import 'generic_item_model.dart';
import 'generic_item_service.dart';

/// Strongly-typed state status enum for catalog views.
enum FeatureStatusEnum {
  idle,
  loading,
  loaded,
  success,
  error;

  bool get isLoading => this == FeatureStatusEnum.loading;
  bool get isLoaded => this == FeatureStatusEnum.loaded;
  bool get isError => this == FeatureStatusEnum.error;
}

/// Feature state provider orchestrating catalog streams and UI state.
class GenericFeatureProvider extends ChangeNotifier {
  final GenericItemService _service;

  GenericFeatureProvider({required GenericItemService service}) : _service = service;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  FeatureStatusEnum get status => _status;

  List<GenericItemModel> _items = [];
  List<GenericItemModel> get items => _items;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<GenericItemModel> get filteredItems {
    if (_searchQuery.trim().isEmpty) return _items;
    final query = _searchQuery.toLowerCase();
    return _items
        .where((item) =>
            item.title.toLowerCase().contains(query) ||
            item.code.toLowerCase().contains(query))
        .toList();
  }

  StreamSubscription<List<GenericItemModel>>? _itemsSubscription;

  /// Initializes the real-time listener for the item catalog.
  void initialize() {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    _itemsSubscription?.cancel();
    _itemsSubscription = _service.watchItems().listen(
      (updatedItems) {
        _items = updatedItems;
        _status = FeatureStatusEnum.loaded;
        if (hasListeners) notifyListeners();
      },
      onError: (_) {
        _status = FeatureStatusEnum.error;
        if (hasListeners) notifyListeners();
      },
    );
  }

  /// Updates the search filter query and triggers UI re-render.
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Deletes an item by document ID.
  Future<void> deleteItem(String id) async {
    try {
      await _service.deleteItem(id);
    } catch (_) {
      _status = FeatureStatusEnum.error;
      if (hasListeners) notifyListeners();
    }
  }

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    _itemsSubscription = null;
    super.dispose();
  }
}

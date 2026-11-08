import 'package:flutter/foundation.dart';
import 'generic_item_model.dart';
import 'generic_item_service.dart';

/// Strongly-typed state status enum for form submissions.
enum FormSubmissionStatusEnum {
  idle,
  submitting,
  success,
  error;

  bool get isSubmitting => this == FormSubmissionStatusEnum.submitting;
  bool get isSuccess => this == FormSubmissionStatusEnum.success;
  bool get isError => this == FormSubmissionStatusEnum.error;
}

/// Feature state provider orchestrating form inputs and optimistic mutations.
class GenericFormProvider extends ChangeNotifier {
  final GenericItemService _service;

  GenericFormProvider({required GenericItemService service}) : _service = service;

  ItemStatusEnum _selectedStatus = ItemStatusEnum.active;
  ItemStatusEnum get selectedStatus => _selectedStatus;

  FormSubmissionStatusEnum _status = FormSubmissionStatusEnum.idle;
  FormSubmissionStatusEnum get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setStatus(ItemStatusEnum newStatus) {
    _selectedStatus = newStatus;
    notifyListeners();
  }

  Future<bool> submitItem({
    required String id,
    required String title,
    required String code,
    required double value,
  }) async {
    try {
      _status = FormSubmissionStatusEnum.submitting;
      _errorMessage = null;
      notifyListeners();

      final model = GenericItemModel(
        id: id,
        title: title.trim(),
        code: code.trim(),
        value: value,
        status: _selectedStatus,
      );

      await _service.saveItem(model);

      _status = FormSubmissionStatusEnum.success;
      if (hasListeners) notifyListeners();
      return true;
    } catch (e) {
      _status = FormSubmissionStatusEnum.error;
      _errorMessage = e.toString();
      if (hasListeners) notifyListeners();
      return false;
    }
  }
}

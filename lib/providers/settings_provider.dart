import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _showQuantityCount = false;
  bool _showCartRemoveConfirm = true;

  bool get showQuantityCount => _showQuantityCount;
  bool get showCartRemoveConfirm => _showCartRemoveConfirm;

  set showQuantityCount(bool value) {
    _showQuantityCount = value;
    notifyListeners();
  }

  set showCartRemoveConfirm(bool value) {
    _showCartRemoveConfirm = value;
    notifyListeners();
  }
}

import 'package:fitivation_app/shared/store.service.dart';
import 'package:flutter/material.dart';

class PermissionProvider extends ChangeNotifier {
  bool _hasPermission = false;

  bool get hasPermission => _hasPermission;

  PermissionProvider() {
    _initializePermission();
  }

  Future<void> _initializePermission() async {
    bool? permission = await Store.getPermission();
    _hasPermission = permission == true;
    notifyListeners();
  }

  void togglePermission() {
    _hasPermission = !_hasPermission;
    Store.setPermission(_hasPermission);
    notifyListeners();
  }
}

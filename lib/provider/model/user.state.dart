import 'package:fitivation_app/models/user.model.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  User? _user; // Thông tin người dùng

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }
}

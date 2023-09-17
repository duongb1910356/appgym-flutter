import 'package:fitivation_app/models/user.model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user {
    return _user;
  }

  void login(Map<String, dynamic> currentUser) {
    _user = User.fromJson(currentUser);
    notifyListeners();
  }
}

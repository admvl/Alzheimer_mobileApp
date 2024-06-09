

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  List<String> _permissions = [];

  List<String> get permissions => _permissions;

  void setPermissions(List<String> permissions) {
    _permissions = permissions;
    notifyListeners();
  }
}
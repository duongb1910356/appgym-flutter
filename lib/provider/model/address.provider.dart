import 'package:dvhcvn/dvhcvn.dart';
import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  int _latestChange = 1;
  int get latestChange => _latestChange;

  Level1 _level1 = level1s[0];
  Level1 get level1 => _level1;
  set level1(Level1 lv) {
    _level1 = lv;
    _level2 = lv.children[0];
    _level3 = lv.children[0].children[0];
    _level2 = lv.children[0];
    notifyListeners();
  }

  late Level2 _level2 = level1.children[0];
  Level2 get level2 => _level2;
  set level2(Level2 lv) {
    _level2 = lv;
    _level3 = lv.children[0];
    notifyListeners();
  }

  late Level3 _level3 = level1.children[0].children[0];
  Level3 get level3 => _level3;
  set level3(Level3 lv) {
    _level3 = lv;
  }
}

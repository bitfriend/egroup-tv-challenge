import 'package:flutter/foundation.dart';

class FavoriteSelection extends ChangeNotifier {
  List<int> _ids = [];

  List<int> get ids => _ids;

  set ids(List<int> value) {
    _ids = value;
    notifyListeners();
  }

  bool contains(int id) {
    return ids.contains(id);
  }

  void append(int id) {
    ids.add(id);
    notifyListeners();
  }

  void remove(int id) {
    ids.remove(id);
    notifyListeners();
  }
}

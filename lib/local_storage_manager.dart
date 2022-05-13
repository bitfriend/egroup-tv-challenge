import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageManager {
  static final LocalStorageManager _instance = LocalStorageManager._internal();

  static final _storage = LocalStorage(dotenv.env['APP_NAME'] ?? 'egroup-tv-challenge');

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory LocalStorageManager() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  LocalStorageManager._internal() {
    // initialization logic
  }

  Future<List<int>> readFavorites() async {
    await _storage.ready;
    return (_storage.getItem('favorites') as List).map((item) => item as int).toList();
  }

  Future<void> writeFavorites(List<int> ids) async {
    await _storage.ready;
    return _storage.setItem('favorites', ids);
  }
}

import 'package:sembast/sembast.dart';

import 'database.dart';

class ApiDao {
  final _apiStore = StoreRef<String, String>.main();

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(String key, String json) async {
    await _apiStore.record(key).put(await _db, json);
  }

  Future<String> get(String key) async {
    return await _apiStore.record(key).get(await _db);
  }
}


import 'package:sembast/sembast.dart';

import 'database.dart';

class ApiDao {
  final _apiStore = StoreRef<String, String>.main();

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(String url, String json) async {
    await _apiStore.record(url).put(await _db, json);
//    await _apiStore.add(await _db,);
  }

//  Future update(ApiResponse response) async {
//    final finder = Finder(filter: Filter.byKey(response.url));
//    await _apiStore.update(
//      await _db,
//      response.toMap(),
//      finder: finder,
//    );
//  }
//
//  Future delete(ApiResponse response) async {
//    final finder = Finder(filter: Filter.byKey(response.url));
//    await _apiStore.delete(
//      await _db,
//      finder: finder,
//    );
//  }

  Future<String> get(String url) async {
    return await _apiStore.record(url).get(await _db);
  }
}


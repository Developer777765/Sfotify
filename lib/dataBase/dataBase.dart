import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HandlingLoggedInLoggedOut {
  Future<Database> get openingDB async {
    Database database = await initDB();
    return database;
  }

  Future<Database> initDB() async {
    var dataBasePath = await getDatabasesPath();
    var path = join(dataBasePath, 'sfotify.db');
    Database theDataBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'create table SfotifyInfo(id INTEGER PRIMARY KEY, loggedInOut INTEGER, token TEXT, refreshToken TEXT)');
    });
    return theDataBase;
  }

  insertingIntoSfotifyTable(rows) async {
    Database db = await openingDB;
    db.insert('SfotifyInfo', rows);
    // db.close();
  }

  updatingLoggedInOut(int loggedInOut) async {
    Database db = await openingDB;
    
    await db.insert('SfotifyInfo',{'LoggedInOut' : loggedInOut}, conflictAlgorithm: ConflictAlgorithm.replace);
      
  }

  updatingToken(String authToken) async {
    Database db = await openingDB;
    

    final String query = 'UPDATE SfotifyInfo SET token = ? WHERE id = 1';

    //db.rawUpdate('update SfotifyInfo set token = $authToken where id=$id');
    db.rawUpdate(query, [authToken]);
    //db.close();
  }


  updatingRefreshToken(String refreshToken) async {
    Database db = await openingDB;
    

    final String query = 'UPDATE SfotifyInfo SET refreshToken = ? WHERE id = 1';

    //db.rawUpdate('update SfotifyInfo set token = $authToken where id=$id');
    db.rawUpdate(query, [refreshToken]);
    //db.close();
  }

  Future<List<Map<String, Object?>>> queryingFromDatabase() async {
    Database db = await openingDB;
    var queriedDb = await db.query('SfotifyInfo');

    //db.close();
    return queriedDb;
  }

  Future<bool> queryingTableStatus() async {
    bool tableStatus = false;
    Database db = await openingDB;
    var table = await db.rawQuery('Select count(*) from SfotifyInfo');
    int? count = Sqflite.firstIntValue(table);
    print('number of rows is $count');
    if (count != null && count > 0) {
      print('number of rows in databse is $count');
      return true;
    }

    return tableStatus;
  }
}

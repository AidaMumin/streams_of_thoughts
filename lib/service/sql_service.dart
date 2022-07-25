//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService{
  late Future<Database> _db;
  SQLiteService(){
    initDB();
  }

  void initDB() async{
    _db = openDatabase(
      join(await getDatabasesPath(),"stream_of_thoughts.db"),
      onCreate: ((db, version) {
        db.execute("CREATE TABLE posts (id TEXT PRIMARY KEY, content TEXT, type INTEGER, createdAt DATETIME, creator STRING)");
      }),
      version: 1
      );
  }
}
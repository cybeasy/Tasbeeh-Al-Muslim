import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class dbSQLiteProvider {
  dbSQLiteProvider._();
  static final dbSQLiteProvider db = dbSQLiteProvider._();
  static Database? _database;

  static String database_name = "databaseV1.db";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    if (_database!.isOpen) {
      await updateDB(_database!);
    }
    return _database!;
  }

  // Mobile asset copy
  Future<void> _copyMobileDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, database_name);
    print('The DB path is: ' + path);

    final file = io.File(path);
    if (await file.exists()) {
      final length = await file.length();
      if (length > 0) {
        print('Database already exists on mobile ($length bytes). Skipping copy.');
        return;
      }
    }

    try {
      print('Copying DB on mobile...');
      ByteData data = await rootBundle.load(join('assets/db/', database_name));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes, flush: true);
      print('Database successfully copied on mobile.');
    } catch (error) {
      print('Error copying mobile DB: $error');
    }
  }

  Future<Database> _initMobileDB() async {
    await _copyMobileDB();

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, database_name);
    return await openDatabase(
      path,
      version: 7,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {},
      onUpgrade: _onUpgrade,
    );
  }

  Future<Database> _initWebDB() async {
    final factory = databaseFactoryFfiWebNoWebWorker;
    final path = database_name;

    bool exists = await factory.databaseExists(path);
    if (!exists) {
      try {
        print('Copying DB for Web from assets...');
        ByteData data = await rootBundle.load(join('assets/db/', database_name));
        Uint8List bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await factory.writeDatabaseBytes(path, bytes);
        print('Web DB successfully copied into indexeddb/wasm storage.');
      } catch (error) {
        print('Error copying web DB: $error');
      }
    }

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 7,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<Database> initDB() async {
    if (kIsWeb) {
      return await _initWebDB();
    } else {
      return await _initMobileDB();
    }
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      upgrade(db);
    }
  }

  Future<void> updateDB(Database db) async {
    scripts(db);

    var prefs = await SharedPreferences.getInstance();

    String? _updated = prefs.getString("db_ver");
    if (_updated == null) {
      prefs.setString("db_ver", "1");
    }
  }

  void upgrade(Database db) {
    // db.execute("ALTER TABLE in");
  }

  void scripts(Database db) {
    // db.execute( "CREATE TABLE IF NOT EXISTS RecordSleep ( row_id INTEGER PRIMARY KEY AUTOINCREMENT, hours INTEGER NOT NULL, dt TIMESTAMP NOT NULL )");
  }
}

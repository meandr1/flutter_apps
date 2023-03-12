import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lang_log_b/data/models/word.dart';

// database table and column names
final String _tableWords = 'words';
final String _tableDialogs = 'wordsExamples';
final String _tableDerivatives = 'derivatives';

final _wordColumns = [
  columnId,
  columnSystemId,
  columnCategoryId,
  columnFirstWord,
  columnSecondWord,
  columnTranslation,
  columnTestTranslation,
  columnTranscryption,
  columnTestId,
  columnControlId,
  columnPageId,
  columnIsStartTest
];

final _dialogColumns = [
  columnId,
  columnSystemId,
  columnCategoryId,
  columnFirstWord,
  columnTranslation,
  columnPageId
];

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "LangLogB.db";
  // Increment this version when you need to change the schema.
  // static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: true);
  }
/*
  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableWords (
                $columnId INTEGER PRIMARY KEY,
                $columnSystemId INTEGER NOT NULL,
                $columnCategoryId INTEGER NOT NULL,
                $columnWord TEXT NOT NULL,
                $columnTranslation TEXT NOT NULL,
                $columnTranscryption TEXT NOT NULL
              )
              ''');
  }
*/
  // Database helper methods:

  Future<int> insert(Word systemItem) async {
    Database db = await database;
    int id = await db.insert(_tableWords, systemItem.toMap());
    return id;
  }

//  MARK: Words
  Future<Word> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Word.fromMap(maps.first);
    }
    return null;
  }

//MARK: System
  Future<List<Word>> queryWordsForSystem(int systemId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnSystemId = ?',
        whereArgs: [systemId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

//MARK: Dialogs
  Future<List<Word>> queryDialogsForSystem(int systemId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableDialogs,
        columns: _dialogColumns,
        where: '$columnSystemId = ?',
        whereArgs: [systemId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }
    return items;
  }

//MARK: Word Test
  Future<List<Word>> queryWordsForStartTest() async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnIsStartTest = ?',
        whereArgs: [1]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  Future<List<Word>> queryWordsForTest(int testId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnTestId = ?',
        whereArgs: [testId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  //MARK: Word Test Result
  Future<List<Word>> queryWordsForTestResult(List<int> results) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnId IN (${results.map((result) => '?').join(', ')})',
        whereArgs:results);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  //MARK: Word Control
  Future<List<Word>> queryWordsForControl(int controlId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableWords,
        columns: _wordColumns,
        where: '$columnControlId = ?',
        whereArgs: [controlId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  //MARK: Words Count
  Future<int> countWords() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableWords'));
  }

  //MARK: Derivatives
  Future<List<Word>> queryDerivativesForSystem(int systemId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableDerivatives,
        columns: _wordColumns,
        where: '$columnSystemId = ?',
        whereArgs: [systemId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  //MARK: Derivative Test
  Future<List<Word>> queryDerivativesForTest(int testId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableDerivatives,
        columns: _wordColumns,
        where: '$columnTestId = ?',
        whereArgs: [testId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }

  //MARK: Derivative Control
  Future<List<Word>> queryDerivativesForControl(int controlId) async {
    Database db = await database;
    List<Map> maps = await db.query(_tableDerivatives,
        columns: _wordColumns,
        where: '$columnControlId = ?',
        whereArgs: [controlId]);

    var items = List<Word>();
    for (var item in maps) {
      items.add(Word.fromMap(item));
    }

    return items;
  }
}

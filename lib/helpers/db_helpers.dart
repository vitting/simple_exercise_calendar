import 'dart:io';

import 'package:path/path.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

final String dbName = "simplecalendarforexercise.db";
final int dbVersion = 1;

class DbHelpers {
  static final _lock = new Lock();
  static Database _db;

  static Future<Database> get db async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    // Sqflite.setDebugModeOn();
    if (_db == null || !_db.isOpen) {
      try {
        await Directory(databasesPath).create(recursive: true);
      } catch (error) {
        print("Create DB directory error: $error");
      }

      /// Avoid lock issues on Android
      await _lock.synchronized(() async {
        if (_db == null || !_db.isOpen) {
          print("******************Opening database**********************");
          _db = await openDatabase(path, version: dbVersion,
              onCreate: (Database db, int version) async {
            try {
              print("ONCREATE CREATION TABLES");
              await db.execute("${DbSql.createExercisePlans}");
              await db.execute("${DbSql.createExercises}");
              await db.execute("${DbSql.createEvents}");
            } catch (error) {
              print("DB ONCREATE ERROR: $error");
            }
          }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
            try {
              print("ONUPGRADE CREATION TABLES");
              await db.execute("${DbSql.createExercisePlans}");
              await db.execute("${DbSql.createExercises}");
              await db.execute("${DbSql.createEvents}");
            } catch (error) {
              print("DB ONUPGRADE ERROR: $error");
            }
          }, onOpen: (Database db) async {
            try {
              print("ONOPEN");
              // await db.execute("${DbSql.createExercisePlans}");
              // await db.execute("${DbSql.createExercises}");
              // await db.execute("${DbSql.createEvents}");



              // await db.execute("${DbSql.dropExercisePlans}");
              // await db.execute("${DbSql.dropExercises}");
              // await db.execute("${DbSql.dropEvents}");
            } catch (error) {
              print("DB ONOPEN ERROR: $error");
            }
          }, onDowngrade: (Database db, int oldVersion, int newVersion) {
            print("ONDOWNGRADE");
            try {
              File f = File.fromUri(Uri.file(path));
              f.delete();
            } catch (e) {
              print("FILE ERROR: $e");
            }
          });
        }
      });
    }

    return _db;
  }

  static Future<dynamic> close() async {
    Database dbCon = await db;
    return dbCon.close();
  }

  static Future<int> insert(String table, Map<String, dynamic> item) async {
    Database dbCon = await db;
    return dbCon.insert(table, item);
  }

  static Future<int> update(String table, Map<String, dynamic> item,
      String where, List<dynamic> whereArgs) async {
    Database dbCon = await db;
    return dbCon.update(table, item, where: where, whereArgs: whereArgs);
  }

  static Future<int> deleteById(String table, String id) async {
    Database dbCon = await db;
    return dbCon.delete(table, where: "${DbSql.colId} = ?", whereArgs: [id]);
  }

  static Future<int> deleteExercisesByExerciseplanId(String exercisePlanId) async {
    Database dbCon = await db;
    return dbCon.delete(DbSql.tableExercises,
        where: "${DbSql.colExercisePlanId} = ?", whereArgs: [exercisePlanId]);
  }

  static Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct = false,
      int limit = -1,
      String orderBy,
      String where,
      List<dynamic> whereArgs}) async {
    Database dbCon = await db;
    return dbCon.query(table,
        columns: [],
        distinct: distinct,
        limit: limit,
        orderBy: orderBy,
        where: where,
        whereArgs: whereArgs);
  }

  static Future<int> updateExerciseIndex(String exerciseId, int index) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE ${DbSql.tableExercises} SET 'index' = ? WHERE id = ?", [index, exerciseId]);
  }

  static Future<int> updateExerciseText(String id, String text) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE ${DbSql.tableExercises} SET 'text' = ? WHERE id = ?", [text, id]);
  }

  static Future<int> updateExerciseClosed(String id, bool closed) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE ${DbSql.tableExercises} SET 'closed' = ? WHERE id = ?", [closed, id]);
  }

  static Future<int> updatePlanTitle(String id, String title) async {
    Database dbCon = await db;
    return dbCon.rawUpdate("UPDATE ${DbSql.tableExercisePlans} SET 'title' = ? WHERE id = ?", [title, id]);
  }

  static Future<List<Map<String, dynamic>>> getEventsForMonth(int startDateInMilliseconds, int endDateInMilliseconds) async {
    Database dbCon = await db;
    return dbCon.rawQuery("SELECT * FROM ${DbSql.tableEvents} WHERE date BETWEEN ? and ?", [startDateInMilliseconds, endDateInMilliseconds]);
  }

  static Future<List<Map<String, dynamic>>> getExercisesCount(String exerciseId) async {
    Database dbCon = await db;
    return dbCon.rawQuery("SELECT COUNT([id]) as total FROM ${DbSql.tableExercises} WHERE exercisePlanId = ?", [exerciseId]);
  }
}

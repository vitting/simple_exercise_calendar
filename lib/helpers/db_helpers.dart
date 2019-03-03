import 'dart:io';

import 'package:path/path.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

final String dbName = "simplecalendarforexercise.db";
final int dbVersion = 2;

class DbHelpers {
  static final _lock = new Lock();
  static Database _db;

  static Future<Database> get db async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);

    /// TODO: Remember to Disable before release
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
              await db.execute("${DbSql.createExerciseNotes}");
              await db.execute("${DbSql.createEvents}");
            } catch (error) {
              print("DB ONCREATE ERROR: $error");
            }
          }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
            try {
              print("ONUPGRADE CREATION TABLES");
              await db.execute("${DbSql.createExercisePlans}");
              await db.execute("${DbSql.createExercises}");
              await db.execute("${DbSql.createExerciseNotes}");
              await db.execute("${DbSql.createEvents}");
            } catch (error) {
              print("DB ONUPGRADE ERROR: $error");
            }
          }, onOpen: (Database db) async {
            try {
              print("ONOPEN");
              // await db.execute("${DbSql.dropExercisePlans}");
              // await db.execute("${DbSql.createExercisePlans}");

              // await db.execute("${DbSql.dropExercises}");
              // await db.execute("${DbSql.createExercises}");

              // await db.execute("${DbSql.dropEvents}");
              // await db.execute("${DbSql.createEvents}");
              // await db.execute("${DbSql.dropExerciseNotes}");
              // await db.execute("${DbSql.createExerciseNotes}");
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

  static void close() {
    print("DB CLOSE");
    if (_db == null || _db.isOpen) {
      _db.close();
    }
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

  static Future<int> deleteExercisesByExerciseplanId(
      String exercisePlanId) async {
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
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colIndex}' = ? WHERE ${DbSql.colId} = ?",
        [index, exerciseId]);
  }

  static Future<int> updateExerciseClosed(String id, bool closed) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colClosed}' = ? WHERE ${DbSql.colId} = ?",
        [closed, id]);
  }

  static Future<int> updateExerciseSeconds(String id, int seconds) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colSeconds}' = ? WHERE ${DbSql.colId} = ?",
        [seconds, id]);
  }

  static Future<int> updateExerciseWeight(String id, double weight) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colWeight}' = ? WHERE ${DbSql.colId} = ?",
        [weight, id]);
  }

  static Future<int> updateExerciseRepetitions(
      String id, int repetitions) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colRepetitions}' = ? WHERE ${DbSql.colId} = ?",
        [repetitions, id]);
  }

  static Future<int> updateExerciseRepetitionsDone(
      String id, int repetitionsDone) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercises} SET '${DbSql.colRepetitionsDone}' = ? WHERE ${DbSql.colId} = ?",
        [repetitionsDone, id]);
  }

  static Future<int> updatePlanTitle(String id, String title) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableExercisePlans} SET '${DbSql.colTitle}' = ? WHERE ${DbSql.colId} = ?",
        [title, id]);
  }

  static Future<List<Map<String, dynamic>>> getEventsForMonth(
      int startDateInMilliseconds, int endDateInMilliseconds) async {
    Database dbCon = await db;
    return dbCon.rawQuery(
        "SELECT * FROM ${DbSql.tableEvents} WHERE ${DbSql.colDate} BETWEEN ? and ?",
        [startDateInMilliseconds, endDateInMilliseconds]);
  }

  static Future<List<Map<String, dynamic>>> getExercisesCount(
      String exerciseId) async {
    Database dbCon = await db;
    return dbCon.rawQuery(
        "SELECT COUNT([id]) as total FROM ${DbSql.tableExercises} WHERE ${DbSql.colExercisePlanId} = ?",
        [exerciseId]);
  }
}

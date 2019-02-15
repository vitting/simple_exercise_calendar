import 'package:meta/meta.dart';
import 'package:simple_exercise_calendar/helpers/date_time_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class EventData {
  String id;
  DateTime date;
  String exercisePlanId;
  String templateExercisePlanId;

  EventData(
      {this.id,
      @required this.date,
      @required this.exercisePlanId,
      this.templateExercisePlanId});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date.millisecondsSinceEpoch,
      "exercisePlanId": exercisePlanId,
      "templateExercisePlanId": templateExercisePlanId
    };
  }

  Future<int> deleteExercisePlan() async {
    await DbHelpers.deleteExercisesByExerciseplanId(exercisePlanId);
    return DbHelpers.deleteById(DbSql.tableExercisePlans, exercisePlanId);
  }

  Future<int> deleteExercises() async {
    await DbHelpers.deleteExercisesByExerciseplanId(exercisePlanId);
    return 0;
  }

  Future<int> updateExercises() async {
    List<ExerciseData> exercises = await this.getTemplateExercises();
    if (exercises.length != 0) {
      await DbHelpers.deleteExercisesByExerciseplanId(exercisePlanId);
      exercises.forEach((ExerciseData data) async {
        await data.saveCopy(this.exercisePlanId);
      });
    }

    return exercises.length;
  }

  Future<String> getEventPlanTitle() async {
    String value;
    List<Map<String, dynamic>> list = await DbHelpers.query(
        DbSql.tableExercisePlans,
        where: "id = ?",
        whereArgs: [this.exercisePlanId]);

    if (list.length != 0) {
      Map<String, dynamic> item = list[0];
      value = item["title"];
    }

    return value;
  }

  Future<String> getTemplatePlanTitle() async {
    String value;
    List<Map<String, dynamic>> list = await DbHelpers.query(
        DbSql.tableExercisePlans,
        where: "id = ?",
        whereArgs: [this.templateExercisePlanId]);

    if (list.length != 0) {
      Map<String, dynamic> item = list[0];
      value = item["title"];
    }

    return value;
  }

  Future<List<ExerciseData>> getTemplateExercises() async {
    List<Map<String, dynamic>> list = await DbHelpers.query(
        DbSql.tableExercises,
        where: "exercisePlanId = ?",
        whereArgs: [this.templateExercisePlanId],
        orderBy: "[index]");
    return list.map<ExerciseData>((Map<String, dynamic> item) {
      return ExerciseData.fromMap(item);
    }).toList();
  }

  Future<int> save() {
    id = id ?? SystemHelpers.generateUuid();
    date = DateTime(date.year, date.month, date.day);

    return DbHelpers.insert(DbSql.tableEvents, this.toMap());
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tableEvents, id);
  }

  Future<List<ExerciseData>> getExercises() async {
    List<Map<String, dynamic>> list = await DbHelpers.query(
        DbSql.tableExercises,
        where: "exercisePlanId = ?",
        whereArgs: [exercisePlanId],
        orderBy: "[index]");
    return list.map<ExerciseData>((Map<String, dynamic> item) {
      return ExerciseData.fromMap(item);
    }).toList();
  }

  Future<ExercisePlanData> getExercisePlan() async {
    ExercisePlanData plan;
    List<Map<String, dynamic>> list = await DbHelpers.query(
        DbSql.tableExercisePlans,
        where: "id = ?",
        whereArgs: [exercisePlanId]);

    if (list.length != 0) {
      plan = ExercisePlanData.fromMap(list[0]);
    }

    return plan;
  }

  factory EventData.fromMap(Map<String, dynamic> item) {
    return EventData(
        id: item["id"],
        date: DateTime.fromMillisecondsSinceEpoch(item["date"]),
        exercisePlanId: item["exercisePlanId"],
        templateExercisePlanId: item["templateExercisePlanId"]);
  }

  factory EventData.create(
      String exercisePlanId, String templateExercisePlanId, DateTime date) {
    return EventData(
        date: date,
        exercisePlanId: exercisePlanId,
        templateExercisePlanId: templateExercisePlanId);
  }

  static Future<List<EventData>> getEventsForMonth(DateTime date) async {
    DateTime startOfMonthDate = DateTime(date.year, date.month, 1);
    DateTime endOfMonthDate = DateTime(date.year, date.month,
        DateTimeHelpers.daysInMonth(date.month, date.year));
    List<Map<String, dynamic>> list = await DbHelpers.getEventsForMonth(
        startOfMonthDate.millisecondsSinceEpoch,
        endOfMonthDate.millisecondsSinceEpoch);
    return list.map<EventData>((Map<String, dynamic> item) {
      return EventData.fromMap(item);
    }).toList();
  }
}

import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/event_data.dart';
import 'package:simple_exercise_calendar/helpers/exercise_data.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class ExercisePlanData {
  String id;
  String title;
  DateTime date;

  /// template | event
  String type;
  bool closed;

  ExercisePlanData(
      {this.id,
      this.title,
      this.date,
      this.type = "template",
      this.closed = false});

  Future<int> save() {
    id = id ?? SystemHelpers.generateUuid();
    date = date ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return DbHelpers.insert(DbSql.tableExercisePlans, this.toMap());
  }

  Future<int> delete() async {
    await DbHelpers.deleteExercisesByExerciseplanId(id);
    return DbHelpers.deleteById(DbSql.tableExercisePlans, id);
  }

  Future<int> getExercisesCount() async {
    List<Map<String, dynamic>> data = await DbHelpers.getExercisesCount(id);
    return data[0]["total"];
  }

  Future<List<ExerciseData>> getExercises() async {
    List<Map<String, dynamic>> data = await DbHelpers.query(
        DbSql.tableExercises,
        where: "exercisePlanId = ?",
        whereArgs: [id],
        orderBy: "[index]");
    return data.map<ExerciseData>((Map<String, dynamic> item) {
      return ExerciseData.fromMap(item);
    }).toList();
  }

  Future<void> updateExercisesOrder(List<ExerciseData> exercises) async {
    for (var i = 0; i < exercises.length; i++) {
      ExerciseData exercise = exercises[i];
      await exercise.updateIndex(i);
    }
  }

  Future<int> updateTitle(String title) {
    this.title = title;
    return DbHelpers.updatePlanTitle(id, title);
  }

  /// Generate a copy of this plan with a new id and type as event
  /// type = template | event
  ExercisePlanData makeCopy([String type = "template"]) {
    return ExercisePlanData(
        id: SystemHelpers.generateUuid(),
        closed: closed,
        date: date,
        title: title,
        type: type);
  }

  Future<ExercisePlanData> saveCopyWithExercises(
      [String title = "", String type = "template"]) async {
    String newId = SystemHelpers.generateUuid();
    List<ExerciseData> exercises = await this.getExercises();
    ExercisePlanData newExercisePlan = ExercisePlanData(
        id: newId, title: title.isEmpty ? this.title : title, type: type);

    int result = await newExercisePlan.save();
    if (result != null && result != 0) {
      exercises.forEach((ExerciseData item) async {
        await item.saveCopy(newId);
      });
    }

    return newExercisePlan;
  }

  Future<void> addExercise(ExerciseData exercise) async {
    exercise.exercisePlanId = id;
    await exercise.save();
  }

  Future<EventData> addEvent(DateTime date) async {
    List<ExerciseData> exercises = await this.getExercises();
    ExercisePlanData planCopy = this.makeCopy("event");
    await planCopy.save();

    exercises.forEach((ExerciseData data) async {
      await data.saveCopy(planCopy.id);
    });

    EventData event = EventData.create(planCopy.id, id, date);
    await event.save();
    return event;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "date": date.millisecondsSinceEpoch,
      "type": type,
      "closed": closed
    };
  }

  factory ExercisePlanData.fromMap(Map<String, dynamic> item) {
    return ExercisePlanData(
        id: item["id"],
        title: item["title"],
        date: DateTime.fromMillisecondsSinceEpoch(item["date"]),
        type: item["type"],
        closed: item["closed"] == 1);
  }

  static Future<List<ExercisePlanData>> getExercisePlans() async {
    List<Map<String, dynamic>> exercisePlans = await DbHelpers.query(
        DbSql.tableExercisePlans,
        where: "type = ?",
        whereArgs: ["template"],
        orderBy: "title");
    return exercisePlans.map<ExercisePlanData>((Map<String, dynamic> item) {
      return ExercisePlanData.fromMap(item);
    }).toList();
  }
}

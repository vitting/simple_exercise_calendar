import 'package:meta/meta.dart';
import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class ExerciseNoteData {
  String id;
  String exerciseId;
  String orgExerciseId;
  String exercisePlanId;
  String orgExercisePlanId;
  String note;
  DateTime date;

  ExerciseNoteData(
      {this.id,
      @required this.exerciseId,
      @required this.orgExerciseId,
      @required this.exercisePlanId,
      @required this.orgExercisePlanId,
      @required this.note,
      this.date});

  Future<int> save() {
    if (id == null) {
      id = SystemHelpers.generateUuid();
      date = DateTime.now();
      return DbHelpers.insert(DbSql.tableExerciseNotes, this.toMap());
    } else {
      return DbHelpers.update(
          DbSql.tableExerciseNotes, this.toMap(), "id = ?", [id]);
    }
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tableExerciseNotes, id);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "exerciseId": exerciseId,
      "orgExerciseId": orgExerciseId,
      "exercisePlanId": exercisePlanId,
      "orgExercisePlanId": orgExercisePlanId,
      "note": note,
      "date": date.millisecondsSinceEpoch
    };
  }

  factory ExerciseNoteData.fromMap(Map<String, dynamic> item) {
    return ExerciseNoteData(
        id: item["id"],
        exerciseId: item["exerciseId"],
        orgExerciseId: item["orgExerciseId"],
        exercisePlanId: item["exercisePlanId"],
        orgExercisePlanId: item["orgExercisePlanId"],
        note: item["note"],
        date: DateTime.fromMillisecondsSinceEpoch(item["date"]));
  }
}

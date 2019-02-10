import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class ExerciseData {
  String id;
  String exercisePlanId;
  String text;
  int index;
  bool closed;

  ExerciseData({this.id, this.exercisePlanId, this.text, this.index = 0, this.closed = false});

  Future<int> save() {
    id = id ?? SystemHelpers.generateUuid();
    return DbHelpers.insert(DbSql.tableExercises, this.toMap());
  }

  Future<int> saveCopy(String exercisePlanId) {
    id = SystemHelpers.generateUuid();
    this.exercisePlanId = exercisePlanId;
    return DbHelpers.insert(DbSql.tableExercises, this.toMap());
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tableExercises, id);
  }

  Future<int> updateIndex(int index) {
    this.index = index;
    return DbHelpers.updateExerciseIndex(id, index);
  }

  Future<int> updateText(String text) {
    this.text = text;
    return DbHelpers.updateExerciseText(id, text);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "exercisePlanId": exercisePlanId,
      "text": text,
      "index": index,
      "closed": closed
    };
  }

  factory ExerciseData.fromMap(Map<String, dynamic> item) {
    return ExerciseData(
      id: item["id"],
      exercisePlanId: item["exercisePlanId"],
      text: item["text"],
      index: item["index"],
      closed: item["closed"] == 1
    );
  }
}
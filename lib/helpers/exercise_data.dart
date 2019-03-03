import 'package:simple_exercise_calendar/helpers/db_helpers.dart';
import 'package:simple_exercise_calendar/helpers/db_sql_create.dart';
import 'package:simple_exercise_calendar/helpers/exercise_note_data.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';

class ExerciseData {
  String id;
  String orgExerciseId;
  String exercisePlanId;
  String orgExercisePlanId;
  String text;
  String description;
  double weight;
  int seconds;
  int repetitions;
  int repetitionsDone;
  int index;
  bool closed;

  ExerciseData(
      {this.id,
      this.orgExerciseId,
      this.exercisePlanId,
      this.orgExercisePlanId,
      this.text,
      this.description = "",
      this.seconds = 0,
      this.weight = 0.0,
      this.repetitions = 0,
      this.repetitionsDone = 0,
      this.index = 0,
      this.closed = false});

  Future<int> save() {
    id = id ?? SystemHelpers.generateUuid();
    orgExerciseId = orgExerciseId ?? id;
    orgExercisePlanId = orgExercisePlanId ?? exercisePlanId;
    return DbHelpers.insert(DbSql.tableExercises, this.toMap());
  }

  Future<int> update() {
    return DbHelpers.update(DbSql.tableExercises, this.toMap(), "id = ?", [id]);
  }

  Future<int> saveCopy(String exercisePlanId, [bool overwriteOrgIds = false]) {
    id = SystemHelpers.generateUuid();
    this.exercisePlanId = exercisePlanId;

    if (overwriteOrgIds) {
      this.orgExerciseId = id;
      this.orgExercisePlanId = exercisePlanId;
    }

    return DbHelpers.insert(DbSql.tableExercises, this.toMap());
  }

  Future<int> delete() {
    return DbHelpers.deleteById(DbSql.tableExercises, id);
  }

  Future<int> updateIndex(int index) {
    this.index = index;
    return DbHelpers.updateExerciseIndex(id, index);
  }

  Future<int> updateClosed(bool closed) {
    this.closed = closed;
    return DbHelpers.updateExerciseClosed(id, closed);
  }

  Future<int> updateSeconds(int seconds) {
    this.seconds = seconds;
    return DbHelpers.updateExerciseSeconds(id, seconds);
  }

  Future<int> updateWeight(double weight) {
    this.weight = weight;
    return DbHelpers.updateExerciseWeight(id, weight);
  }

  Future<int> updateRepetitions(int repetitions) {
    this.repetitions = repetitions;
    return DbHelpers.updateExerciseRepetitions(id, repetitions);
  }

  Future<int> updateRepetitionsDone(int repetitionsDone) {
    this.repetitionsDone = repetitionsDone;
    return DbHelpers.updateExerciseRepetitionsDone(id, repetitionsDone);
  }

  Future<int> addExerciseNote(String note) {
    ExerciseNoteData exerciseNote = ExerciseNoteData(
        exerciseId: this.id,
        orgExerciseId: this.orgExerciseId,
        exercisePlanId: this.exercisePlanId,
        orgExercisePlanId: this.orgExercisePlanId,
        note: note);

    return exerciseNote.save();
  }

  Future<int> updateExerciseNote(String note, ExerciseNoteData exerciseNote) {
    exerciseNote.note = note;
    return exerciseNote.save();
  }

  Future<int> deleteExerciseNote(ExerciseNoteData exerciseNote) {
    return exerciseNote.delete();
  }

  Future<List<ExerciseNoteData>> getExerciseNotes() async {
    List<Map<String, dynamic>> list = await DbHelpers.query(DbSql.tableExerciseNotes, where: "exerciseId = ?", whereArgs: [id], orderBy: "date");

    return list.map<ExerciseNoteData>((Map<String, dynamic> item) {
      return ExerciseNoteData.fromMap(item);
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "orgExerciseId": orgExerciseId,
      "exercisePlanId": exercisePlanId,
      "orgExercisePlanId": orgExercisePlanId,
      "text": text,
      "description": description,
      "seconds": seconds,
      "weight": weight,
      "repetitions": repetitions,
      "repetitionsDone": repetitionsDone,
      "index": index,
      "closed": closed
    };
  }

  factory ExerciseData.fromMap(Map<String, dynamic> item) {
    return ExerciseData(
        id: item["id"],
        orgExerciseId: item["orgExerciseId"],
        exercisePlanId: item["exercisePlanId"],
        orgExercisePlanId: item["orgExercisePlanId"],
        text: item["text"],
        description: item["description"],
        seconds: item["seconds"],
        weight: item["weight"],
        repetitions: item["repetitions"],
        repetitionsDone: item["repetitionsDone"],
        index: item["index"],
        closed: item["closed"] == 1);
  }

  factory ExerciseData.copy(ExerciseData item,
      [bool overwriteOrgExerciseId = false]) {
    String newId = SystemHelpers.generateUuid();
    return ExerciseData(
        id: newId,
        orgExerciseId: overwriteOrgExerciseId ? newId : item.orgExerciseId,
        exercisePlanId: item.exercisePlanId,
        orgExercisePlanId: item.orgExercisePlanId,
        text: item.text,
        description: item.description,
        seconds: item.seconds,
        weight: item.weight,
        repetitions: item.repetitions,
        repetitionsDone: item.repetitionsDone,
        closed: false,
        index: item.index);
  }
}

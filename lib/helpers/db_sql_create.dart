class DbSql {
  static const String tableExercisePlans = "exerciseplans";
  static const String tableExercises = "exercises";
  static const String tableEvents = "events";
  static const String colId = "id";
  static const String colExercisePlanId = "exercisePlanId";
  static const String colTitle = "title";
  static const String colText = "text";
  static const String colDate = "date";
  static const String colType = "type";
  static const String colIndex = "index";
  static const String colClosed = "closed";
  static const String colDescription = "description";
  static const String colWeight = "weight";
  static const String colSeconds = "seconds";
  static const String colRepetitions = "repetitions";
  static const String colRepetitionsDone = "repetitionsDone";
  static const String createExercisePlans = "CREATE TABLE IF NOT EXISTS [$tableExercisePlans] ([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colTitle] TEXT(250) NOT NULL, [$colDate] INTEGER NOT NULL, [$colType] TEXT(10) NOT NULL, [$colClosed] INTEGER NOT NULL DEFAULT 0);";
  static const String createExercises = "CREATE TABLE IF NOT EXISTS [$tableExercises] ([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colExercisePlanId] TEXT(50) NOT NULL, [$colText] TEXT(250) NOT NULL, [$colDescription] TEXT(2000) NOT NULL, [$colWeight] DOUBLE NOT NULL DEFAULT 0, [$colSeconds] INTEGER NOT NULL DEFAULT 0, [$colRepetitions] INTEGER NOT NULL DEFAULT 0, [$colRepetitionsDone] INTEGER NOT NULL DEFAULT 0, [$colIndex] INTEGER NOT NULL DEFAULT 0, [$colClosed] INTEGER NOT NULL DEFAULT 0);";
  static const String createEvents = "CREATE TABLE IF NOT EXISTS [$tableEvents] ([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colExercisePlanId] TEXT(50) NOT NULL, [$colDate] INTEGER NOT NULL);";
  static const String dropExercisePlans = "DROP TABLE IF EXISTS $tableExercisePlans;";
  static const String dropExercises = "DROP TABLE IF EXISTS $tableExercises;";
  static const String dropEvents = "DROP TABLE IF EXISTS $tableEvents;";
}
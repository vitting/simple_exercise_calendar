class DbSql {
  static final String tableExercisePlans = "exercisePlans";
  static final String tableExercises = "exercises";
  static final String colId = "id";
  static final String colExercisePlanId = "exercisePlanId";
  static final String colTitle = "title";
  static final String colText = "text";
  static final String colDate = "date";
  static final String colType = "type";
  static final String colIndex = "index";
  static final String colClosed = "closed";
  static final String createExercisePlans = "CREATE TABLE IF NOT EXISTS [$tableExercisePlans]([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colTitle] TEXT(100) NOT NULL, [$colDate] INTEGER NOT NULL, [$colType] TEXT(10) NOT NULL, [$colClosed] INTEGER NOT NULL DEFAULT 0);";
  static final String createExercises = "CREATE TABLE IF NOT EXISTS [$tableExercises]([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colExercisePlanId] TEXT(50) NOT NULL, [$colText] TEXT(100) NOT NULL, [$colIndex] INTEGER NOT NULL DEFAULT 0, [$colClosed] INTEGER NOT NULL DEFAULT 0);";
  static final String dropExercisePlans = "DROP TABLE IF EXISTS $tableExercisePlans;";
  static final String dropExercises = "DROP TABLE IF EXISTS $tableExercises;";
}
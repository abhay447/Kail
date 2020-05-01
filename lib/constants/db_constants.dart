class DBConstants{
  static final String KAIL_DB_PATH = "kail_test3.db";
  static final String KAIL_ACTIVITY_TABLE_NAME = "KAIL_ACTIVITY";
  static final String KAIL_SCHEDULE_TABLE_NAME = "KAIL_SCHEDULE";

  static final String KAIL_ACTIVTITY_CREATE_TABLE_SQL_V1 = """
    CREATE TABLE IF NOT EXISTS KAIL_ACTIVITY(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name STRING,
      acitivity_type STRING
    )
  """;

  static final String KAIL_SCHEDULE_CREATE_TABLE_SQL_V1 = """
    CREATE TABLE IF NOT EXISTS KAIL_SCHEDULE(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      acitivity_id INTEGER,
      day INTEGER,
      hour INTEGER,
      minute INTEGER
    )
  """;
  
}
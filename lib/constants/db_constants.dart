class DBConstants{
  static final String KAIL_DB_PATH = "kail_test1.db";

  static final String KAIL_ACTIVTITY_CREATE_TABLE_SQL_V1 = """
    CREATE TABLE KAIL_ACTIVITY(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name STRING,
      acitivity_type STRING
    )
  """;

  static final String KAIL_SCHEDULE_CREATE_TABLE_SQL_V1 = """
    CREATE TABLE KAIL_ACTIVITY(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      acitivity_id INTEGER,
      day INTEGER,
      hour INTEGER,
      minute INTEGER
    )
  """;
  
}
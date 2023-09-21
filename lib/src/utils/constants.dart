class DBConstants {
  static const mainDBName = 'register.db';
  static const datesDBName = 'register.db';

  static const membersTableName = 'members_table';
  static const dateTableName = 'dates_table';

  static const userTableExecSQLStatement =
      'CREATE TABLE IF NOT EXISTS $membersTableName ('
      'idNumber TEXT PRIMARYKEy, '
      ' name TEXT,'
      'telephoneNumber TEXT'
      ')';

  static const dateTableExecSQLStatement =
      'CREATE TABLE IF NOT EXISTS $dateTableName ('
      'idNumber TEXT PRIMARYKEY, '
      'registrationDate TEXT'
      ')';

  static const membersSelectAllStatement = 'SELECT * FROM $membersTableName';

  static const datesSelectAllStatement = 'SELECT $membersTableName.idNumber, '
      '$membersTableName.name FROM $membersTableName'
      ' INNER JOIN $dateTableName ON $membersTableName.idNumber = $dateTableName.idNumber';

  static String getWhereSelectStatement({
    required String tableName,
    required String field,
    required String match,
  }) {
    return 'SELECT * FROM $tableName WHERE $field ?= $match';
  }
}

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:register/src/models/member.dart';
import 'package:register/src/utils/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RegisterDatabase {
  Future<Database> db(String dbName) async {
    String dbPath = (await getApplicationDocumentsDirectory()).path;

    var databaseFactory = databaseFactoryFfi;

    await databaseFactory.openDatabase(
      '$dbPath/$dbName',
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(DBConstants.userTableExecSQLStatement);
        },
        version: 1,
      ),
    );

    return await databaseFactory.openDatabase(
      '$dbPath/$dbName',
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(DBConstants.userTableExecSQLStatement);
        },
        version: 1,
      ),
    );
  }

  Future dbFallBackHandle() async {
    Database db = await this.db(DBConstants.mainDBName);
    await db.execute(DBConstants.userTableExecSQLStatement);
  }

  Future<List<Map<String, dynamic>>> getAllMembers() async {
    await dbFallBackHandle();

    return await (await db(DBConstants.mainDBName))
        .rawQuery(DBConstants.membersSelectAllStatement);
  }

  Future<int> addUser(Member member) async {
    return await (await db(DBConstants.mainDBName)).insert(
      DBConstants.membersTableName,
      member.toJson(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<int> deleteAllUsers() async {
    return (await db(DBConstants.mainDBName))
        .delete(DBConstants.membersTableName);
  }

  Future<int> batchDeleteByIdNumber(String idNumber) async {
    return await (await db(DBConstants.mainDBName)).rawDelete(
      'DELETE FROM ${DBConstants.membersTableName} WHERE idNumber = ?',
      [idNumber],
    );
  }
}

/// The registered dates
class DateRegisterDatabase {
  Future<Database> db(String dbName) async {
    String dbPath = (await getApplicationDocumentsDirectory()).path;

    var databaseFactory = databaseFactoryFfi;

    return await databaseFactory.openDatabase(
      '$dbPath/$dbName',
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(DBConstants.dateTableExecSQLStatement);
        },
        version: 1,
      ),
    );
  }

  Future dbFallBackHandle() async {
    Database db = await this.db(DBConstants.datesDBName);
    await db.execute(DBConstants.dateTableExecSQLStatement);
  }

  Future<List<Map<String, dynamic>>> getAllMembers() async {
    Database db = await this.db(DBConstants.datesDBName);

    dbFallBackHandle();

    return await db.rawQuery(DBConstants.datesSelectAllStatement);
  }

  Future<int> addUser(
      {required Member member, required String registrationDate}) async {
    Database db = await this.db(DBConstants.datesDBName);

    dbFallBackHandle();

    return await db.insert(DBConstants.dateTableName, {
      'idNumber': member.idNumber,
      'registrationDate': registrationDate,
    });
  }

  Future<int> deleteWhere(String idNumber) async {
    Database db = await this.db(DBConstants.datesDBName);

    dbFallBackHandle();

    return await db.delete(
      DBConstants.datesDBName,
      where: 'idNumber = ?',
      whereArgs: [idNumber],
    );
  }

  Future<List<Map<String, dynamic>>> getWithDate({
    required String registrationDate,
  }) async {
    Database db = await this.db(DBConstants.datesDBName);

    dbFallBackHandle();

    debugPrint(
      (await db.query(
        DBConstants.dateTableName,
        where: 'registrationDate = ?',
        whereArgs: [registrationDate],
      ))
          .toString(),
    );

    return await db.query(
      DBConstants.dateTableName,
      where: 'registrationDate = ?',
      whereArgs: [registrationDate],
    );
  }
}

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../utils/db_helper.dart';
import 'entity.dart';

abstract class BaseDAO<T extends Entity> {
  Future<Database> get db => DatabaseHelper.getInstance().db;

  String get tableName;

  T fromMap(Map<String, dynamic> map);

  Future<int> save(T entity) async {
    var dbClient = await db;
    var id = await dbClient.insert(tableName, entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('$tableName id: $id');
    return id;
  }

  Future<List<T>> findAll() async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('SELECT * FROM $tableName');

    // print('listCard: $list');

    return list.map<T>((json) => fromMap(json)).toList();
  }

  Future<T> findById(int id) async {
    var dbClient = await db;
    final list =
        await dbClient.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);

    if (list.length > 0) return fromMap(list.first);

    return null;
  }

  Future<bool> exists(int id) async {
    T c = await findById(id);
    var exists = c != null;
    return exists;
  }

  Future<int> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('SELECT count(*) FROM $tableName');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .rawDelete('DELETE from $tableName WHERE id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM $tableName');
  }
}

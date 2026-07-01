import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as ffi_web;

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    await _ensureDatabaseFactory();
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _ensureDatabaseFactory() async {
    if (kIsWeb) {
      databaseFactory = ffi_web.databaseFactoryFfiWeb;
      return;
    }

    final plataformaDesktop =
        Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    if (plataformaDesktop) {
      ffi.sqfliteFfiInit();
      databaseFactory = ffi.databaseFactoryFfi;
    }
  }

  Future<Database> _initDatabase() async {
    final path = kIsWeb
        ? 'agenda_estudos.db'
        : join(await getDatabasesPath(), 'agenda_estudos.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_usuario TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        data_criacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        descricao_detalhada TEXT NOT NULL DEFAULT '',
        data_execucao TEXT NOT NULL,
        horario_execucao TEXT NOT NULL,
        situacao TEXT NOT NULL DEFAULT 'Pendente',
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tarefas_usuario ON tarefas(usuario_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE usuarios ADD COLUMN nome_usuario TEXT NOT NULL DEFAULT ''",
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE tarefas ADD COLUMN descricao_detalhada TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<void> deleteDatabase() async {
    await _ensureDatabaseFactory();
    await _database?.close();
    _database = null;

    final path = kIsWeb
        ? 'agenda_estudos.db'
        : join(await getDatabasesPath(), 'agenda_estudos.db');
    await databaseFactory.deleteDatabase(path);
  }

  Future<int> insertUsuario(Map<String, Object?> data) async {
    final db = await database;
    return db.insert('usuarios', data);
  }

  Future<int> insertTarefa(Map<String, Object?> data) async {
    final db = await database;
    return db.insert('tarefas', data);
  }

  Future<int> updateTarefa({
    required int id,
    required int usuarioId,
    required Map<String, Object?> data,
  }) async {
    final db = await database;
    return db.update(
      'tarefas',
      data,
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
    );
  }

  Future<int> deleteTarefa({required int id, required int usuarioId}) async {
    final db = await database;
    return db.delete(
      'tarefas',
      where: 'id = ? AND usuario_id = ?',
      whereArgs: [id, usuarioId],
    );
  }

  Future<Map<String, Object?>?> buscarUsuarioPorLogin(String login) async {
    final db = await database;
    final resultado = await db.query(
      'usuarios',
      where: 'email = ? OR nome_usuario = ?',
      whereArgs: [login, login],
      limit: 1,
    );
    return resultado.isEmpty ? null : resultado.first;
  }

  Future<List<Map<String, Object?>>> listarTarefasPorUsuario(
    int usuarioId,
  ) async {
    final db = await database;
    return db.query(
      'tarefas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'data_execucao ASC, horario_execucao ASC',
    );
  }
}

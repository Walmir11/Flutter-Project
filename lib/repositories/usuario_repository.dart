import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';

class CredenciaisInvalidasException implements Exception {
  const CredenciaisInvalidasException();

  @override
  String toString() => 'Usuário/e-mail ou senha inválidos.';
}

class UsuarioRepository {
  final AppDatabase _appDatabase;

  UsuarioRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<int> cadastrar({
    required String nomeUsuario,
    required String email,
    required String senha,
  }) async {
    try {
      return await _appDatabase.insertUsuario({
        'nome_usuario': nomeUsuario,
        'email': email,
        'senha': senha,
      });
    } on DatabaseException catch (erro) {
      if (erro.isUniqueConstraintError()) {
        throw Exception('Nome de usuário ou e-mail já cadastrado.');
      }
      rethrow;
    }
  }

  Future<Map<String, Object?>> autenticar({
    required String login,
    required String senha,
  }) async {
    final usuario = await _appDatabase.buscarUsuarioPorLogin(login.trim());
    if (usuario == null || usuario['senha'] != senha) {
      throw const CredenciaisInvalidasException();
    }
    return usuario;
  }
}

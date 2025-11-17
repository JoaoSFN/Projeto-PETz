import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('adocao.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // ⬅️ atualizei para 2 (necessário para alterar tabela)
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE adotantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        endereco TEXT NOT NULL,
        telefone TEXT NOT NULL,
        senha TEXT NOT NULL,
        isDoador INTEGER NOT NULL DEFAULT 0   -- ⬅️ ADICIONADO
      )
    ''');

    await db.execute('''
      CREATE TABLE animais (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade TEXT NOT NULL,
        raca TEXT NOT NULL,
        descricao TEXT NOT NULL,
        imagem TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'disponível'
      )
    ''');
  }

  // ⬅️ NECESSÁRIO PARA ATUALIZAR BANCO EXISTENTE
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("""
        ALTER TABLE adotantes ADD COLUMN isDoador INTEGER NOT NULL DEFAULT 0
      """);
    }
  }

  // ----------------------------------------------------------
  // ADOTANTES
  // ----------------------------------------------------------

  Future<int> insertAdotante(Map<String, dynamic> adotante) async {
    final db = await instance.database;
    return await db.insert(
      'adotantes',
      adotante,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> getAdotanteByCpf(String cpf) async {
    final db = await instance.database;
    final result = await db.query(
      'adotantes',
      where: 'cpf = ?',
      whereArgs: [cpf],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// 🔥 NOVO MÉTODO — retorna *todos* os dados, inclusive isDoador
  Future<Map<String, dynamic>?> autenticarAdotanteComTipo(String cpf, String senha) async {
    final db = await instance.database;
    final hashedSenha = hashPassword(senha);

    final result = await db.query(
      'adotantes',
      where: 'cpf = ? AND senha = ?',
      whereArgs: [cpf, hashedSenha],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first; // retorna o adotante completo
    }

    return null;
  }

  /// Método antigo — continua funcionando caso você ainda use
  Future<bool> autenticarAdotante(String cpf, String senha) async {
    final db = await instance.database;
    final hashedSenha = hashPassword(senha);
    final result = await db.query(
      'adotantes',
      where: 'cpf = ? AND senha = ?',
      whereArgs: [cpf, hashedSenha],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // ----------------------------------------------------------
  // ANIMAIS
  // ----------------------------------------------------------

  String hashPassword(String senha) {
    final bytes = utf8.encode(senha);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}

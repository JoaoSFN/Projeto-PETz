import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperAnimais {
  static final DatabaseHelperAnimais instance = DatabaseHelperAnimais._init();
  static Database? _database;

  DatabaseHelperAnimais._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('animais.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE animais(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade TEXT NOT NULL,
        raca TEXT NOT NULL,
        porte TEXT NOT NULL,
        peso TEXT,
        telefone TEXT NOT NULL,
        fotoPath TEXT
      )
    ''');
  }

  /// ATUALIZAÇÃO SEM APAGAR TABELA
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Garante que as colunas existam antes de usar
      await db.execute("ALTER TABLE animais ADD COLUMN porte TEXT");
      await db.execute("ALTER TABLE animais ADD COLUMN peso TEXT");
      await db.execute("ALTER TABLE animais ADD COLUMN telefone TEXT");
    }
  }

  /// INSERIR ANIMAL
  Future<int> insertAnimal(Map<String, dynamic> animal) async {
    final db = await instance.database;

    print("INSERT RECEBIDO: $animal");

    try {
      return await db.insert('animais', animal);
    } catch (e) {
      print("ERRO NO INSERT: $e");
      return -1;
    }
  }

  /// BUSCAR LISTA DE ANIMAIS
  Future<List<Map<String, dynamic>>> getAnimais() async {
    final db = await instance.database;
    return await db.query('animais', orderBy: 'id DESC');
  }

  /// ⭐ ATUALIZAR ANIMAL (NOVO!)
  Future<int> updateAnimal(Map<String, dynamic> animal) async {
    final db = await instance.database;

    return await db.update(
      'animais',
      animal,
      where: 'id = ?',
      whereArgs: [animal['id']],
    );
  }

  /// (OPCIONAL) EXCLUIR ANIMAL
  Future<int> deleteAnimal(int id) async {
    final db = await instance.database;
    return await db.delete('animais', where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async => _database ??= await _initDB('gelatte.db');

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, filePath), version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE vendas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      produto TEXT NOT NULL,
      valor REAL NOT NULL,
      data TEXT NOT NULL
    )''');
    await db.execute('''CREATE TABLE despesas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      descricao TEXT NOT NULL,
      categoria TEXT NOT NULL,
      valor REAL NOT NULL,
      data TEXT NOT NULL
    )''');
  }

  Future<int> inserirVenda({required String produto, required double valor}) async {
    final db = await database;
    return db.insert('vendas', {'produto': produto, 'valor': valor, 'data': DateTime.now().toIso8601String()});
  }

  Future<int> inserirDespesa({required String descricao, required String categoria, required double valor}) async {
    final db = await database;
    return db.insert('despesas', {'descricao': descricao, 'categoria': categoria, 'valor': valor, 'data': DateTime.now().toIso8601String()});
  }

  Future<List<Map<String, dynamic>>> buscarVendas() async {
    final db = await database;
    return db.query('vendas', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> buscarDespesas() async {
    final db = await database;
    return db.query('despesas', orderBy: 'id DESC');
  }

  Future<void> limparBanco() async {
    final db = await database;
    await db.delete('vendas');
    await db.delete('despesas');
  }
}

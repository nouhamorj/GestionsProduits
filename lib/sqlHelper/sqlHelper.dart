import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static const String _databaseName = 'produits.db';
  static const String _tableName = 'produits';
  static Database? _database;

  // Initialize database at the start of the application
  static Future<void> initDatabase() async {
    if (_database != null) return;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL
          )
        ''');
      },
    );
  }

  // Method to insert a new product
  static Future<void> insertProduct(Product product) async {
    if (_database == null) await initDatabase();
    await _database!.insert(_tableName, product.toMap());
  }

  // Method to get all products
  static Future<List<Product>> getAllProducts() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Method to update an existing product
  static Future<void> updateProduct(Product product) async {
    await initDatabase();
    await _database!.update(
      _tableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Method to delete a product
  static Future<void> deleteProduct(int id) async {
    await initDatabase();
    await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}

class Product {
  final int? id;
  final String name;
  final double price;

  const Product({
    this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    int? id;
    if (map['id'] != 0) {
      id = map['id'] as int;
    }
    return Product(
      id: id,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }
}
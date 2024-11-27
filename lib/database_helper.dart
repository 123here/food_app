import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE order_plan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        food_items TEXT NOT NULL,
        total_cost REAL NOT NULL,
        target_cost REAL NOT NULL
      )
    ''');

    // Insert initial food items
    await _insertInitialFoodItems(db);
  }

  Future<void> _insertInitialFoodItems(Database db) async {
    List<Map<String, dynamic>> initialFoodItems = [
      {'name': 'HotDog', 'cost': 10.0},
      {'name': 'Burger', 'cost': 7.0},
      {'name': 'Pasta', 'cost': 12.0},
      {'name': 'Sushi', 'cost': 15.0},
      {'name': 'Salad', 'cost': 5.0},
      {'name': 'CheeseCake', 'cost': 3.0},
      {'name': 'Ice Cream', 'cost': 4.0},
      {'name': 'Steak', 'cost': 20.0},
      {'name': 'Sandwich', 'cost': 6.0},
      {'name': 'Soup', 'cost': 8.0},
      {'name': 'Curry', 'cost': 9.0},
      {'name': 'Biryani', 'cost': 11.0},
      {'name': 'Rice Bowl', 'cost': 10.0},
      {'name': 'Pancakes', 'cost': 7.0},
      {'name': 'Waffles', 'cost': 6.0},
      {'name': 'Dumplings', 'cost': 8.0},
      {'name': 'Chow Mein', 'cost': 12.0},
      {'name': 'Biryani', 'cost': 14.0},
      {'name': 'Lasagna', 'cost': 13.0},
      {'name': 'Ramen', 'cost': 10.0},
    ];

    for (var foodItem in initialFoodItems) {
      await db.insert('food_items', foodItem);
    }
  }

  // Fetch all food items
  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await instance.database;
    return await db.query('food_items');
  }

  // Add an order plan
  Future<int> addOrderPlan(
      String date, String foodItems, double totalCost) async {
    final db = await instance.database;
    return await db.insert('order_plan', {
      'date': date,
      'food_items': foodItems,
      'total_cost': totalCost,
    });
  }

  // Query order plan by date
  Future<List<Map<String, dynamic>>> getOrderPlanByDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'order_plan',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // Add, Delete, Update Food Items
  Future<int> addFoodItem(String name, double cost) async {
    final db = await instance.database;
    return await db.insert('food_items', {'name': name, 'cost': cost});
  }

  Future<int> deleteFoodItem(int id) async {
    final db = await instance.database;
    return await db.delete('food_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFoodItem(int id, String name, double cost) async {
    final db = await instance.database;
    return await db.update(
      'food_items',
      {'name': name, 'cost': cost},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteOrderPlan(int id) async {
    final db = await instance.database;
    return await db.delete('order_plan', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateOrderPlan(
      int id, String date, String foodItems, double totalCost) async {
    final db = await instance.database;
    return await db.update(
      'order_plan',
      {
        'date': date,
        'food_items': foodItems,
        'total_cost': totalCost,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFoodItemPrice(int id, double newPrice) async {
    final db = await database;
    await db.update(
      'food_items',
      {'cost': newPrice},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> deleteFoodItemPrice(int id) async {
    final db = await database;
    await db.delete(
      'food_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


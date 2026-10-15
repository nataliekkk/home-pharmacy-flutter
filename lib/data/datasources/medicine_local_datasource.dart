import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/intake_log.dart';

class MedicineLocalDataSource {
  static final MedicineLocalDataSource instance = MedicineLocalDataSource._init();
  static Database? _database;

  MedicineLocalDataSource._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pharmacy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // ← увеличили версию из-за новых полей
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        active_substance TEXT NOT NULL,
        production_date TEXT NOT NULL,
        expiration_date TEXT NOT NULL,
        form TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        dosage TEXT NOT NULL,
        intake_rules TEXT NOT NULL,
        instruction TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE intake_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER NOT NULL,
        intake_time TEXT NOT NULL,
        dosage TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE
      )
    ''');

    await _seedDatabase(db);
  }

  // Миграция при обновлении с версии 1 на 2
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE medicines ADD COLUMN dosage TEXT NOT NULL DEFAULT "По назначению врача"');
      await db.execute('ALTER TABLE medicines ADD COLUMN intake_rules TEXT NOT NULL DEFAULT "Согласно инструкции"');
      await db.execute('ALTER TABLE medicines ADD COLUMN instruction TEXT NOT NULL DEFAULT "Подробная инструкция отсутствует"');
    }
  }

  Future<void> _seedDatabase(Database db) async {
    final now = DateTime.now();

    final initialMedicines = [
      Medicine(
        name: 'Парацетамол',
        activeSubstance: 'Парацетамол',
        productionDate: now.subtract(const Duration(days: 100)),
        expirationDate: now.add(const Duration(days: 15)),
        form: MedicineForm.pill,
        quantity: 20,
        dosage: '500 мг',
        intakeRules: 'По 1 таблетке 3–4 раза в сутки. Не более 4 г в сутки.',
        instruction: 'Применяется при головной боли, зубной боли, повышенной температуре. Не принимать более 5 дней без консультации врача.',
      ),
      Medicine(
        name: 'Ибупрофен',
        activeSubstance: 'Ибупрофен',
        productionDate: now.subtract(const Duration(days: 60)),
        expirationDate: now.add(const Duration(days: 200)),
        form: MedicineForm.pill,
        quantity: 10,
        dosage: '200–400 мг',
        intakeRules: 'По 1 таблетке 3 раза в сутки после еды.',
        instruction: 'Нестероидный противовоспалительный препарат. С осторожностью при заболеваниях ЖКТ.',
      ),
      Medicine(
        name: 'Амброксол',
        activeSubstance: 'Амброксол',
        productionDate: now.subtract(const Duration(days: 180)),
        expirationDate: now.add(const Duration(days: 365)),
        form: MedicineForm.syrup,
        quantity: 1,
        dosage: '30 мг / 5 мл',
        intakeRules: 'По 10 мл 2–3 раза в сутки.',
        instruction: 'Муколитическое средство. Способствует разжижению и отхождению мокроты.',
      ),
      Medicine(
        name: 'Називин',
        activeSubstance: 'Оксиметазолин',
        productionDate: now.subtract(const Duration(days: 400)),
        expirationDate: now.subtract(const Duration(days: 5)),
        form: MedicineForm.drops,
        quantity: 1,
        dosage: '0,05%',
        intakeRules: 'По 1–2 капли в каждый носовой ход 2–3 раза в сутки.',
        instruction: 'Сосудосуживающие капли. Не использовать более 5–7 дней подряд.',
      ),
    ];

    for (var med in initialMedicines) {
      await db.insert('medicines', _medicineToMap(med));
    }
  }

  // --- Маппинг Entity ↔ Map ---

  Map<String, dynamic> _medicineToMap(Medicine medicine) {
    return {
      'id': medicine.id,
      'name': medicine.name,
      'active_substance': medicine.activeSubstance,
      'production_date': medicine.productionDate.toIso8601String(),
      'expiration_date': medicine.expirationDate.toIso8601String(),
      'form': medicine.form.name,
      'quantity': medicine.quantity,
      'dosage': medicine.dosage,
      'intake_rules': medicine.intakeRules,
      'instruction': medicine.instruction,
    };
  }

  Medicine _medicineFromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int?,
      name: map['name'] as String,
      activeSubstance: map['active_substance'] as String? ?? '',
      productionDate: DateTime.parse(map['production_date'] as String),
      expirationDate: DateTime.parse(map['expiration_date'] as String),
      form: MedicineForm.values.byName(map['form'] as String),
      quantity: map['quantity'] as int? ?? 1,
      dosage: map['dosage'] as String? ?? 'По назначению врача',
      intakeRules: map['intake_rules'] as String? ?? 'Согласно инструкции',
      instruction: map['instruction'] as String? ?? 'Подробная инструкция отсутствует',
    );
  }

  Map<String, dynamic> _intakeLogToMap(IntakeLog log) {
    return {
      'id': log.id,
      'medicine_id': log.medicineId,
      'intake_time': log.intakeTime.toIso8601String(),
      'dosage': log.dosage,
      'note': log.note,
    };
  }

  // --- Публичные методы ---

  Future<List<Medicine>> getAllMedicines() async {
    final db = await database;
    final result = await db.query('medicines');
    return result.map((map) => _medicineFromMap(map)).toList();
  }

  Future<int> updateQuantity(int medicineId, int newQuantity) async {
    final db = await database;
    return await db.update(
      'medicines',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [medicineId],
    );
  }

  Future<int> logIntake(IntakeLog log) async {
    final db = await database;
    return await db.insert('intake_logs', _intakeLogToMap(log));
  }

  Future<int> addMedicine(Medicine medicine) async {
    final db = await database;
    return await db.insert('medicines', _medicineToMap(medicine));
  }
}
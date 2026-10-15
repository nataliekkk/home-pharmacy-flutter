import '../../domain/entities/medicine.dart';

class MockScanResult {
  final String imagePath;
  final Medicine medicine;

  const MockScanResult({
    required this.imagePath,
    required this.medicine,
  });
}

class MockScannerDataSource {
  List<MockScanResult> getMockScanResults() {
    final now = DateTime.now();

    return [
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_nurofen.png',
        medicine: Medicine(
          name: 'Нурофен',
          activeSubstance: 'Ибупрофен',
          productionDate: now.subtract(const Duration(days: 90)),
          expirationDate: now.add(const Duration(days: 400)),
          form: MedicineForm.pill,
          quantity: 12,
          dosage: '200 мг',
          intakeRules: 'По 1 таблетке 3 раза в сутки после еды',
          instruction: 'Обезболивающее и жаропонижающее средство. Не применять при язве желудка.',
        ),
      ),
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_citramon.png',
        medicine: Medicine(
          name: 'Цитрамон',
          activeSubstance: 'Парацетамол + Кофеин + Аспирин',
          productionDate: now.subtract(const Duration(days: 120)),
          expirationDate: now.add(const Duration(days: 300)),
          form: MedicineForm.pill,
          quantity: 10,
          dosage: '1 таблетка',
          intakeRules: 'По 1 таблетке при головной боли',
          instruction: 'Комбинированный препарат. С осторожностью при повышенном давлении.',
        ),
      ),
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_loratadine.png',
        medicine: Medicine(
          name: 'Лоратадин',
          activeSubstance: 'Лоратадин',
          productionDate: now.subtract(const Duration(days: 60)),
          expirationDate: now.add(const Duration(days: 500)),
          form: MedicineForm.pill,
          quantity: 10,
          dosage: '10 мг',
          intakeRules: 'По 1 таблетке 1 раз в сутки',
          instruction: 'Антигистаминный препарат. Не вызывает сонливости.',
        ),
      ),
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_strepsils.png',
        medicine: Medicine(
          name: 'Стрепсилс',
          activeSubstance: 'Амилметакрезол + Дихлорбензиловый спирт',
          productionDate: now.subtract(const Duration(days: 30)),
          expirationDate: now.add(const Duration(days: 600)),
          form: MedicineForm.pill,
          quantity: 24,
          dosage: '1 таблетка для рассасывания',
          intakeRules: 'Каждые 2–3 часа, не более 8 таблеток в сутки',
          instruction: 'Антисептик для горла. Не применять детям до 6 лет.',
        ),
      ),
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_suprastin.png',
        medicine: Medicine(
          name: 'Супрастин',
          activeSubstance: 'Хлоропирамин',
          productionDate: now.subtract(const Duration(days: 200)),
          expirationDate: now.add(const Duration(days: 250)),
          form: MedicineForm.pill,
          quantity: 20,
          dosage: '25 мг',
          intakeRules: 'По 1 таблетке 3–4 раза в сутки',
          instruction: 'Антигистаминный препарат первого поколения. Может вызывать сонливость.',
        ),
      ),
      MockScanResult(
        imagePath: 'assets/images/barcodes/barcode_codeine.png',
        medicine: Medicine(
          name: 'Кодеин',
          activeSubstance: 'Кодеин',
          productionDate: now.subtract(const Duration(days: 150)),
          expirationDate: now.add(const Duration(days: 350)),
          form: MedicineForm.pill,
          quantity: 10,
          dosage: '15 мг',
          intakeRules: 'По 1 таблетке 3–4 раза в сутки. Не более 4 таблеток в сутки.',
          instruction: 'Опиоидный анальгетик и противокашлевое средство. Может вызывать привыкание. Не применять без назначения врача.',
        ),
      ),
    ];
  }
}

enum MedicineForm { pill, syrup, drops, ointment }

extension MedicineFormExtension on MedicineForm {
  String get displayName {
    switch (this) {
      case MedicineForm.pill:
        return 'Таблетки';
      case MedicineForm.syrup:
        return 'Сироп';
      case MedicineForm.drops:
        return 'Капли';
      case MedicineForm.ointment:
        return 'Мазь';
    }
  }
}

class Medicine {
  final int? id;
  final String name;
  final String activeSubstance;
  final DateTime productionDate;
  final DateTime expirationDate;
  final MedicineForm form;
  final int quantity;

  // Новые поля для детальной карточки (Лабораторная работа №2)
  final String dosage;           // Дозировка
  final String intakeRules;      // Правила приёма
  final String instruction;      // Текстовая инструкция

  const Medicine({
    this.id,
    required this.name,
    required this.activeSubstance,
    required this.productionDate,
    required this.expirationDate,
    required this.form,
    this.quantity = 1,
    this.dosage = 'По назначению врача',
    this.intakeRules = 'Согласно инструкции',
    this.instruction = 'Подробная инструкция отсутствует',
  });

  bool get isExpired => DateTime.now().isAfter(expirationDate);

  bool get isExpiringSoon =>
      expirationDate.difference(DateTime.now()).inDays <= 30 && !isExpired;

  Medicine copyWith({
    int? id,
    String? name,
    String? activeSubstance,
    DateTime? productionDate,
    DateTime? expirationDate,
    MedicineForm? form,
    int? quantity,
    String? dosage,
    String? intakeRules,
    String? instruction,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      activeSubstance: activeSubstance ?? this.activeSubstance,
      productionDate: productionDate ?? this.productionDate,
      expirationDate: expirationDate ?? this.expirationDate,
      form: form ?? this.form,
      quantity: quantity ?? this.quantity,
      dosage: dosage ?? this.dosage,
      intakeRules: intakeRules ?? this.intakeRules,
      instruction: instruction ?? this.instruction,
    );
  }
}
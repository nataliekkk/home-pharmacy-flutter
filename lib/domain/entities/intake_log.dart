class IntakeLog {
  final int? id;
  final int medicineId;
  final DateTime intakeTime;
  final String dosage;
  final String? note;

  const IntakeLog({
    this.id,
    required this.medicineId,
    required this.intakeTime,
    required this.dosage,
    this.note,
  });
}
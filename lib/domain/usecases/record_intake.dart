import '../entities/intake_log.dart';
import '../entities/medicine.dart';
import '../repositories/medicine_repository.dart';

class RecordIntake {
  final MedicineRepository repository;

  RecordIntake(this.repository);

  Future<void> call(Medicine medicine, String dosage) async {
    if (medicine.id == null || medicine.quantity <= 0) return;

    await repository.logIntake(IntakeLog(
      medicineId: medicine.id!,
      intakeTime: DateTime.now(),
      dosage: dosage,
    ));

    await repository.updateQuantity(medicine.id!, medicine.quantity - 1);
  }
}
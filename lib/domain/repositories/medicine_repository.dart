import '../entities/medicine.dart';
import '../entities/intake_log.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getAllMedicines();
  Future<void> updateQuantity(int medicineId, int newQuantity);
  Future<void> logIntake(IntakeLog log);
  Future<void> addMedicine(Medicine medicine); // ← новый метод
}
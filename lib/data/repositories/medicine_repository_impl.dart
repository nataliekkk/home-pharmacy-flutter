import '../../domain/entities/medicine.dart';
import '../../domain/entities/intake_log.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource localDataSource;

  MedicineRepositoryImpl(this.localDataSource);

  @override
  Future<List<Medicine>> getAllMedicines() {
    return localDataSource.getAllMedicines();
  }

  @override
  Future<void> updateQuantity(int medicineId, int newQuantity) {
    return localDataSource.updateQuantity(medicineId, newQuantity);
  }

  @override
  Future<void> logIntake(IntakeLog log) {
    return localDataSource.logIntake(log);
  }

  @override
  Future<void> addMedicine(Medicine medicine) {
    return localDataSource.addMedicine(medicine);
  }
}
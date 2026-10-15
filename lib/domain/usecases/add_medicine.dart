import '../entities/medicine.dart';
import '../repositories/medicine_repository.dart';

class AddMedicine {
  final MedicineRepository repository;

  AddMedicine(this.repository);

  Future<void> call(Medicine medicine) {
    return repository.addMedicine(medicine);
  }
}
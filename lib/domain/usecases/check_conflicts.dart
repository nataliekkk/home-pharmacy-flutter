import '../entities/medicine.dart';
import '../repositories/interaction_repository.dart';

class CheckConflicts {
  final InteractionRepository repository;

  CheckConflicts(this.repository);

  List<String> call(List<Medicine> medicines) {
    return repository.checkConflicts(medicines);
  }
}
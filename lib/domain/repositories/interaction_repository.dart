import '../entities/substance_interaction.dart';
import '../entities/medicine.dart';

abstract class InteractionRepository {
  Future<void> loadInteractions();
  List<String> checkConflicts(List<Medicine> medicines);
}
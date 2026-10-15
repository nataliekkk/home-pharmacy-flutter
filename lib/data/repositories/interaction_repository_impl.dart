import '../../domain/entities/medicine.dart';
import '../../domain/repositories/interaction_repository.dart';
import '../datasources/interaction_local_datasource.dart';

class InteractionRepositoryImpl implements InteractionRepository {
  final InteractionLocalDataSource localDataSource;

  InteractionRepositoryImpl(this.localDataSource);

  @override
  Future<void> loadInteractions() {
    return localDataSource.loadInteractions();
  }

  @override
  List<String> checkConflicts(List<Medicine> medicines) {
    return localDataSource.checkConflicts(medicines);
  }
}
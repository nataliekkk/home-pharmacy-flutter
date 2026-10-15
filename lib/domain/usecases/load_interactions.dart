import '../repositories/interaction_repository.dart';

class LoadInteractions {
  final InteractionRepository repository;

  LoadInteractions(this.repository);

  Future<void> call() {
    return repository.loadInteractions();
  }
}
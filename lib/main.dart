import 'package:flutter/material.dart';

// Domain - Use Cases
import 'domain/usecases/get_medicines.dart';
import 'domain/usecases/check_conflicts.dart';
import 'domain/usecases/record_intake.dart';
import 'domain/usecases/load_interactions.dart';
import 'domain/usecases/add_medicine.dart';

// Data - Data Sources
import 'data/datasources/medicine_local_datasource.dart';
import 'data/datasources/interaction_local_datasource.dart';

// Data - Repositories
import 'data/repositories/medicine_repository_impl.dart';
import 'data/repositories/interaction_repository_impl.dart';

// Presentation
import 'presentation/viewmodels/medicine_viewmodel.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ========== Сборка зависимостей (Composition Root) ==========

  // 1. Data Sources
  final medicineLocalDataSource = MedicineLocalDataSource.instance;
  final interactionLocalDataSource = InteractionLocalDataSource();

  // 2. Repositories
  final medicineRepository = MedicineRepositoryImpl(medicineLocalDataSource);
  final interactionRepository = InteractionRepositoryImpl(interactionLocalDataSource);

  // 3. Use Cases
  final getMedicines = GetMedicines(medicineRepository);
  final checkConflicts = CheckConflicts(interactionRepository);
  final recordIntake = RecordIntake(medicineRepository);
  final loadInteractions = LoadInteractions(interactionRepository);
  final addMedicine = AddMedicine(medicineRepository);

  // 4. ViewModel
  final viewModel = MedicineViewModel(
    getMedicines: getMedicines,
    checkConflicts: checkConflicts,
    recordIntake: recordIntake,
    loadInteractions: loadInteractions,
    addMedicine: addMedicine,
  );

  runApp(MedicineApp(viewModel: viewModel));
}

class MedicineApp extends StatelessWidget {
  final MedicineViewModel viewModel;

  const MedicineApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Домашняя аптечка',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: MainScreen(viewModel: viewModel),
    );
  }
}
import 'package:flutter/foundation.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/usecases/get_medicines.dart';
import '../../domain/usecases/check_conflicts.dart';
import '../../domain/usecases/record_intake.dart';
import '../../domain/usecases/load_interactions.dart';
import '../../domain/usecases/add_medicine.dart';

class MedicineViewModel extends ChangeNotifier {
  final GetMedicines getMedicines;
  final CheckConflicts checkConflicts;
  final RecordIntake recordIntake;
  final LoadInteractions loadInteractions;
  final AddMedicine addMedicine;

  MedicineViewModel({
    required this.getMedicines,
    required this.checkConflicts,
    required this.recordIntake,
    required this.loadInteractions,
    required this.addMedicine,          // ← добавили
  });

  // --- Состояние ---
  List<Medicine> _allMedicines = [];
  List<String> _detectedConflicts = [];
  bool _isLoading = true;
  MedicineForm? _selectedFilter;
  bool _isSortedByCriticalDate = false;

  // --- Геттеры ---
  bool get isLoading => _isLoading;
  MedicineForm? get selectedFilter => _selectedFilter;
  bool get isSortedByCriticalDate => _isSortedByCriticalDate;
  List<String> get detectedConflicts => _detectedConflicts;

  List<Medicine> get displayedMedicines {
    List<Medicine> result = List.from(_allMedicines);

    if (_selectedFilter != null) {
      result = result.where((m) => m.form == _selectedFilter).toList();
    }

    if (_isSortedByCriticalDate) {
      result.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    }

    return result;
  }

  // --- Инициализация ---
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await loadInteractions();
    await _loadMedicines();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadMedicines() async {
    _allMedicines = await getMedicines();
    _detectedConflicts = checkConflicts(_allMedicines);
    notifyListeners();
  }

  // --- Действия пользователя ---
  void setFilter(MedicineForm? form) {
    _selectedFilter = form;
    notifyListeners();
  }

  void toggleSort() {
    _isSortedByCriticalDate = !_isSortedByCriticalDate;
    notifyListeners();
  }

  Future<void> recordMedicineIntake(Medicine medicine, String dosage) async {
    await recordIntake(medicine, dosage);
    await _loadMedicines(); // обновляем список после списания
  }

  Future<void> addNewMedicine(Medicine medicine) async {
    await addMedicine(medicine);
    await _loadMedicines(); // обновляем список
  }
}
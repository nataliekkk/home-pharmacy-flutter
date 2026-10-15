import 'package:flutter/material.dart';
import '../../domain/entities/medicine.dart';
import '../../data/datasources/mock_scanner_datasource.dart';
import '../viewmodels/medicine_viewmodel.dart';

class ScanMedicineScreen extends StatelessWidget {
  final MedicineViewModel viewModel;

  const ScanMedicineScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final mockResults = MockScannerDataSource().getMockScanResults();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканирование лекарства'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Имитация области камеры
          Container(
            width: double.infinity,
            height: 160,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal, width: 2),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 56, color: Colors.white70),
                SizedBox(height: 10),
                Text(
                  'Режим эмулятора\nНажмите на штрихкод для распознавания',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Обнаруженные штрихкоды (mock):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: mockResults.length,
              itemBuilder: (context, index) {
                final result = mockResults[index];
                final medicine = result.medicine;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await viewModel.addNewMedicine(medicine);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('«${medicine.name}» добавлен в аптечку'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Картинка штрихкода
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              result.imagePath,
                              width: 120,
                              height: 70,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 120,
                                  height: 70,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.qr_code_2, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Информация о препарате
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicine.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  medicine.activeSubstance,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  medicine.form.displayName,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.add_circle, color: Colors.teal, size: 32),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

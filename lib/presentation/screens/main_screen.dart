import 'package:flutter/material.dart';
import '../../domain/entities/medicine.dart';
import '../viewmodels/medicine_viewmodel.dart';
import 'medicine_detail_screen.dart';
import 'scan_medicine_screen.dart';

class MainScreen extends StatefulWidget {
  final MedicineViewModel viewModel;

  const MainScreen({super.key, required this.viewModel});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MedicineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.init();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final medicines = _viewModel.displayedMedicines;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Домашняя аптечка'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanMedicineScreen(viewModel: _viewModel),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Сканировать'),
          ),
          body: Column(
            children: [
              if (_viewModel.detectedConflicts.isNotEmpty)
                _buildConflictWarningBanner(),
              _buildControlPanel(),
              Expanded(
                child: medicines.isEmpty
                    ? const Center(
                  child: Text('Нет лекарств по заданным критериям'),
                )
                    : ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    return _buildMedicineCard(context, medicines[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConflictWarningBanner() {
    return Container(
      width: double.infinity,
      color: Colors.red.shade100,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Конфликт препаратов (Матрица несовместимости):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ..._viewModel.detectedConflicts.map(
                (msg) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                msg,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<MedicineForm?>(
            value: _viewModel.selectedFilter,
            hint: const Text('Все формы'),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Все формы'),
              ),
              ...MedicineForm.values.map((form) {
                return DropdownMenuItem(
                  value: form,
                  child: Text(form.displayName),
                );
              }),
            ],
            onChanged: (value) => _viewModel.setFilter(value),
          ),
          FilterChip(
            label: const Text('Сначала критичные'),
            selected: _viewModel.isSortedByCriticalDate,
            onSelected: (_) => _viewModel.toggleSort(),
            selectedColor: Colors.red.shade100,
            checkmarkColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, Medicine medicine) {
    Color cardColor = Colors.white;
    Color textColor = Colors.black87;
    IconData statusIcon = Icons.check_circle;
    Color iconColor = Colors.green;

    if (medicine.isExpired) {
      cardColor = Colors.red.shade50;
      textColor = Colors.red.shade900;
      statusIcon = Icons.error;
      iconColor = Colors.red;
    } else if (medicine.isExpiringSoon) {
      cardColor = Colors.orange.shade50;
      statusIcon = Icons.warning;
      iconColor = Colors.orange.shade800;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: cardColor,
      elevation: 2,
        child: InkWell(                    // ← добавляем возможность нажатия
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicineDetailScreen(medicine: medicine),
              ),
            );
          },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(statusIcon, color: iconColor, size: 36),
        title: Text(
          medicine.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Действующее вещество: ${medicine.activeSubstance}'),
            Text(
              'Форма: ${medicine.form.displayName} | Остаток: ${medicine.quantity} шт.',
            ),
            Text('Произведено: ${_formatDate(medicine.productionDate)}'),
            Text(
              'Годен до: ${_formatDate(medicine.expirationDate)}',
              style: TextStyle(
                color: medicine.isExpired || medicine.isExpiringSoon
                    ? iconColor
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: 'Списать 1 шт. и записать в журнал',
          icon: const Icon(Icons.medication),
          onPressed: medicine.quantity > 0
              ? () async {
            await _viewModel.recordMedicineIntake(medicine, '1 шт.');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Приём «${medicine.name}» занесён в журнал'),
                ),
              );
            }
          }
              : null,
        ),
      ),
     ),
    );
  }
}
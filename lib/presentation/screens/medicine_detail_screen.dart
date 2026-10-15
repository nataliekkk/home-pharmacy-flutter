import 'package:flutter/material.dart';
import '../../domain/entities/medicine.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({
    super.key,
    required this.medicine,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = medicine.isExpired;
    final isExpiringSoon = medicine.isExpiringSoon;

    Color statusColor = Colors.green;
    String statusText = 'В норме';
    IconData statusIcon = Icons.check_circle;

    if (isExpired) {
      statusColor = Colors.red;
      statusText = 'Просрочен';
      statusIcon = Icons.error;
    } else if (isExpiringSoon) {
      statusColor = Colors.orange;
      statusText = 'Истекает срок годности';
      statusIcon = Icons.warning;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статус
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Основная информация
            _buildSectionTitle('Основная информация'),
            _buildInfoCard([
              _buildInfoRow('Действующее вещество', medicine.activeSubstance),
              _buildInfoRow('Форма выпуска', medicine.form.displayName),
              _buildInfoRow('Остаток', '${medicine.quantity} шт.'),
              _buildInfoRow('Произведено', _formatDate(medicine.productionDate)),
              _buildInfoRow('Годен до', _formatDate(medicine.expirationDate)),
            ]),

            const SizedBox(height: 20),

            // Дозировка и правила приёма
            _buildSectionTitle('Дозировка и приём'),
            _buildInfoCard([
              _buildInfoRow('Дозировка', medicine.dosage),
              _buildInfoRow('Правила приёма', medicine.intakeRules),
            ]),

            const SizedBox(height: 20),

            // Инструкция
            _buildSectionTitle('Инструкция'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                medicine.instruction,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
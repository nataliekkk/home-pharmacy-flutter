import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/substance_interaction.dart';
import '../../domain/entities/medicine.dart';

class InteractionLocalDataSource {
  List<SubstanceInteraction> _interactions = [];

  Future<void> loadInteractions() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/substance_interactions.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      _interactions = jsonList.map((item) {
        return SubstanceInteraction(
          id: item['id'] as String,
          substanceA: item['substanceA'] as String,
          substanceB: item['substanceB'] as String,
          threatDescription: item['threatDescription'] as String,
        );
      }).toList();
    } catch (e) {
      // В реальном проекте лучше логировать
      _interactions = [];
    }
  }

  List<String> checkConflicts(List<Medicine> medicines) {
    final warnings = <String>[];
    final activeSubstances = medicines
        .map((m) => m.activeSubstance.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toSet();

    for (var interaction in _interactions) {
      final subA = interaction.substanceA.trim().toLowerCase();
      final subB = interaction.substanceB.trim().toLowerCase();

      if (activeSubstances.contains(subA) && activeSubstances.contains(subB)) {
        warnings.add(
          'Конфликт: "${interaction.substanceA}" и "${interaction.substanceB}".\n${interaction.threatDescription}',
        );
      }
    }

    return warnings;
  }
}
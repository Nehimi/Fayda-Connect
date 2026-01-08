import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final checklistProvider = StateNotifierProvider<ChecklistNotifier, Map<String, List<int>>>((ref) {
  return ChecklistNotifier();
});

class ChecklistNotifier extends StateNotifier<Map<String, List<int>>> {
  ChecklistNotifier() : super({}) {
    _loadProgress();
  }

  static const String _storageKey = 'service_checklist_progress';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_storageKey);
    if (encoded != null) {
      final Map<String, List<int>> map = {};
      for (var item in encoded) {
        final split = item.split(':');
        if (split.length == 2) {
          map[split[0]] = split[1].split(',').map(int.parse).toList();
        }
      }
      state = map;
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = state.entries.map((e) {
      return '${e.key}:${e.value.join(',')}';
    }).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  void toggleStep(String serviceId, int stepIndex) {
    final currentSteps = state[serviceId] ?? [];
    if (currentSteps.contains(stepIndex)) {
      currentSteps.remove(stepIndex);
    } else {
      currentSteps.add(stepIndex);
    }
    state = {...state, serviceId: [...currentSteps]};
    _saveProgress();
  }

  bool isStepCompleted(String serviceId, int stepIndex) {
    return state[serviceId]?.contains(stepIndex) ?? false;
  }

  double getProgress(String serviceId, int totalSteps) {
    if (totalSteps == 0) return 0;
    final completedCount = state[serviceId]?.length ?? 0;
    return completedCount / totalSteps;
  }
}

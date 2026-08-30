import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/domain/entities/history_item.dart';
import 'package:calculator_app/domain/repositories/i_history_repository.dart';

final historyRepositoryProvider = Provider<IHistoryRepository>((ref) {
  throw UnimplementedError('Repository not injected yet');
});

final historyProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<HistoryItem>>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<HistoryItem>>> {
  final IHistoryRepository _repository;

  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final items = await _repository.getHistory();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHistory(HistoryItem item) async {
    await _repository.addHistoryItem(item);
    await _loadHistory(); // Reload to maintain correct order and limit
  }

  Future<void> deleteHistory(String id) async {
    await _repository.deleteHistoryItem(id);
    await _loadHistory();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    state = const AsyncValue.data([]);
  }
}

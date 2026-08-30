import 'package:hive/hive.dart';
import 'package:calculator_app/domain/entities/history_item.dart';
import 'package:calculator_app/domain/repositories/i_history_repository.dart';

class HiveHistoryRepository implements IHistoryRepository {
  static const String _boxName = 'history_box';
  static const int _maxHistoryItems = 500;

  Box<HistoryItem>? _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<HistoryItem>(_boxName);
    } else {
      _box = Hive.box<HistoryItem>(_boxName);
    }
  }

  @override
  Future<List<HistoryItem>> getHistory() async {
    if (_box == null) await init();
    final items = _box!.values.toList();
    // Sort descending by timestamp
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    if (_box == null) await init();
    
    await _box!.put(item.id, item);

    // Limit enforcement
    if (_box!.length > _maxHistoryItems) {
      final items = await getHistory();
      final toRemove = items.sublist(_maxHistoryItems);
      for (var oldItem in toRemove) {
        await _box!.delete(oldItem.id);
      }
    }
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    if (_box == null) await init();
    await _box!.delete(id);
  }

  @override
  Future<void> clearHistory() async {
    if (_box == null) await init();
    await _box!.clear();
  }
}

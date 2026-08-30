import 'package:calculator_app/domain/entities/history_item.dart';

abstract class IHistoryRepository {
  Future<void> init();
  Future<List<HistoryItem>> getHistory();
  Future<void> addHistoryItem(HistoryItem item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();
}

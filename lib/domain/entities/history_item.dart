class HistoryItem {
  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  HistoryItem copyWith({
    String? id,
    String? expression,
    String? result,
    DateTime? timestamp,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

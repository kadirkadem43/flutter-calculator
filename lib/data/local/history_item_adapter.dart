import 'package:hive/hive.dart';
import 'package:calculator_app/domain/entities/history_item.dart';

class HistoryItemAdapter extends TypeAdapter<HistoryItem> {
  @override
  final int typeId = 0;

  @override
  HistoryItem read(BinaryReader reader) {
    return HistoryItem(
      id: reader.readString(),
      expression: reader.readString(),
      result: reader.readString(),
      timestamp: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.expression);
    writer.writeString(obj.result);
    writer.writeString(obj.timestamp.toIso8601String());
  }
}

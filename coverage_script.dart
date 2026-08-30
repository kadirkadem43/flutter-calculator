import 'dart:io';
void main() {
  var lines = File('coverage/lcov.info').readAsLinesSync();
  var totalLF = 0, totalLH = 0;
  var fileLF = 0, fileLH = 0;
  var currentFile = '';
  for (var line in lines) {
    if (line.startsWith('SF:')) currentFile = line.substring(3);
    else if (line.startsWith('LF:')) {
      fileLF = int.parse(line.substring(3));
      totalLF += fileLF;
    } else if (line.startsWith('LH:')) {
      fileLH = int.parse(line.substring(3));
      totalLH += fileLH;
      print('$currentFile: ${(fileLH/fileLF*100).toStringAsFixed(2)}%');
    }
  }
  print('TOTAL: ${(totalLH/totalLF*100).toStringAsFixed(2)}%');
}

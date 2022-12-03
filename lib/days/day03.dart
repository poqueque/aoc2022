import '../extensions/extensions.dart';
import '../main.dart';

class Day03 extends Day {
  @override
  bool get completed => true;

  @override
  part1() {
    var dupSum = 0;
    inputList.forEach((element) {
      var r1 = element.substring(0, element.length ~/ 2);
      var r2 = element.substring(element.length ~/ 2);

      var dup = "";
      for (var c1 in r1.chars) {
        if (r2.contains(c1)) dup = c1;
      }
      var priority = dup.toUpperCase().runes.first - 64;
      if (dup.toUpperCase() == dup) priority += 26;
      print("$dup: $priority");
      dupSum += priority;
    });
    return dupSum;
  }

  @override
  part2() {
    var dupSum = 0;
    for (int i = 0; i < inputList.length; i += 3) {
      var r1 = inputList[i];
      var r2 = inputList[i + 1];
      var r3 = inputList[i + 2];
      var dup = "";
      for (var c1 in r1.chars) {
        if (r2.contains(c1) && r3.contains(c1)) dup = c1;
      }
      var priority = dup.toUpperCase().runes.first - 64;
      if (dup.toUpperCase() == dup) priority += 26;
      print("$dup: $priority");
      dupSum += priority;
    }
    ;
    return dupSum;
  }
}

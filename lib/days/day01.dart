import '../extensions/extensions.dart';
import '../main.dart';

class Day01 extends Day {

  @override
  bool get completed => false;

  @override
  part1() {
    var max = 0;
    var acum = 0;
    for (var data in inputList) {
      if(data == "") {
        if (acum > max) max = acum;
        acum = 0;
      } else
        acum += int.parse(data);
    }
    if (acum > max) max = acum;
    return max;
  }

  @override
  part2() {
    var calories = [];
    var acum = 0;
    for (var data in inputList) {
      if(data == "") {
        calories.add(acum);
        acum = 0;
      } else
        acum += int.parse(data);
    }

    calories.add(acum);
    calories.sort();
    calories = calories.reversed.toList();

    return calories[0]+calories[1]+calories[2];
  }
}
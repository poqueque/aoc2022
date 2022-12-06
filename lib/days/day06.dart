import '../main.dart';

class Day06 extends Day {

  @override
  part1() {
    for (int i=0; i<inputString.length-3; i++){
      var r = inputString.substring(i,i+4);
      if (r.runes.toSet().toList().length == 4)
        return i+4;
    }
    return inputString;
  }

  @override
  part2() {
    for (int i=0; i<inputString.length-13; i++){
      var r = inputString.substring(i,i+14);
      if (r.runes.toSet().toList().length == 14)
        return i+14;
    }
    return inputString;
  }
}
import 'package:aoc2022/extensions/extensions.dart';

import '../main.dart';

class Day25 extends Day {
  @override
  init() {}

  @override
  part1() {
    int total = 0;
    for (var line in inputList) {
      var n = 0;
      for (var c in line.chars) {
        n *= 5;
        if (c == "2") n += 2;
        if (c == "1") n += 1;
        if (c == "-") n -= 1;
        if (c == "=") n -= 2;
      }
      print(n);
      total += n;
    }
    print(total);
    String f = "";
    for (int i = 0; i < 20; i++) {
      var rem = (total % 5);
      if (rem == 3) rem = -2;
      if (rem == 4) rem = -1;
      if (rem == 2) f = "2" + f;
      if (rem == 1) f = "1" + f;
      if (rem == 0) f = "0" + f;
      if (rem == -1) f = "-" + f;
      if (rem == -2) f = "=" + f;
      print(rem);
      total = (total - rem) ~/ 5;
    }
    return f;
  }

  @override
  part2() {
    return "0";
  }
}

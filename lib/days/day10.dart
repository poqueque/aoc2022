import 'dart:io';

import '../main.dart';

class Day10 extends Day {
  @override
  bool get completed => true;

  Map<int, int> values = {};

  @override
  init() {
    int cycle = 1;
    int x = 1;
    for (var line in inputList) {
      var parts = line.split(" ");
      if (parts[0] == "noop") {
        values[cycle] = x;
        cycle++;
      }
      if (parts[0] == "addx") {
        values[cycle] = x;
        cycle++;
        values[cycle] = x;
        cycle++;
        x += int.parse(parts[1]);
      }
    }
  }

  @override
  part1() {
    return 20 * values[20]! +
        60 * values[60]! +
        100 * values[100]! +
        140 * values[140]! +
        180 * values[180]! +
        220 * values[220]!;
  }

  @override
  part2() {
    for (int i = 1; i <= 240; i++) {
      if (values[i] == (i) % 40 ||
          values[i] == (i - 1) % 40 ||
          values[i] == (i - 2) % 40) {
        stdout.write("#");
      } else
        stdout.write(".");
      if (i % 40 == 0) print("");
    }
    return "RGZEHURK";
  }
}

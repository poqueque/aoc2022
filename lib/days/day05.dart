import 'dart:math';

import '../main.dart';

class Day05 extends Day {
  @override
  bool get completed => true;

  int N = 9;
  Map<int, List<String>> stacks = {};

  @override
  part1() {
    for (var i = 1; i <= N; i++) {
      stacks[i] = [];
    }
    bool readingStacks = true;
    bool readingInstructions = false;
    for (var l in inputList) {
      if (l.startsWith(" 1   2")) {
        readingStacks = false;
      }
      if (readingStacks) {
        for (var i = 1; i <= N; i++) {
          if (l.length > 4 * (i - 1)) {
            var crane = l[4 * i - 3];
            if (crane != " ") stacks[i]!.add(crane);
          }
        }
      }
      if (l.startsWith("move")) {
        readingInstructions = true;
      }
      if (readingInstructions) {
        var parts = l.split(" ");
        var howMany = int.parse(parts[1]);
        var from = int.parse(parts[3]);
        var to = int.parse(parts[5]);
        //do it
        stacks[to]!.insertAll(0, stacks[from]!.take(howMany).toList().reversed);
        stacks[from]!.removeRange(0, howMany);
      }
    }
    var top = stacks.values.map((e) => e.first).join();

    return top;
  }

  @override
  part2() {
    for (var i = 1; i <= N; i++) {
      stacks[i] = [];
    }
    bool readingStacks = true;
    bool readingInstructions = false;
    for (var l in inputList) {
      if (l.startsWith(" 1   2")) {
        readingStacks = false;
      }
      if (readingStacks) {
        for (var i = 1; i <= N; i++) {
          if (l.length > 4 * (i - 1)) {
            var crane = l[4 * i - 3];
            if (crane != " ") stacks[i]!.add(crane);
          }
        }
      }
      if (l.startsWith("move")) {
        readingInstructions = true;
      }
      if (readingInstructions) {
        var parts = l.split(" ");
        var howMany = int.parse(parts[1]);
        var from = int.parse(parts[3]);
        var to = int.parse(parts[5]);
        //do it
        stacks[to]!.insertAll(0, stacks[from]!.take(howMany));
        stacks[from]!.removeRange(0, howMany);
      }
    }
    var top = stacks.values.map((e) => e.first).join();

    return top;
  }
}

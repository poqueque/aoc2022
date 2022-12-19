import 'package:aoc2022/extensions/extensions.dart';

import '../main.dart';

class Day17 extends Day {
  @override
  bool get completed => true;
  late List<String> moves;
  static const EMPTY_LINE = ".......";
  static const SHAPE_1 = ["..@@@@."];
  static const SHAPE_2 = ["...@...", "..@@@..", "...@..."];
  static const SHAPE_3 = ["..@@@..", "....@..", "....@.."];
  static const SHAPE_4 = ["..@....", "..@....", "..@....", "..@...."];
  static const SHAPE_5 = ["..@@...", "..@@..."];
  static const SHAPES = [SHAPE_1, SHAPE_2, SHAPE_3, SHAPE_4, SHAPE_5];
  static const retain = 30;

//  static const ROCKS = 2022;
  static const ROCKS = 1000000000000;
  static const CACHE_LENGTH = 30;

  List<String> cave = ["-------"];
  List<State> states = [];
  Map<String, int> cache = {};
  Map<State, State> cache2 = {};


  bool hasToPrint = false;

  var nextShape = 0;
  var nextMove = 0;

  @override
  init() {
    moves = inputString.chars;
  }

  @override
  part1() {
    for (int i = 0; i < 2022; i++) {
      step();
    }
    return cave.length - 1;
  }

  @override
  part2new() {
    var deleted = 0;
    for (int i = 0; i < 2022; i++) {
      var state = State(cave.reversed.take(CACHE_LENGTH).toList().reversed.toList(),nextMove,nextShape);
      var cached = cache2[state];
      if (cached == null){
        var totalBefore = deleted + cave.length - 1;
        step();
        var totalAfter = deleted + cave.length - 1;
        var nextState = State(cave.reversed.take(CACHE_LENGTH).toList().reversed.toList(),nextMove,nextShape);
        nextState.firstSeenValue = totalAfter;
        nextState.stepValue = totalAfter - totalBefore;
        nextState.firstSeenAt = i+1;
        cache2[state] = nextState;
        deleted += cave.length - CACHE_LENGTH;
        cave = cave.reversed.take(CACHE_LENGTH).toList().reversed.toList();
      } else {
        cave = cached.top;
        nextMove = cached.move;
        nextShape = cached.shape;
        deleted += cached.stepValue;
      }

    }
    return deleted + cave.length - 1;
  }
  part2() {
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];

    int totalLength = 0;
    int steps = 0;
    int cycleSize = 5 * moves.length;
    for (int i = 0; i < ROCKS ~/ cycleSize; i++) {
      int length = cycle();
      steps += cycleSize;
      totalLength += length;
//      if (i%1000003==0) print("$steps -> $length");
    }
    print("TOTAL Prev: $steps -> $totalLength");
    int r = ROCKS % cycleSize;
    int length = remaining(r, totalLength);
    steps += r;
    totalLength += length;

    print("TOTAL: $steps -> $totalLength");
    return totalLength;
  }

  part2plain(){
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];

    for (int i=0; i<ROCKS; i++) {
      step();
    }
  }

  part2c() {
//    return 1540804597682;
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];

    int cycleLength = 5 * moves.length;
    int loops = (ROCKS - 2 * cycleLength) ~/ (7 * cycleLength);
    int remainingRocks = (ROCKS - 2 * cycleLength) % (7 * cycleLength);
    print(loops);
    print(608 + loops * 2120);
    print(remainingRocks);
//    return 608+loops*2120;

    var total = 0;
    var steps = 0;
    while (ROCKS - steps > 5 * moves.length) {
      steps += 5 * moves.length;
      int c = cycle();
      total += c;
      print("Steps $steps -> $total ($c)");
    }
    int c = remaining(ROCKS - steps, total);
    steps += ROCKS - steps;
    total += c;
    print("Steps $steps -> $total");
  }

  part2a() {
    var start = DateTime.now().millisecondsSinceEpoch;
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];

    List<String> states = [];
    bool periodFound = false;
    int loops = 0;
    int removed = 0;
    int firstLoop = 0;
    while (!periodFound) {
      for (int i = 0; i < 5 * moves.length; i++) {
        step();
        if (cave.length > retain * 2) {
          removed += retain;
          cave.removeRange(1, retain + 1);
        }
      }
      loops++;
      var state = cave.reversed.take(20).toList().join();
      if (states.contains(state)) {
        firstLoop = states.indexOf(state);
        print(
            "STATE FOUND after $loops loops at ${states.indexOf(state)} on list of ${states.length}");
        periodFound = true;
      } else
        states.add(state);
      var end = DateTime.now().millisecondsSinceEpoch;
      var time = (end - start) ~/ 1000;
      print("loops: $loops - $time sec.");
      print("len: ${removed + cave.length - 1}");
    }

    //number of loops = 8
    loops--;
    print("Loops: $loops");
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];
    removed = 0;
    for (int i = 0; i < 5 * moves.length * (firstLoop); i++) {
      step();
      if (cave.length > retain * 2) {
        removed += retain;
        cave.removeRange(1, retain + 1);
      }
    }
    int stepsAfterHeader = removed + cave.length - 1;
    for (int i = 0; i < 5 * moves.length * (loops); i++) {
      step();
      if (cave.length > retain * 2) {
        removed += retain;
        cave.removeRange(1, retain + 1);
      }
    }
    int loopSteps = removed + cave.length - 1 - stepsAfterHeader;

    int loopSize = 5 * moves.length * (loops);
    int times = (ROCKS - stepsAfterHeader) ~/ loopSize;
    int remaining = (ROCKS - stepsAfterHeader) % loopSize;
    int accumulate = stepsAfterHeader + (times) * (loopSteps);
    print("Acc: $accumulate");
    int currentLength = removed + cave.length - 1;
    for (int i = 0; i < remaining; i++) {
      step();
      if (cave.length > retain * 2) {
        removed += retain;
        cave.removeRange(1, retain + 1);
      }
    }
    int diff = removed + cave.length - 1 - currentLength;
    return accumulate + diff;
  }

  part2b() {
    nextShape = 0;
    nextMove = 0;
    cave = ["-------"];
    bool periodFound = false;
    int i = 0;
    while (!periodFound) {
      step();
      var state = State(cave, nextShape, nextMove);
      if (states.contains(state)) {
        print(
            "STATE $i FOUND at ${states.indexOf(state)} on list of ${states.length}");
        periodFound = true;
      }
      states.add(state);
      i++;
    }
    return cave.length - 1;
  }

  void printCave() {
    print("");
    for (var line in cave.reversed.take(CACHE_LENGTH)) print("|$line|");
  }

  void move(int nextMove) {
    for (var i = cave.length - 1; i > 0; i--) {
      if (cave[i].contains("@")) {
        if (moves[nextMove] == "<" && cave[i][0] == "@") {
          return;
        }
        if (moves[nextMove] == ">" && cave[i][6] == "@") {
          return;
        }
        if (moves[nextMove] == "<" && cave[i].contains("#@")) {
          return;
        }
        if (moves[nextMove] == ">" && cave[i].contains("@#")) {
          return;
        }
      }
    }

    for (var i = cave.length - 1; i > 0; i--) {
      if (cave[i].contains("@")) {
        if (moves[nextMove] == "<") {
          if (cave[i].contains(".@@@@"))
            cave[i] = cave[i].replaceAll(".@@@@", "@@@@.");
          else if (cave[i].contains(".@@@"))
            cave[i] = cave[i].replaceAll(".@@@", "@@@.");
          else if (cave[i].contains(".@@"))
            cave[i] = cave[i].replaceAll(".@@", "@@.");
          else if (cave[i].contains(".@"))
            cave[i] = cave[i].replaceAll(".@", "@.");
        }
        if (moves[nextMove] == ">") {
          if (cave[i].contains("@@@@."))
            cave[i] = cave[i].replaceAll("@@@@.", ".@@@@");
          else if (cave[i].contains("@@@."))
            cave[i] = cave[i].replaceAll("@@@.", ".@@@");
          else if (cave[i].contains("@@."))
            cave[i] = cave[i].replaceAll("@@.", ".@@");
          else if (cave[i].contains("@."))
            cave[i] = cave[i].replaceAll("@.", ".@");
        }
      }
    }
  }

  bool fall(int shape) {
    if (hasToPrint) print("fall");
    var i = cave.indexOf(EMPTY_LINE);
    if (i > -1) {
      cave.removeAt(i);
      return true;
    } else {
      if (merge(shape)) return true;
      freeze();
      return false;
    }
  }

  void freeze() {
    for (var i = 0; i < cave.length; i++) {
      cave[i] = cave[i].replaceAll("@", "#");
    }
  }

  bool merge(int shape) {
    if (hasToPrint) print("merge");
    var c = cave.toList();
    for (var i = 0; i < c.length; i++) {
      if (c[i].contains("@")) {
        for (int j = 0; j < 7; j++) {
          if (c[i][j] == "@" && c[i - 1][j] == "#") return false;
          if (c[i][j] == "@" && c[i - 1][j] == "-") return false;
          if (c[i][j] == "@" && c[i - 1][j] == ".") {
            c[i] = c[i].changeAt(j, ".");
            c[i - 1] = c[i - 1].changeAt(j, "@");
          }
        }
      }
    }
    while (c.last == EMPTY_LINE) c.removeLast();
    cave = c;
    return true;
  }

  void step() {
    //remove from top
    cave.removeWhere((element) => element == EMPTY_LINE);
    cave.add(EMPTY_LINE);
    cave.add(EMPTY_LINE);
    cave.add(EMPTY_LINE);
    cave.addAll(SHAPES[nextShape]);
    if (hasToPrint) printCave();
    bool falling = true;
    while (falling) {
      //PUSH
      if (hasToPrint) print(moves[nextMove]);
      move(nextMove);
      if (hasToPrint) printCave();
      falling = fall(nextShape);
      if (hasToPrint) printCave();
      nextMove++;
      if (nextMove == moves.length) nextMove = 0;
    }
    nextShape++;
    if (nextShape == SHAPES.length) nextShape = 0;
  }

  int cycle() {
    var state = cave.reversed.take(CACHE_LENGTH).toList().join();
//    if (cache[state] != null) return cache[state]!;
    var removed = 0;
    var prevLeng = cave.length - 1;
    for (int i = 0; i < 5 * moves.length; i++) {
      step();
      if (cave.length > retain * 2) {
        removed += retain;
        cave.removeRange(0, retain);
      }
    }
    cache[state] = removed + cave.length - 1 - prevLeng;
    return removed + cave.length - 1 - prevLeng;
  }

  int remaining(int steps, int totalLength) {
    var removed = 0;
    var prevLeng = cave.length - 1;
    for (int i = 0; i < steps; i++) {
      step();
      if (cave.length > retain * 2) {
        removed += retain;
        cave.removeRange(1, retain + 1);
      }
//      print("TOTAL: $steps -> ${totalLength + removed + cave.length - 1 - prevLeng}");
    }
    return removed + cave.length - 1 - prevLeng;
  }
}

class State {
  final List<String> top;
  final int move;
  final int shape;
  int loop = 0;
  int stepValue = 0;
  int firstSeenAt = 0;
  int firstSeenValue = 0;

  State(this.top, this.move, this.shape);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          move == other.move &&
          shape == other.shape;

  @override
  int get hashCode => top.hashCode ^ move.hashCode ^ shape.hashCode;
}

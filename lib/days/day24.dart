import 'package:aoc2022/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day24 extends Day {
  @override
  bool get completed => true;

  List<Wind> blizzards = [];
  Map<int, List<Wind>> blizzardCache = {};
  Map<State, int> cache = {};
  Map<State2, int> cache2 = {};

  late Coor start;
  late Coor end;
  late Coor p;
  late int maxX;
  late int maxY;
  int maxSteps = 1000;

  @override
  init() {
    var y = 0;
    for (var line in inputList) {
      var x = 0;
      for (var c in line.chars) {
        if (c == ">" || c == "<" || c == "^" || c == "v") {
          blizzards.add(Wind(Coor(x, y), c));
        }
        x++;
      }
      y++;
    }
//    maxX = 6;
//    maxY = 4;
    maxX = 120;
    maxY = 25;
    start = Coor(1, 0);
    end = Coor(maxX, maxY + 1);
    p = start;
  }

  @override
  part1() {
//    printMap(true, p, blizzards);
    var s = step(p, 0, start, end, blizzards);
    return s;
  }

  @override
  part2() {
    var s1 = step(start, 0, start, end, blizzards);
    print(s1);

    cache.clear();
    var s2 = step(end, s1, end, start, blizzards);
    print(s2);

    cache.clear();
    var s3 = step(start, s2, start, end, blizzards);
    print(s3);
    return s3;
  }

  step(Coor p, int i, Coor from, Coor to, List<Wind> blizzards) {
    if (cache.containsKey(State(p, i))) return cache[State(p, i)];
    if (p == to) {
      cache[State(p, i)] = i;
      return i;
    }
    if (i == maxSteps) {
      cache[State(p, i)] = i;
      return i;
    }
    var blizzs = moveWinds(blizzards, i);
//    printMap(true, p, blizzs);
    List<Coor> possibleMoves = [];
    var r = p.move(Direction.right);
    var l = p.move(Direction.left);
    var u = p.move(Direction.up);
    var d = p.move(Direction.down);
    if (inBounds(l) && !existBlizzard(blizzs, l)) possibleMoves.add(l);
    if (inBounds(r) && !existBlizzard(blizzs, r)) possibleMoves.add(r);
    if (inBounds(u) && !existBlizzard(blizzs, u)) possibleMoves.add(u);
    if (inBounds(d) && !existBlizzard(blizzs, d)) possibleMoves.add(d);
    if (!existBlizzard(blizzs, p)) possibleMoves.add(p);
    if (possibleMoves.length > 1 && p == from) possibleMoves.remove(p);
    var min = maxSteps;
    for (var m in possibleMoves) {
      var s = step(m, i + 1, from, to, blizzs);
      if (s < min) min = s;
    }
    cache[State(p, i)] = min;
    return min;
  }

  List<Wind> moveWinds(List<Wind> blizzards, int step) {
    if (blizzardCache[step] != null) return blizzardCache[step]!;
    List<Wind> blizzs = [];
    for (var b in blizzards) {
      var p2 = b.p;
      if (b.w == ">") {
        p2 = b.p.move(Direction.right);
        if (p2.x == maxX + 1) p2 = Coor(1, p2.y);
      }
      if (b.w == "<") {
        p2 = b.p.move(Direction.left);
        if (p2.x == 0) p2 = Coor(maxX, p2.y);
      }
      if (b.w == "^") {
        p2 = b.p.move(Direction.up);
        if (p2.y == 0) p2 = Coor(p2.x, maxY);
      }
      if (b.w == "v") {
        p2 = b.p.move(Direction.down);
        if (p2.y == maxY + 1) p2 = Coor(p2.x, 1);
      }
      blizzs.add(Wind(p2, b.w));
    }
    blizzardCache[step] = blizzs;
    return blizzs;
  }

  void printMap(bool hasToPrint, Coor p, List<Wind> b) {
    String line = "";
    print("");
    for (var y = 1; y <= maxY; y++) {
      for (var x = 1; x <= maxX; x++) {
        var val = ".";
        var n = 0;
        for (var b1 in b) {
          if (b1.p == Coor(x, y)) {
            val = b1.w;
            n++;
          }
        }
        if (n > 1) val = n.toString().chars[0];
        if (p == Coor(x, y)) val = "E";
        line += val;
      }
      if (hasToPrint) print(line);
      line = "";
    }
  }

  bool existBlizzard(List<Wind> blizzards, Coor l) {
    for (var b in blizzards) {
      if (b.p == l) return true;
    }
    return false;
  }

  bool inBounds(Coor l) {
    if (l.x < 1 && l != end && l != start) return false;
    if (l.y < 1 && l != end && l != start) return false;
    if (l.x > maxX && l != end && l != start) return false;
    if (l.y > maxY && l != end && l != start) return false;
    return true;
  }
}

class Wind {
  Coor p;
  String w;

  Wind(this.p, this.w);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wind &&
          runtimeType == other.runtimeType &&
          p == other.p &&
          w == other.w;

  @override
  int get hashCode => p.hashCode ^ w.hashCode;
}

class State {
  Coor p;
  int step;

  State(this.p, this.step);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          p == other.p &&
          step == other.step;

  @override
  int get hashCode => p.hashCode ^ step.hashCode;
}

class State2 {
  Coor p;
  int step;
  int trip;

  State2(this.p, this.step, this.trip);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State2 &&
          runtimeType == other.runtimeType &&
          p == other.p &&
          step == other.step &&
          trip == other.trip;

  @override
  int get hashCode => p.hashCode ^ step.hashCode ^ trip.hashCode;
}

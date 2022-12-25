import 'dart:io';
import 'package:collection/collection.dart';

import 'package:aoc2022/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day23 extends Day {
  @override
  bool get completed => true;

  Map<Coor, Coor?> elves = {}; //Where they are, Where they propose to move
  List<Direction> directionOrder = [
    Direction.up,
    Direction.down,
    Direction.left,
    Direction.right
  ];

  @override
  init() {
    elves.clear();
    var y = 1;
    for (var line in inputList) {
      var x = 1;
      for (var c in line.chars) {
        if (c == "#") {
          elves[Coor(x, y)] = Coor(x, y);
        }
        x++;
      }
      y++;
    }
  }

  @override
  part1() {
    printMap(true);
//    print("");
    var e = 0;
    for (int i = 0; i < 10; i++) {
      e = round(true);
    }
    return e;
  }

  Function eq = const SetEquality().equals;

  @override
  part2() {
    elves.clear();
    directionOrder = [
      Direction.up,
      Direction.down,
      Direction.left,
      Direction.right
    ];
    init();
    printMap(true);
    print("");
    var run = true;
    int i = 0;
    while (run) {
//      var prevElvesPositions = elves.keys.toSet();
      var moving = round(false);
//      if (eq(prevElvesPositions, elves.keys.toSet())) run = false;
      if (moving == 0) run = false;
//      print("");
//      printMap(true);
      i++;
      if (i % 100 == 0) print(i.toString());
    }
    print("");
//    printMap(true);
    return i;
  }

  int round(bool count) {
    //Consider where to move
    var movingElves = 0;
    for (var k in elves.keys) {
      var n = k.neighbours();
      List<Coor> neighboursWithElves =
          n.where((neighbour) => elves.keys.contains(neighbour)).toList();
      if (neighboursWithElves.length > 0) {
        elves[k] = getProposalMove(k, neighboursWithElves);
      } else {
        elves[k] = null;
      }
    }
    //Move if moving
    var elvesKeys = elves.keys.toList();
    var elvesValues = elves.values.toList();
    var newElves = <Coor, Coor?>{};
    for (var k in elvesKeys) {
      var p = elves[k];
      if (p != null) {
        var elvesToMoveThere =
            elvesKeys.where((element) => elves[element] == p).length;
        if (elvesToMoveThere == 1) {
          newElves[p] = p;
          if (p != k) movingElves++;
        } else {
          newElves[k] = null;
        }
      } else
        newElves[k] = null;
    }
    elves = newElves;
    //Rotate directionOrder
    var f = directionOrder.first;
    directionOrder = directionOrder.skip(1).toList();
    directionOrder.add(f);
    var empty = 0;
    if (count) {
      empty = printMap(false);
    }
    stdout.write(".");
    if (count)
      return empty;
    else
      return movingElves;
  }

  Coor? getProposalMove(Coor k, List<Coor> neighboursWithElves) {
    for (var d in directionOrder) {
      if (d == Direction.up) {
        if (!neighboursWithElves.contains(k.move(Direction.up)) &&
            !neighboursWithElves.contains(k.move(Direction.rightUp)) &&
            !neighboursWithElves.contains(k.move(Direction.leftUp))) {
          return k.move(Direction.up);
        }
      }
      if (d == Direction.down) {
        if (!neighboursWithElves.contains(k.move(Direction.down)) &&
            !neighboursWithElves.contains(k.move(Direction.rightDown)) &&
            !neighboursWithElves.contains(k.move(Direction.leftDown))) {
          return k.move(Direction.down);
        }
      }
      if (d == Direction.left) {
        if (!neighboursWithElves.contains(k.move(Direction.left)) &&
            !neighboursWithElves.contains(k.move(Direction.leftUp)) &&
            !neighboursWithElves.contains(k.move(Direction.leftDown))) {
          return k.move(Direction.left);
        }
      }
      if (d == Direction.right) {
        if (!neighboursWithElves.contains(k.move(Direction.right)) &&
            !neighboursWithElves.contains(k.move(Direction.rightUp)) &&
            !neighboursWithElves.contains(k.move(Direction.rightDown))) {
          return k.move(Direction.right);
        }
      }
    }
    return null;
  }

  int bounds(Direction direction) {
    var minX = 100000;
    var maxX = -100000;
    var minY = 100000;
    var maxY = -100000;
    for (var k in elves.keys) {
      if (k.x < minX) minX = k.x;
      if (k.x > maxX) maxX = k.x;
      if (k.y < minY) minY = k.y;
      if (k.y > maxY) maxY = k.y;
    }
    switch (direction) {
      case Direction.up:
        return minY;
      case Direction.down:
        return maxY;
      case Direction.left:
        return minX;
      case Direction.right:
        return maxX;
      default:
        return 0;
    }
  }

  int printMap(bool hasToPrint) {
    String line = "";
    int empty = 0;
    for (var y = bounds(Direction.up); y <= bounds(Direction.down); y++) {
      for (var x = bounds(Direction.left); x <= bounds(Direction.right); x++) {
        var value = elves.containsKey(Coor(x, y)) ? "#" : ".";
        if (value == ".") empty++;
        line += value;
      }
      if (hasToPrint) print(line);
      line = "";
    }
    return empty;
  }
}

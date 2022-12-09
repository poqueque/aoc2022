import 'dart:io';

import '../main.dart';
import '../utils/coor.dart';

class Day09 extends Day {
  @override
  bool get completed => true;

  //Data structures for input Data
  var h = Coor(0, 0);
  var t = Coor(0, 0);
  List<Coor> visited = [];
  List<Coor> rope = [
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0),
    Coor(0, 0)
  ];

  @override
  init() {}

  @override
  part1() {
    for (var line in inputList) {
      var parts = line.split(" ");
      for (int i = 0; i < int.parse(parts[1]); i++) {
        move(parts[0]);
        if (!visited.contains(t)) visited.add(t);
      }
    }
    return visited.length;
  }

  @override
  part2() {
    visited.clear();
    for (var line in inputList) {
      var parts = line.split(" ");
      for (int i = 0; i < int.parse(parts[1]); i++) {
        move9(parts[0]);
        if (!visited.contains(rope[9])) visited.add(rope[9]);
      }
//      printMap();
    }
//    printVisitedMap();
    return visited.length;
  }

  void move(String direction) {
    if (direction == "R") h = h.move(Direction.right);
    if (direction == "L") h = h.move(Direction.left);
    if (direction == "U") h = h.move(Direction.up);
    if (direction == "D") h = h.move(Direction.down);
    t = tailMove(h, t);
  }

  Coor tailMove(Coor head, Coor tail) {
    if (head == tail) return tail;
    if (head.neighbours().contains(tail)) return tail;
    if ((head.x - tail.x) > 1 && (head.y - tail.y) > 1)
      return (Coor(head.x - 1, head.y - 1));
    if ((head.x - tail.x) > 1 && (head.y - tail.y) < -1)
      return (Coor(head.x - 1, head.y + 1));
    if ((head.x - tail.x) < -1 && (head.y - tail.y) > 1)
      return (Coor(head.x + 1, head.y - 1));
    if ((head.x - tail.x) < -1 && (head.y - tail.y) < -1)
      return (Coor(head.x + 1, head.y + 1));
    if ((head.x - tail.x) > 1) return (Coor(head.x - 1, head.y));
    if ((head.x - tail.x) < -1) return (Coor(head.x + 1, head.y));
    if ((head.y - tail.y) > 1) return (Coor(head.x, head.y - 1));
    if ((head.y - tail.y) < -1) return (Coor(head.x, head.y + 1));
    return tail;
  }

  void move9(String direction) {
    if (direction == "R") rope[0] = rope[0].move(Direction.right);
    if (direction == "L") rope[0] = rope[0].move(Direction.left);
    if (direction == "U") rope[0] = rope[0].move(Direction.up);
    if (direction == "D") rope[0] = rope[0].move(Direction.down);
    for (int i = 1; i <= 9; i++) {
      rope[i] = tailMove(rope[i - 1], rope[i]);
    }
  }

  void printMap() {
    for (int y = -10; y < 6; y++) {
      for (int x = -10; x < 20; x++) {
        stdout.write(pos(Coor(x, y)));
      }
      print("");
    }
  }

  void printVisitedMap() {
    for (int y = -10; y < 6; y++) {
      for (int x = -10; x < 20; x++) {
        if (visited.contains(Coor(x, y)))
          stdout.write("#");
        else
          stdout.write(".");
      }
      print("");
    }
  }

  String pos(Coor coor) {
    if (coor == Coor(0, 0)) return "s";
    for (int i = 0; i <= 9; i++) if (rope[i] == coor) return "$i";
    if (visited.contains(coor)) return "#";
    return ".";
  }
}

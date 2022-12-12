import 'package:aoc2022/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day12 extends Day {
  @override
  bool get completed => true;

  Map<Coor, String> el = {};

  late Coor start;
  late Coor end;

  @override
  init() {
    var y = 0;
    for (var line in inputList) {
      var x = 0;
      for (var char in line.chars) {
        if (char == "S") {
          char = "a";
          start = Coor(x, y);
        }
        if (char == "E") {
          char = "z";
          end = Coor(x, y);
        }
        el[Coor(x, y)] = char;
        x++;
      }
      y++;
    }
  }

  @override
  part1() {
    return distanceFrom(start, end);
  }

  @override
  part2() {
    return distanceFrom2(start, end) - 1;
  }

  int distanceFrom(Coor start, Coor end) {
    Set<Coor> unvisited = {};
    unvisited.addAll(el.keys);
    Map<Coor, int> distance = {};
    for (var v in unvisited) distance[v] = 1000000;
    distance[start] = 0;

    var pointer = start;

    while (unvisited.isNotEmpty) {
      var el0 = el[pointer]!.runes.first;
      var options = pointer
          .neighboursWithoutDiagonals()
          .where((element) => el[element] != null)
          .where((element) => (el[element]!.runes.first <= el0 + 1))
          .toList();
      for (var i in options) distance[i] = distance[pointer]! + 1;
      unvisited.remove(pointer);
      var minD = 1000000000;
      for (var u in unvisited) {
        if (distance[u]! < minD) {
          minD = distance[u]!;
          pointer = u;
        }
      }
    }
    return distance[end]!;
  }

  int distanceFrom2(Coor start, Coor end) {
    Set<Coor> unvisited = {};
    unvisited.addAll(el.keys);
    Map<Coor, int> distance = {};
    for (var v in unvisited) distance[v] = 10000000;
    distance[start] = 0;

    var pointer = start;

    while (unvisited.isNotEmpty) {
      var el0 = el[pointer]!.runes.first;
      var options = pointer
          .neighboursWithoutDiagonals()
          .where((element) => el[element] != null)
          .where((element) => (el[element]!.runes.first <= el0 + 1))
          .toList();
      for (var i in options) {
        if (el[i] == "a")
          distance[i] = 0;
        else
          distance[i] = distance[pointer]! + 1;
      }
      unvisited.remove(pointer);
      var minD = 10000000000;
      for (var u in unvisited) {
        if (distance[u]! < minD) {
          minD = distance[u]!;
          pointer = u;
        }
      }
    }
    return distance[end]!;
  }
}

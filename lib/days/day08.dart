import 'package:aoc2022/extensions/extensions.dart';
import 'package:aoc2022/utils/coor.dart';

import '../main.dart';

class Day08 extends Day {
  @override
  bool get completed => true;

  CoorMap map = CoorMap();

  @override
  init() {
    var x = 0;
    var y = 0;
    for (var line in inputList) {
      x = 0;
      for (var c in line.chars) {
        map.map[Coor(x, y)] = int.parse(c);
        x++;
      }
      y++;
    }
  }

  @override
  part1() {
    var total = 0;
    for (var c in map.map.entries) {
      if (isVisible(c.key)) total++;
    }

    return total;
  }

  bool isVisible(Coor coor) {
    var maxY = inputList.length;
    var maxX = inputList[0].length;
    int v = map.map[coor];

    bool visible = true;
    for (int i = 0; i < coor.x; i++) {
      if (map.map[Coor(i, coor.y)] >= v) visible = false;
    }
    if (visible) return true;

    visible = true;
    for (int i = coor.x + 1; i < maxX; i++) {
      if (map.map[Coor(i, coor.y)] >= v) visible = false;
    }
    if (visible) return true;

    visible = true;
    for (int i = 0; i < coor.y; i++) {
      if (map.map[Coor(coor.x, i)] >= v) visible = false;
    }
    if (visible) return true;

    visible = true;
    for (int i = coor.y + 1; i < maxY; i++) {
      if (map.map[Coor(coor.x, i)] >= v) visible = false;
    }
    if (visible) return true;

    return false;
  }

  int scenicScore(Coor coor) {
    var maxY = inputList.length;
    var maxX = inputList[0].length;
    int v = map.map[coor];

    bool visible = true;
    int ss1 = 0;
    for (int i = coor.x - 1; i >= 0; i--) {
      if (visible) {
        if (map.map[Coor(i, coor.y)] >= v) {
          visible = false;
        }
        ss1++;
      }
    }

    visible = true;
    int ss2 = 0;
    for (int i = coor.x + 1; i < maxX; i++) {
      if (visible) {
        if (map.map[Coor(i, coor.y)] >= v) {
          visible = false;
        }
        ss2++;
      }
    }

    visible = true;
    var ss3 = 0;
    for (int i = coor.y - 1; i >= 0; i--) {
      if (visible) {
        if (map.map[Coor(coor.x, i)] >= v) {
          visible = false;
        }
        ss3++;
      }
    }

    visible = true;
    var ss4 = 0;
    for (int i = coor.y + 1; i < maxY; i++) {
      if (visible) {
        if (map.map[Coor(coor.x, i)] >= v) {
          visible = false;
        }
        ss4++;
      }
    }

    return ss1 * ss2 * ss3 * ss4;
  }

  @override
  part2() {
    var maxSS = 0;
    for (var c in map.map.entries) {
      var ss = scenicScore(c.key);
      if (ss > maxSS) maxSS = ss;
    }

    return maxSS;
  }
}

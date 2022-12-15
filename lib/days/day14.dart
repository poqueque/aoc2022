import '../main.dart';
import '../utils/coor.dart';

class Day14 extends Day {
  CoorMap<String> coorMap = CoorMap();
  late Map<Coor, String> map;
  Coor source = Coor(500, -1);

  @override
  init() {
    coorMap.map.clear();
    map = coorMap.map;
    for (var line in inputList) {
      var parts = line.split("->").map((e) => e.trim());
      Coor? lastP = null;
      for (var p in parts) {
        var point = Coor.fromString(p);
        map[point] = "#";
        if (lastP != null) {
          for (var k in point.pathTo(lastP)) map[k] = "#";
        }
        lastP = point;
      }
    }
    map[source] = "+";
  }

  @override
  part1() {
    var total = 0;
    Coor? fallingSand = fall();
    while (fallingSand != null) {
      map[fallingSand] = "o";
      total++;
      fallingSand = fall();
    }
    return total;
  }

  @override
  part2() {
    init();
    var floorY = coorMap.bounds(Direction.down) + 2;
    var lb = coorMap.bounds(Direction.left);
    var rb = coorMap.bounds(Direction.right);
    for(int i = lb - 600; i < rb + 600; i++)
      map[Coor(i,floorY)] = "#";

    var total = 0;
    Coor? fallingSand = fall();
    var belowSource = source.move(Direction.down);
    while (fallingSand != null && fallingSand != belowSource) {
      map[fallingSand] = "o";
      total++;
      fallingSand = fall();
    }
    if (fallingSand == belowSource){
      map[belowSource] = "o";
      total++;
    }
    return total;
  }

  Coor? fall() {
    var p = source.move(Direction.down);
    Coor below = p;
    while (map[below] == null) {
      p = below;
      below = p.move(Direction.down);
      if (map[below] != null) below = p.move(Direction.leftDown);
      if (map[below] != null) below = p.move(Direction.rightDown);
      if (p.y > 10000) return null;
    }
    return p;
  }
}

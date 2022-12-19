import '../main.dart';
import '../utils/coor3.dart';

class Day18 extends Day {
  @override
  bool get completed => true;

  List<Coor3> points = [];

  @override
  init() {
    points = inputList.map((e) => Coor3.fromString(e)).toList();
  }

  @override
  part1() {
    return surface(points);
  }

  @override
  part2() {
    int minX = 0, maxX = 0, minY = 0, maxY = 0, minZ = 0, maxZ = 0;
    for (var p in points) {
      if (p.x < minX) minX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.z < minZ) minZ = p.z;
      if (p.x > maxX) maxX = p.x;
      if (p.y > maxY) maxY = p.y;
      if (p.z > maxZ) maxZ = p.z;
    }

    var minCoor = Coor3(1000, 1000, 1000);
    for (var p in points) {
      if (p.x + p.y + p.z < minCoor.x + minCoor.y + minCoor.z) minCoor = p;
    }

    late Coor3 firstAir;
    for (var n in minCoor.neighboursWithoutDiagonals()) {
      if (!points.contains(n)) firstAir = n;
    }

    List<Coor3> queue = [firstAir];
    List<Coor3> outerCubes = [];
    while (queue.isNotEmpty) {
      Coor3 current = queue.first;
      queue.removeAt(0);
      outerCubes.add(current);
      for (var n in current.neighboursWithoutDiagonals()) {
        if (outerCubes.contains(n) || points.contains(n) || queue.contains(n))
          continue;
        if (distanceToPoints(n) > 2) continue;
        queue.add(n);
      }
    }

    var surfaceArea = 0;
    for (var c in outerCubes) {
      for (var d in c.neighboursWithoutDiagonals()) {
        if (points.contains(d)) surfaceArea++;
      }
    }
    return surfaceArea;
  }

  surface(List<Coor3> points) {
    int total = 0;
    for (var p in points) {
      for (var n in p.neighboursWithoutDiagonals()) {
        if (!points.contains(n)) total++;
      }
    }
    return total;
  }

  bool inSurface(Coor3 cube, List<Coor3> points) {
    bool up = false;
    bool down = false;
    for (int i = -20; i <= 20; i++) {
      if (points.contains(Coor3(i, cube.y, cube.z)) && i < cube.x) up = true;
      if (points.contains(Coor3(i, cube.y, cube.z)) && i > cube.x) down = true;
    }
    if (up == false) return true;
    if (down == false) return true;

    up = false;
    down = false;
    for (int i = -20; i <= 20; i++) {
      if (points.contains(Coor3(cube.x, i, cube.z)) && i < cube.y) up = true;
      if (points.contains(Coor3(cube.x, i, cube.z)) && i > cube.y) down = true;
    }
    if (up == false) return true;
    if (down == false) return true;

    up = false;
    down = false;
    for (int i = -20; i <= 20; i++) {
      if (points.contains(Coor3(cube.x, cube.y, i)) && i < cube.z) up = true;
      if (points.contains(Coor3(cube.x, cube.y, i)) && i > cube.z) down = true;
    }
    if (up == false) return true;
    if (down == false) return true;

    print(cube);
    return false;
  }

  bool anyNeighbourInList(Coor3 cube, List<Coor3> outerCubes) {
    for (var n in cube.neighboursWithoutDiagonals())
      if (outerCubes.contains(n)) return true;
    return false;
  }

  bool canFill(Coor3 cube, List<Coor3> points) {
    List<Coor3> fill = [cube];
    int fs = 0;
    while (fill.length > fs) {
      fs = fill.length;
      for (var f in fill.toList()) {
        for (var ff in f.neighboursWithoutDiagonals()) {
          if (ff.x > 20) return false;
          if (ff.y > 20) return false;
          if (ff.z > 20) return false;
          if (ff.x < 0) return false;
          if (ff.y < 0) return false;
          if (ff.z < 0) return false;
          if (!points.contains(ff) && !fill.contains(ff)) fill.add(ff);
        }
      }
    }
    return true;
  }

  int distanceToPoints(Coor3 n) {
    int min = 100;
    for (var p in points) {
      var d = p.manhattanDistance(n);
      if (d < min) min = d;
    }
    return min;
  }
}

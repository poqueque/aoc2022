import 'dart:io';

import '../main.dart';
import '../utils/coor.dart';

class Day15 extends Day {
  @override
  bool get completed => true;

  Map<Coor, Coor> closest = {};
  Map<Coor, String> map = {};
  Set<Coor> possibleBeacon = {};
  var Y = 2000000;
  var MAX = 4000000;

  @override
  init() {
    // CoorMap coorMap = CoorMap();
    // coorMap.map = map;
    // coorMap.printMap(spaces: false);
  }

  @override
  part1() {
    for (var line in inputList) {
      var p = line.split(" ");
      var sensor = Coor(int.parse(p[2].split("=")[1].replaceAll(",", "")),
          int.parse(p[3].split("=")[1].replaceAll(":", "")));
      var beacon = Coor(int.parse(p[8].split("=")[1].replaceAll(",", "")),
          int.parse(p[9].split("=")[1]));
      closest[sensor] = beacon;
      map[sensor] = "#";
      map[beacon] = "B";
      int distance = sensor.manhattanDistance(beacon);
      for (int i = sensor.x - distance.floor();
          i < sensor.x + distance.floor();
          i++) {
        var k = Coor(i, 2000000);
        if (sensor.manhattanDistance(k) <= distance) if (map[k] != "B")
          map[k] = "#";
      }
    }
    var total = 0;
    for (var m in map.keys.where((element) => element.y == 2000000).toList()) {
      if (map[m] == "#" || map[m] == "S") total++;
    }
    return total;
  }

  @override
  part2() {
    List<Coor> sensors = [];
    List<Coor> beacons = [];
    for (var line in inputList) {
      var p = line.split(" ");
      var sensor = Coor(int.parse(p[2].split("=")[1].replaceAll(",", "")),
          int.parse(p[3].split("=")[1].replaceAll(":", "")));
      var beacon = Coor(int.parse(p[8].split("=")[1].replaceAll(",", "")),
          int.parse(p[9].split("=")[1]));
      sensors.add(sensor);
      beacons.add(beacon);
      closest[sensor] = beacon;
      map[sensor] = "#";
      map[beacon] = "B";
      int distance = sensor.manhattanDistance(beacon);
      possibleBeacon
          .addAll(sensor.atManhattanDistanceCapped(distance + 1, 0, MAX));
      stdout.write(".");
    }
    print("");
    for (int i = 0; i < sensors.length; i++) {
      int distance = sensors[i].manhattanDistance(beacons[i]);
      for (var p in possibleBeacon.toList()) {
        if (sensors[i].manhattanDistance(p) <= distance)
          possibleBeacon.remove(p);
      }
    }
//    print (possibleBeacon);
    return possibleBeacon.first.x * MAX + possibleBeacon.first.y;
  }
}

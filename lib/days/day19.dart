import '../main.dart';

class Day19 extends Day {
  @override
  bool get completed => true;
  
  List<Blueprint> bps = [];

  @override
  init() {
    for (var line in inputList) {
      Blueprint b = Blueprint(line);
      bps.add(b);
    }
  }

  @override
  part1() {
    var start = DateTime.now().millisecondsSinceEpoch;
    var total = 0;
    for (Blueprint b in bps) {
      int m = b.maxCollect(24);
      int qualityLevel = m * int.parse(b.id);
      var end = DateTime.now().millisecondsSinceEpoch;
      print(
          "Blueprint ${b.id} -> $m  QL: $qualityLevel  (${(end - start) ~/ 1000})");
      total += qualityLevel;
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${(end - start) ~/ 1000}");
    return total;
  }

  @override
  part2() {
    var start = DateTime.now().millisecondsSinceEpoch;
    var total = 1;
    for (Blueprint b in bps.take(3)) {
      int m = b.maxCollect(32);
      var end = DateTime.now().millisecondsSinceEpoch;
      print("Blueprint ${b.id} -> $m  (${(end - start) ~/ 1000})");
      total *= m;
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print("Time: ${(end - start) ~/ 1000}");
    return total;
  }
}

class Blueprint {
  late String id;
  List<Robot> robotsDef = [];
  Map<StateS, int> cache = {};

  Blueprint(String line) {
    var p = line.split(" ");
    id = p[1].replaceAll(":", "");
    line = line.split(":")[1].trim();
    var rLines = line.split(".");
    for (var rLine in rLines) {
      if (rLine.trim() != "") robotsDef.add(Robot(rLine.trim()));
    }
  }

  int maxCollect(int seconds) {
    var initState = StateS(0, 0, 0, 0, 1, 0, 0, 0, 24 - seconds);
    return step(initState);
  }

  int step(StateS state) {
    if (cache[state] != null) {
      return cache[state]!;
    }
    if (state.minute == 24) {
      return state.geode;
    }
    int max = 0;
    bool robotBuild = false;
    if (robotsDef[3].canBeBuilt(state)) {
      robotBuild = true;
      var newState = state.copy();
      newState.ore -= robotsDef[3].cost['ore'] ?? 0;
      newState.clay -= robotsDef[3].cost['clay'] ?? 0;
      newState.obsidian -= robotsDef[3].cost['obsidian'] ?? 0;
      newState.evolve();
      newState.geodeR++;
      var m1 = step(newState);
      if (m1 > max) max = m1;
    } else {
      for (var r in robotsDef.take(3)) {
        if (r.canBeBuilt(state)) {
          robotBuild = true;
          var newState = state.copy();
          newState.ore -= r.cost['ore'] ?? 0;
          newState.clay -= r.cost['clay'] ?? 0;
          newState.obsidian -= r.cost['obsidian'] ?? 0;
          newState.evolve();
          if (r.type == "ore") newState.oreR++;
          if (r.type == "clay") newState.clayR++;
          if (r.type == "obsidian") newState.obsidianR++;
          var m1 = step(newState);
          if (m1 > max) max = m1;
        }
      }
      var newState = state.copy();
      newState.evolve();
      var m1 = step(newState);
      if (m1 > max) max = m1;
    }
    cache[state] = max;
    return max;
  }
}

class StateS {
  int ore, clay, obsidian, geode;
  int oreR, clayR, obsidianR, geodeR;
  int minute;

  StateS(this.ore, this.clay, this.obsidian, this.geode, this.oreR, this.clayR,
      this.obsidianR, this.geodeR, this.minute);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateS && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  StateS copy() {
    return StateS(
        ore, clay, obsidian, geode, oreR, clayR, obsidianR, geodeR, minute);
  }

  @override
  String toString() =>
      "$minute: $ore,$clay,$obsidian,$geode,$oreR,$clayR,$obsidianR,$geodeR";

  void evolve() {
    ore += oreR;
    clay += clayR;
    obsidian += obsidianR;
    geode += geodeR;
    minute++;
    if (ore > (24 - minute) * 4) ore = (24 - minute) * 4;
  }
}

class Robot {
  late String type;
  Map<String, int> cost = {};

  Robot(String line) {
    var p = line.split(" ");
    type = p[1];
    var q = int.parse(p[4]);
    var t = p[5].replaceAll(".", "");
    cost[t] = q;
    if (p.length > 6) {
      var q = int.parse(p[7]);
      var t = p[8].replaceAll(".", "");
      cost[t] = q;
    }
  }

  bool canBeBuilt(StateS state) {
    if (state.oreR == 4 && type == "ore") return false;
    if (state.ore < (cost["ore"] ?? 0)) return false;
    if (state.clay < (cost["clay"] ?? 0)) return false;
    if (state.obsidian < (cost["obsidian"] ?? 0)) return false;
    return true;
  }

  @override
  String toString() => "R[$type]";
}

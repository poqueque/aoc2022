import '../main.dart';
import 'package:collection/collection.dart';

class Day16 extends Day {
  @override
  bool get completed => true;

  Function eq = const ListEquality().equals;
  Map<String, Valve> valves = {};
  Set<String> opened = {};
  Map<State, int> cache = {};
  Map<State2, int> cache2 = {};
  late int nonNullValves;

  @override
  init() {
    for (var line in inputList) {
      Valve v = Valve.fromLine(line);
      valves[v.id] = v;
//      print(v);
    }
    nonNullValves = valves.values.where((element) => element.rate > 0).length;
  }

  int start = DateTime.now().millisecondsSinceEpoch;

  @override
  part1() {
    var pressure = 0;
    var max = step(pressure, 1, opened, "AA", {});
//    int end = DateTime.now().millisecondsSinceEpoch;
//    print ("Time: ${end - start}");
    return max;
  }

  @override
  part2() {
    cache.clear();
    opened = {};
    var max1 = step2(0, 5, opened, "AA", {"AA"}, true, path: []);
    //int end = DateTime.now().millisecondsSinceEpoch;
    //print ("Time: ${end - start}");
    return max1;
  }

  int maxP = 0;

  int step2(int pressure, int minutes, Set<String> opened,
      String currentValveId, Set<String> visited, bool first,
      {List<String>? path}) {
    if (cache2[State2(currentValveId, opened, minutes, first)] != null)
      return cache2[State2(currentValveId, opened, minutes, first)]!;
    if (minutes == 20 && first == true && pressure < 800) return 0;
    if (minutes == 20 && first == false && pressure < 1600) return 0;

    var currentValve = valves[currentValveId]!;
    if (opened.length == nonNullValves) {
      return pressure;
    }
    if (minutes == 30) {
      if (first) {
        return step2(pressure, 5, opened, "AA", {"AA"}, false);
      } else {
        if (pressure > maxP) {
          maxP = pressure;
//          print (maxP);
//          int end = DateTime.now().millisecondsSinceEpoch;
//          print ("Pressure - $currentValveId, $opened, $minutes, $first - ${end-start}");
        }
        return pressure;
      }
    }
    int max = pressure;
    // if (eq(path,["II", "JJ", "open", "II", "AA", "BB", "open", "CC"])) {
    //   print("[$minutes] $pressure -> $path");
    // }
    if (!opened.contains(currentValveId) && currentValve.rate > 0) {
      Set<String> o = {};
      o.addAll(opened);
      o.add(currentValveId);
      List<String>? p;
      if (path != null) {
        p = List.from(path);
        p.add("open");
      }
      var s1 = step2(pressure + currentValve.rate * (30 - minutes), minutes + 1,
          o, currentValveId, {currentValveId}, first,
          path: p);
      if (s1 > max) max = s1;
    }
    for (String v in currentValve.leads) {
      if (!visited.contains(v)) {
        Set<String> vis = {};
        vis.addAll(visited);
        vis.add(v);
        List<String>? p;
        if (path != null) {
          p = List.from(path);
          p.add(v);
        }
        var s1 = step2(pressure, minutes + 1, opened, valves[v]!.id, vis, first,
            path: p);
        if (s1 > max) max = s1;
      }
    }
    if (minutes < 30 && first) {
      var s3 = step2(pressure, 5, opened, "AA", {"AA"}, false, path: []);
      if (s3 > max) max = s3;
    }
    cache2[State2(currentValveId, opened, minutes, first)] = max;
    if (max > maxP) {
      maxP = max;
//      print (maxP);
//      print ("$currentValveId, $opened, $minutes, $first");
    }
    return max;
  }

  int step(int pressure, int minutes, Set<String> opened, String currentValveId,
      Set<String> visited,
      {List<String>? path}) {
    if (cache[State(currentValveId, opened, minutes)] != null)
      return cache[State(currentValveId, opened, minutes)]!;

    var currentValve = valves[currentValveId]!;
    // if (eq(path,["DD", "open", "CC", "BB", "open", "AA", "II", "JJ", "open", "II", "AA", "DD", "EE", "FF", "GG", "HH", "open", "GG","FF","EE"])) {
    //   print("[$minutes] $pressure -> $path");
    // }
    if (minutes == 30) {
      return pressure;
    }
    int max = pressure;
    if (!opened.contains(currentValveId) && currentValve.rate > 0) {
      Set<String> o = {};
      o.addAll(opened);
      o.add(currentValveId);
      List<String>? p;
      if (path != null) {
        p = List.from(path);
        p.add("open");
      }
      var s1 = step(pressure + currentValve.rate * (30 - minutes), minutes + 1,
          o, currentValve.id, {currentValveId},
          path: p);
      if (s1 > max) max = s1;
    }
    if (eq(path, [
      "DD",
      "open",
      "CC",
      "BB",
      "open",
      "AA",
      "II",
      "JJ",
      "open",
      "II",
      "AA",
      "DD",
      "EE"
    ])) {
      print("[$minutes] $pressure -> $path");
    }
    for (String v in currentValve.leads) {
      if (!visited.contains(v)) {
        Set<String> vis = Set.from(visited);
        vis.add(v);
        List<String>? p;
        if (path != null) {
          p = List.from(path);
          p.add(v);
        }
        var s1 =
            step(pressure, minutes + 1, opened, valves[v]!.id, vis, path: p);
        if (s1 > max) max = s1;
      }
    }
    cache[State(currentValveId, opened, minutes)] = max;
    return max;
  }
}

class Solution {
  final int value;
  final Set<String> opened;

  Solution(this.value, this.opened);
}

class State {
  final String position;
  final Set<String> opened;
  final int minutes;

  State(this.position, this.opened, this.minutes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          opened == other.opened &&
          minutes == other.minutes;

  @override
  int get hashCode => position.hashCode ^ opened.hashCode ^ minutes.hashCode;
}

class State2 {
  final String position;
  final Set<String> opened;
  final int minutes;
  final bool first;

  State2(this.position, this.opened, this.minutes, this.first);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State2 &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          opened == other.opened &&
          first == other.first &&
          minutes == other.minutes;

  @override
  int get hashCode =>
      position.hashCode ^ opened.hashCode ^ minutes.hashCode ^ first.hashCode;
}

class Valve {
  late final String id;
  late final int rate;
  late final List<String> leads;

  Valve(this.id, this.rate, this.leads);

  Valve.fromLine(String line) {
    var p = line.split(" ");
    id = p[1];
    rate = int.parse(p[4].split("=")[1].replaceAll(";", ""));
    leads = line
        .split("valv")[1]
        .split(" ")
        .map((e) => e.replaceAll(",", ""))
        .toList();
    leads.removeAt(0);
  }

  @override
  String toString() => "$id $rate $leads";
}

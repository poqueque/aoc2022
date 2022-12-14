import 'dart:convert';
import 'dart:math';
import '../main.dart';

class Day13 extends Day {
  @override
  init() {}

  @override
  part1() {
    var total = 0;
    for (var i = 0; i < inputList.length; i+=3) {
      var p1 = inputList[i];
      var p2 = inputList[i + 1];
      var p1json = jsonDecode(p1) as List<dynamic>;
      var p2json = jsonDecode(p2) as List<dynamic>;
      int result = compare(p1json, p2json);
//      print ("result: $result");
//      print("");
      if (result == 1) total+=((i~/3)+1);
    }
    return total;
  }

  @override
  part2() {
    List data = [];
    var total = 0;
    for (var i = 0; i < inputList.length; i++) {
      if (inputList[i].isNotEmpty){
        data.add(jsonDecode(inputList[i]) as List<dynamic>);
      }
    }
    var sep1 = [[2]];
    var sep2 = [[6]];
    data.add(sep1);
    data.add(sep2);
    data.sort(compare);
    data = data.reversed.toList();
    var p1 = data.indexOf(sep1)+1;
    var p2 = data.indexOf(sep2)+1;
    print (p1);
    print (p2);
    return p1*p2;
  }

  int compare(p1json, p2json) {
//    print ("compare: $p1json <-> $p2json");
    if (p1json == null && p2json != null) {
      return 1;
    }
    if (p1json != null && p2json == null) {
      return -1;
    }
    if (p1json is int && p2json is int) {
      if (p1json < p2json) return 1;
      if (p1json > p2json) return -1;
      return 0;
    }
    if (p1json is int && p2json is List) {
      return compare([p1json], p2json);
    }
    if (p1json is List && p2json is int) {
      return compare(p1json, [p2json]);
    }
    if (p1json is List && p2json is List) {
      for (int i = 0; i < max(p1json.length, p2json.length); i++) {
        if (p1json.length <= i) return 1;
        if (p2json.length <= i) return -1;
        var c = compare(p1json[i], p2json[i]);
        if (c != 0) return c;
      }
    }
    return 0;
  }
}

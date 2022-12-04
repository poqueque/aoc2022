import '../main.dart';

class Day04 extends Day {
  @override
  bool get completed => true;

  @override
  part1() {
    var overlap = 0;
    inputList.forEach((element) {
      var p1 = element.split(",");
      var r1 = p1[0].split("-").map((e) => int.parse(e)).toList();
      var r2 = p1[1].split("-").map((e) => int.parse(e)).toList();
      if (r1[0] <= r2[0] && r1[1] >= r2[1]) {
        overlap++;
      } else if (r2[0] <= r1[0] && r2[1] >= r1[1]) {
        overlap++;
      }
    });
    return overlap;
  }

  @override
  part2() {
    var overlap = 0;
    inputList.forEach((element) {
      var p1 = element.split(",");
      var r1 = p1[0].split("-").map((e) => int.parse(e)).toList();
      var r2 = p1[1].split("-").map((e) => int.parse(e)).toList();
      if (r1[1] < r2[0]) {
        overlap++;
      } else if (r2[1] < r1[0]) {
        overlap++;
      }
    });
    return inputList.length - overlap;
  }
}

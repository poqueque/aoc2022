import '../main.dart';

class Day02 extends Day {

  @override
  bool get completed => true;

  @override
  part1() {
    int total = 0;
    inputList.forEach((element) {
      var parts = element.split(" ");
      var elf = parts[0];
      var me = parts[1];
      total += points(me) + winner(elf, me);
    });
    return total;
  }

  @override
  part2() {    int total = 0;
  inputList.forEach((element) {
    var parts = element.split(" ");
    var elf = parts[0];
    var me = parts[1];
    total += points2(elf, me) + winner2(me);
  });
  return total;
  }

  int points(String me) {
    if (me == "X") return 1;
    if (me == "Y") return 2;
    if (me == "Z") return 3;
    return 0;
  }

  int winner(String elf, String me) {
    if (elf == "A" && me == "X") return 3;
    if (elf == "A" && me == "Y") return 6;
    if (elf == "A" && me == "Z") return 0;

    if (elf == "B" && me == "X") return 0;
    if (elf == "B" && me == "Y") return 3;
    if (elf == "B" && me == "Z") return 6;

    if (elf == "C" && me == "X") return 6;
    if (elf == "C" && me == "Y") return 0;
    if (elf == "C" && me == "Z") return 3;
    return 0;
  }

  int points2(String elf, String me) {
    if (elf == "A" && me == "X") return 3;
    if (elf == "A" && me == "Y") return 1;
    if (elf == "A" && me == "Z") return 2;

    if (elf == "B" && me == "X") return 1;
    if (elf == "B" && me == "Y") return 2;
    if (elf == "B" && me == "Z") return 3;

    if (elf == "C" && me == "X") return 2;
    if (elf == "C" && me == "Y") return 3;
    if (elf == "C" && me == "Z") return 1;
    return 0;
  }

  int winner2(String me) {
    if (me == "X") return 0;
    if (me == "Y") return 3;
    if (me == "Z") return 6;
    return 0;
  }
}
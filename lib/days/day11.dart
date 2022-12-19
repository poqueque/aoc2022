
import '../main.dart';

class Day11 extends Day {
  @override
  bool get completed => true;

  static Map<int, Monkey> m = {};

  //static const modMax = 13*17*19*23;
  static const modMax = 3 * 11 * 7 * 2 * 19 * 5 * 17 * 13;

  @override
  init() {
    m.clear();
    late Monkey currentMonkey;
    for (var line in inputList) {
      var parts = line.trim().split(" ");
      if (parts.length > 1) {
        if (parts[0] == "Monkey") {
          currentMonkey = Monkey(int.parse(parts[1].replaceFirst(":", "")));
        }
        if (parts[0] == "Starting") {
          for (int i = 2; i < parts.length; i++)
            currentMonkey.items.add(int.parse(parts[i].replaceFirst(",", "")));
        }
        if (parts[0] == "Operation:") {
          var op = parts[4];
          var val = int.tryParse(parts[5]);
          currentMonkey.operation = op;
          currentMonkey.value = val;
        }
        if (parts[0] == "Test:") {
          var by = int.parse(parts[3]);
          currentMonkey.divisibleBy = by;
        }
        if (parts[1] == "true:") {
          var to = int.parse(parts[5]);
          currentMonkey.throwIfTrue = to;
        }
        if (parts[1] == "false:") {
          var to = int.parse(parts[5]);
          currentMonkey.throwIfFalse = to;
        }
        m[currentMonkey.id] = currentMonkey;
//        print(currentMonkey);
      }
    }
  }

  @override
  part1() {
    for (var round = 0; round < 20; round++) {
      for (int i = 0; i < m.length; i++) {
        m[i]!.operate(true);
      }
    }
    var inspected = m.values.map((e) => e.itemsInspected).toList();
    inspected.sort();
    inspected = inspected.reversed.toList();
    return inspected[0] * inspected[1];
  }

  @override
  part2() {
    init();
    for (var round = 1; round <= 10000; round++) {
      for (int i = 0; i < m.length; i++) {
        m[i]!.operate(false);
      }
      if (round % 1000 == 0 || round == 1 || round == 20) {
      }
    }
    var inspected = m.values.map((e) => e.itemsInspected).toList();
    inspected.sort();
    inspected = inspected.reversed.toList();
    return inspected[0] * inspected[1];
  }
}

class Monkey {
  int id;
  List<int> items = [];
  late String operation;
  int? value;
  late int throwIfTrue;
  late int throwIfFalse;
  late int divisibleBy;
  int itemsInspected = 0;

  Monkey(this.id);

  @override
  String toString() => "{$id: $items}";

  void operate(bool relieve) {
    List<int> newItems = [];
    while (items.length > 0) {
      itemsInspected++;
      int i = items.first;
      items.removeAt(0);
      if (operation == "*" && value != null) i = (i * value!) % Day11.modMax;
      if (operation == "+" && value != null) i = i + value!;
      if (operation == "*" && value == null) i = (i * i) % Day11.modMax;
      if (operation == "+" && value == null) i = i + i;
      if (i < 0) print("!!!! $i !!!!");
      if (relieve) i = i ~/ 3;
      if (i % divisibleBy == 0) {
        Day11.m[throwIfTrue]!.items.add(i);
      } else {
        Day11.m[throwIfFalse]!.items.add(i);
      }
    }
    items = newItems;
  }
}

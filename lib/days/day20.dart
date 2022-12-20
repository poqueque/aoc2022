import 'package:collection/collection.dart';

import '../main.dart';
import '../utils/pair.dart';

class Day20 extends Day {
  @override
  bool get completed => true;

  late List<int> data;

  @override
  init() {
    data = inputList.map((e) => int.parse(e)).toList();
  }

  @override
  part1() {
    return decrypt();
  }

  @override
  part2() {
    return decrypt(decryptKey: 811589153, mixTimes: 10);
  }

  int decrypt({int decryptKey = 1, int mixTimes = 1}) {
    var original =
        data.mapIndexed((index, element) => Pair(index, element * decryptKey));
    var moved = original.toList();
    for (int i = 0; i < mixTimes; i++) {
      for (var p in original) {
        var idx = moved.indexOf(p);
        moved.removeAt(idx);
        var pos = ((idx + p.right) % moved.length);
        moved.insert(pos, p);
      }
    }
    List<int> result = moved.map((e) => e.right).toList();
    var idx0 = result.indexOf(0);
    return result[(1000 + idx0) % moved.length] +
        result[(2000 + idx0) % moved.length] +
        result[(3000 + idx0) % moved.length];
  }

  List<int> mixing(List<int> data) {
    List<int> m = data.toList();
    for (var d in data) {
      int indexFrom = m.indexOf(d);
      int indexTo = indexFrom + d;
      if (indexTo < 0) indexTo += m.length - 1;
      if (indexTo >= m.length) indexTo -= m.length;
      int valAt = m[indexTo];
      if (valAt == d) {
        print("");
      }
      if (valAt != d) {
        m.remove(d);
        int posOfValAt = m.indexOf(valAt) + 1;
        if (posOfValAt == 0)
          m.add(d);
        else
          m.insert(posOfValAt, d);
      }
    }
    return m;
  }

  getGrooveCoordinates(List<int> m) {
    int val0 = m.indexOf(0);
    int a = m[(1000 + val0) % m.length];
    int b = m[(2000 + val0) % m.length];
    int c = m[(3000 + val0) % m.length];
    return a + b + c;
  }
}

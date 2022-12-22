import '../main.dart';

class Day21 extends Day {
  @override
  bool get completed => true;

  Map<String, int> values = {};
  Map<String, String> operations = {};

  @override
  init() {
    values.clear();
    operations.clear();
    for (var line in inputList) {
      var p = line.split(" ");
      var key = p[0].replaceAll(":", "");
      if (p.length == 2) {
        values[key] = int.parse(p[1]);
      } else {
        operations[key] = "${p[1]} ${p[2]} ${p[3]}";
      }
    }
  }

  @override
  part1() {
    while (operations.isNotEmpty) {
      for (var o in operations.entries.toList()) {
        var p = o.value.split(" ");
        if (values.containsKey(p[0]) && values.containsKey(p[2])) {
          if (p[1] == "+") {
            values[o.key] = values[p[0]]! + values[p[2]]!;
            operations.remove(o.key);
          }
          if (p[1] == "-") {
            values[o.key] = values[p[0]]! - values[p[2]]!;
            operations.remove(o.key);
          }
          if (p[1] == "*") {
            values[o.key] = values[p[0]]! * values[p[2]]!;
            operations.remove(o.key);
          }
          if (p[1] == "/") {
            values[o.key] = values[p[0]]! ~/ values[p[2]]!;
            operations.remove(o.key);
          }
        }
      }
    }
    return values["root"];
  }

  @override
  part2() {
    init();
    var p = operations["root"]!.split(" ");
    var eq1 = p[0];
    var eq2 = p[2];
    operations.remove("root");
    values.remove("humn");

    var opL = 0;
    while (opL != operations.length) {
      opL = operations.length;
      simplify();
    }

    var str = simplify2(
        "${operations[eq1] ?? values[eq1]} = ${operations[eq2] ?? values[eq2]}");
    for (int i = 0; i < 65; i++) str = simplify2(str);

    return str;
  }

  void simplify() {
    for (var o in operations.keys) {
      for (var v in values.keys) {
        operations[o] = operations[o]!.replaceAll(v, values[v]!.toString());
      }
    }
    for (var o in operations.keys.toList()) {
      var r = operate(operations[o]!);
      if (r != null) {
        values[o] = operate(operations[o]!)!;
        operations.remove(o);
      }
    }
  }

  int? operate(String operation) {
    var p = operation.split(" ");
    var e1 = int.tryParse(p[0]);
    var e2 = int.tryParse(p[2]);
    if (e1 != null && e2 != null) {
      if (p[1] == "+") {
        return e1 + e2;
      }
      if (p[1] == "-") {
        return e1 - e2;
      }
      if (p[1] == "*") {
        return e1 * e2;
      }
      if (p[1] == "/") {
        return e1 ~/ e2;
      }
    }
    return null;
  }

  String simplify2(String string) {
//    print("simplify2($string)");
    var p = string.split(" ");
    var v1 = int.tryParse(p[0]);
    var v2 = int.tryParse(p[2]);
    var v3 = int.tryParse(p[4]);
    var ops = p[1] + p[3];
    var str = "";
    if (ops == "/=" && v1 == null) {
      values[p[0]] = v3! * v2!;
//      print("${p[0]} = ${values[p[0]]}");
      str = operations[p[0]]! + " = " + values[p[0]].toString();
    }
    if (ops == "*=" && v1 == null) {
      values[p[0]] = v3! ~/ v2!;
//      print("${p[0]} = ${values[p[0]]}");
      str = operations[p[0]]! + " = " + values[p[0]].toString();
    }
    if (ops == "+=" && v1 == null) {
      values[p[0]] = v3! - v2!;
//      print("${p[0]} = ${values[p[0]]}");
      str = operations[p[0]]! + " = " + values[p[0]].toString();
    }

    if (ops == "-=" && v1 == null) {
      values[p[0]] = v3! + v2!;
//      print("${p[0]} = ${values[p[0]]}");
      if (p[0] == "humn") return values[p[0]].toString();
      str = operations[p[0]]! + " = " + values[p[0]].toString();
    }

    if (ops == "/=" && v2 == null) {
      values[p[2]] = v1! ~/ v3!;
//      print("${p[2]} = ${values[p[2]]}");
      str = operations[p[2]]! + " = " + values[p[2]].toString();
    }

    if (ops == "*=" && v2 == null) {
      values[p[2]] = v3! ~/ v1!;
//      print("${p[2]} = ${values[p[2]]}");
      str = operations[p[2]]! + " = " + values[p[2]].toString();
    }

    if (ops == "+=" && v2 == null) {
      values[p[2]] = v3! - v1!;
//      print("${p[2]} = ${values[p[2]]}");
      str = operations[p[2]]! + " = " + values[p[2]].toString();
    }

    if (ops == "-=" && v2 == null) {
      values[p[2]] = v1! - v3!;
//      print("${p[2]} = ${values[p[2]]}");
      str = operations[p[2]]! + " = " + values[p[2]].toString();
    }

    var opL = 0;
    while (opL != operations.length) {
      opL = operations.length;
      simplify();
//      print("Operations: ${operations.length}");
    }
    return str;
  }
}

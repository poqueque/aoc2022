import 'dart:io';
import 'days/day01.dart';
import 'days/day02.dart';

abstract class Day {

  late final List<String> inputList;
  late final String inputString;
  bool completed = false;
  dynamic part1();
  dynamic part2();

  String get dataFileName => "${runtimeType.toString().toLowerCase()}.txt";

  void run() async {
    inputList = await File("data/$dataFileName").readAsLines();
    inputString = inputList[0];
    print(part1());
    print(part2());
  }
}

void main() {
  List<Day> days = [Day01(), Day02()];
  var dayToRun = days.firstWhere((day) => !day.completed);
  print("Running ${dayToRun.runtimeType.toString()}");
  dayToRun.run();
}


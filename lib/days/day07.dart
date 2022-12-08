import '../main.dart';

class Day07 extends Day {
  @override
  bool get completed => true;

  Dir root = Dir("/", null);

  @override
  part1() {
    Dir currentDir = root;
    Map<String, Dir> dirs = {root.name: root};
    for (var line in inputList) {
      var w = line.split(" ");
      if (line.startsWith("\$ cd")) {
        if (w[2] == "/")
          currentDir = root;
        else if (w[2] == "..") {
          currentDir = currentDir.parent ?? root;
        } else {
          var targetDir = currentDir.name + "/" + w[2];
          dirs[targetDir] ??= Dir(targetDir, currentDir);
          currentDir = dirs[targetDir]!;
        }
      } else if (!line.startsWith("\$")) {
        if (w[0] == "dir") {
          var targetDir = currentDir.name + "/" + w[1];
          var newDir = Dir(targetDir, currentDir);
          dirs[targetDir] ??= newDir;
          currentDir.dirs.add(newDir);
        } else {
          currentDir.files.add(Fil(int.parse(w[0]), w[1]));
        }
      }
    }

    var totalSize = 0;
    for (var d in dirs.values) {
      if (d.size <= 100000) {
        totalSize += d.size;
        print("${d.name} => ${d.size}");
      }
    }
    return totalSize;
  }

  @override
  part2() {
    var totalFiles = 0;
    Dir currentDir = root;
    Map<String, Dir> dirs = {root.name: root};
    for (var line in inputList) {
      var w = line.split(" ");
      if (line.startsWith("\$ cd")) {
        if (w[2] == "/")
          currentDir = root;
        else if (w[2] == "..") {
          currentDir = currentDir.parent ?? root;
        } else {
          var targetDir = currentDir.name + "/" + w[2];
          dirs[targetDir] ??= Dir(targetDir, currentDir);
          currentDir = dirs[targetDir]!;
        }
      } else if (!line.startsWith("\$")) {
        if (w[0] == "dir") {
          var targetDir = currentDir.name + "/" + w[1];
          var newDir = Dir(targetDir, currentDir);
          dirs[targetDir] ??= newDir;
          if (currentDir.dirs.where((e) => e.name == newDir.name).isEmpty)
            currentDir.dirs.add(newDir);
        } else {
          if (currentDir.files.where((e) => e.name == w[1]).isEmpty) {
            currentDir.files.add(Fil(int.parse(w[0]), w[1]));
            totalFiles += int.parse(w[0]);
          }
        }
      }
    }

    print("");
    print("Total files: $totalFiles");
    for (var d in dirs.values) {
      print("${d.name} => ${d.size}");
    }
    print("");

    var totalSpace = 70000000;
    var needToFree = 30000000 - totalSpace + root.size;
    print("${root.name} => ${root.size}  - Need to free: $needToFree");

    var selected = root;
    for (var d in dirs.values) {
      if (d.size >= needToFree && d.size < selected.size) {
        print("${d.name} => ${d.size}");
        selected = d;
      }
    }
    return selected.size;
  }
}

class Dir {
  final String name;
  Dir? parent;
  List<Dir> dirs = [];
  List<Fil> files = [];

  Dir(this.name, this.parent);

  int get size {
    var s = 0;
    for (var f in files) {
      s += f.size;
    }
    for (var d in dirs) {
      s += d.size;
    }
    return s;
  }
}

class Fil {
  final int size;
  final String name;

  Fil(this.size, this.name);
}

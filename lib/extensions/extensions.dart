extension StringExtensions on String {
  List<String> get chars =>
      runes.map((int rune) => String.fromCharCode(rune)).toList();

  String changeAt(int pos, String val) =>
      this.substring(0, pos) + val + this.substring(pos + 1);
}

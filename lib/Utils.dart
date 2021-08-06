extension StringExtension on String {
  String authReturn() {
    return "${this[0].toUpperCase()}${this.substring(1)}".replaceAll('-', ' ');
  }
}
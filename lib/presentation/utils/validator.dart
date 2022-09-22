class Validator {
  static bool nameValid(String value) {
    final name = RegExp("[a-zA-Z][a-zA-Z0-9-_@]{3,32}");

    return name.hasMatch(value);
  }
}

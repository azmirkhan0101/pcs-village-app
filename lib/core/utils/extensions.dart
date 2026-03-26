extension DoubleFormatter on double {
  String toSmartString() {
    // If it's a whole number (e.g., 100.0), return as integer string
    if (this == truncateToDouble()) {
      return toStringAsFixed(0);
    }
    // Otherwise, show up to 2 decimal places, but remove trailing zeros
    // Example: 5.50 becomes 5.5
    RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");
    return toStringAsFixed(2).replaceAll(regex, "");
  }
}
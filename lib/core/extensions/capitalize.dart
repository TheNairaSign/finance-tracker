/// An extension on `String` to capitalize the first letter.
extension CapitalizeFirstLetterExtension on String {
  /// Capitalizes the first letter of the string.
  ///
  /// If the string is empty, it returns an empty string.
  ///
  /// Example usage:
  /// ```dart
  /// final greeting = 'hello world';
  /// print(greeting.capitalize()); // Prints: 'Hello world'
  /// ```
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    return this[0].toUpperCase() + substring(1);
  }
}
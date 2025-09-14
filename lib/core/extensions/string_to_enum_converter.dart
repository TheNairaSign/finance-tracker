/// An extension on `String` to easily convert a string representation to an enum value.
extension StringToEnumExtension on String {
  /// Converts a string to its corresponding enum value from a list of all enum values.
  ///
  /// The method searches the provided list of enum values for a match.
  /// It compares the end of the enum's full string representation
  /// (e.g., `MyEnum.value`) with the current string instance.
  ///
  /// Throws a [StateError] if no matching enum value is found.
  ///
  /// Example usage:
  /// ```dart
  /// enum MyColor { red, green, blue }
  ///
  /// final colorString = 'green';
  /// final myColor = colorString.toEnum(MyColor.values);
  /// print(myColor); // Prints: MyColor.green
  /// ```
  T toEnum<T>(List<T> enumValues) {
    final regex = RegExp(r'.*\.(.*)$');

    for (final T value in enumValues) {
      final match = regex.firstMatch(value.toString());
      if (match != null && match.group(1) == this) {
        return value;
      }
    }

    throw StateError('No enum value found for string: $this');
  }
}

// --- Example Usage ---

/// A sample enum to demonstrate the extension with predefined values.
enum Category { health, food, data, travel }

final Set<String> allCategories = Set<String>.from(Category.values.map((e) => e.name));

void main() {
  // A set to store all possible categories, including custom ones.
  // We initialize it with the values from our fixed Category enum.


  // A string from a user, potentially from a button press.
  final userString = 'food';

  // We can use the extension for our predefined enums.
  try {
    final categoryEnum = userString.toEnum(Category.values);
    print('Converted "$userString" to enum: $categoryEnum');
  } catch (e) {
    print('Error converting "$userString": ${e.toString()}');
  }

  print('');

  // Now, a user wants to add a custom category.
  final customCategoryString = 'finances';
  print('User wants to add a custom category: "$customCategoryString"');
  // We can't add this to the enum, but we can add it to our dynamic set.
  allCategories.add(customCategoryString);

  print('Current list of all categories: $allCategories');

  print('');

  // Example of using the dynamic list to check for a category.
  final anotherUserString = 'travel';
  if (allCategories.contains(anotherUserString)) {
    print('The category "$anotherUserString" exists in our dynamic set.');
    // And for the predefined ones, we can still use our extension.
    try {
      final categoryEnum = anotherUserString.toEnum(Category.values);
      print('It\'s a predefined enum: $categoryEnum');
    } catch (e) {
      print('It\'s a custom category, not a predefined enum.');
    }
  }

  print('');

  final anotherCustomString = 'finances';
  if (allCategories.contains(anotherCustomString)) {
    print('The category "$anotherCustomString" exists in our dynamic set.');
    // This will throw an error since it's not a predefined enum.
    try {
      anotherCustomString.toEnum(Category.values);
    } catch (e) {
      print('As expected, it\'s not a predefined enum: ${e.toString()}');
    }
  }
}
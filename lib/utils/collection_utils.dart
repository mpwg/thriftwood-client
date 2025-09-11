/// Custom collection utilities to replace external collection package dependency.
/// 
/// This file provides extension methods on Iterable that were previously 
/// provided by the `collection` package, specifically `firstWhereOrNull`.
library collection_utils;

/// Extension on [Iterable] to provide additional utility methods.
extension IterableExtensions<E> on Iterable<E> {
  /// Returns the first element that satisfies the given predicate [test],
  /// or `null` if no element satisfies the predicate.
  ///
  /// Unlike [Iterable.firstWhere], this method returns `null` instead of
  /// throwing an exception when no element is found.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final evenNumber = numbers.firstWhereOrNull((n) => n.isEven); // Returns 2
  /// final bigNumber = numbers.firstWhereOrNull((n) => n > 10); // Returns null
  /// ```
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
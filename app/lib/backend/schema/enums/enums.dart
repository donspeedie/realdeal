import 'package:collection/collection.dart';

/// Choose one of the values below
///
/// Sold
///
/// ForSale
///
/// Default: ForSale
enum SearchType {
  Sold,
  ForSale,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (SearchType):
      return SearchType.values.deserialize(value) as T?;
    default:
      return null;
  }
}

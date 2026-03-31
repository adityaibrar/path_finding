import '../entities/sort_item.dart';

enum SortAlgorithmType {
  bubble,
  selection,
  insertion,
}

abstract class SortingRepository {
  /// Mengembalikan urutan langkah demi langkah secara lengkap (snapshots) dari array.
  List<List<SortItem>> executeAlgorithm(
    List<SortItem> array,
    SortAlgorithmType type,
  );
}

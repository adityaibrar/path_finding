import '../entities/sort_item.dart';
import '../repositories/sorting_repository.dart';

class RunSortUseCase {
  final SortingRepository repository;

  RunSortUseCase(this.repository);

  List<List<SortItem>> call(
    List<SortItem> array,
    SortAlgorithmType type,
  ) {
    return repository.executeAlgorithm(array, type);
  }
}

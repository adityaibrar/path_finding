import '../../domain/entities/sort_item.dart';
import '../../domain/repositories/sorting_repository.dart';

class SortingRepositoryImpl implements SortingRepository {
  @override
  List<List<SortItem>> executeAlgorithm(
    List<SortItem> array,
    SortAlgorithmType type,
  ) {
    switch (type) {
      case SortAlgorithmType.bubble:
        return _bubbleSort(array);
      case SortAlgorithmType.selection:
        return _selectionSort(array);
      case SortAlgorithmType.insertion:
        return _insertionSort(array);
    }
  }

  // Helper untuk merekam frame snapshot pada setiap interaksi penting (animasi frame-by-frame)
  List<SortItem> _clone(List<SortItem> source) {
    return source.map((e) => e.copyWith()).toList();
  }

  List<List<SortItem>> _bubbleSort(List<SortItem> array) {
    final snapshots = <List<SortItem>>[];
    final current = _clone(array);
    
    int n = current.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        current[j].state = SortItemState.comparing;
        current[j + 1].state = SortItemState.comparing;
        snapshots.add(_clone(current));

        if (current[j].value > current[j + 1].value) {
          current[j].state = SortItemState.swapping;
          current[j + 1].state = SortItemState.swapping;
          snapshots.add(_clone(current));

          final temp = current[j];
          current[j] = current[j + 1];
          current[j + 1] = temp;
          snapshots.add(_clone(current));
        }

        current[j].state = SortItemState.normal;
        current[j + 1].state = SortItemState.normal;
      }
      current[n - i - 1].state = SortItemState.sorted;
      snapshots.add(_clone(current));
    }
    current[0].state = SortItemState.sorted;
    snapshots.add(_clone(current));

    return snapshots;
  }

  List<List<SortItem>> _selectionSort(List<SortItem> array) {
    final snapshots = <List<SortItem>>[];
    final current = _clone(array);
    snapshots.add(_clone(current));

    int n = current.length;
    for (int i = 0; i < n - 1; i++) {
      int minIdx = i;
      current[minIdx].state = SortItemState.swapping; // Min current
      
      for (int j = i + 1; j < n; j++) {
        current[j].state = SortItemState.comparing;
        snapshots.add(_clone(current));

        if (current[j].value < current[minIdx].value) {
          if (minIdx != i) {
            current[minIdx].state = SortItemState.normal;
          }
          minIdx = j;
          current[minIdx].state = SortItemState.swapping;
          snapshots.add(_clone(current));
        } else {
          current[j].state = SortItemState.normal;
        }
      }

      if (minIdx != i) {
        final temp = current[minIdx];
        current[minIdx] = current[i];
        current[i] = temp;
        snapshots.add(_clone(current));
      }

      current[minIdx].state = SortItemState.normal;
      current[i].state = SortItemState.sorted;
      snapshots.add(_clone(current));
    }
    
    current[n - 1].state = SortItemState.sorted;
    snapshots.add(_clone(current));

    return snapshots;
  }

  List<List<SortItem>> _insertionSort(List<SortItem> array) {
    final snapshots = <List<SortItem>>[];
    final current = _clone(array);

    int n = current.length;
    current[0].state = SortItemState.sorted;
    
    for (int i = 1; i < n; ++i) {
      SortItem key = current[i];
      int j = i - 1;

      key.state = SortItemState.swapping;
      current[i] = key;
      snapshots.add(_clone(current));

      while (j >= 0 && current[j].value > key.value) {
        current[j].state = SortItemState.comparing;
        snapshots.add(_clone(current));

        current[j + 1] = current[j];
        
        current[j].state = SortItemState.sorted; 
        
        j = j - 1;
        snapshots.add(_clone(current));
      }
      
      current[j + 1] = key;
      current[j + 1].state = SortItemState.sorted;
      
      // Pastikan semua di belakangnya kembali jadi sorted warnanya
      for(int k=0; k<=i; k++) {
        current[k].state = SortItemState.sorted;
      }
      snapshots.add(_clone(current));
    }

    return snapshots;
  }
}

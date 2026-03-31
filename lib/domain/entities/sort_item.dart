enum SortItemState {
  normal,      // Kondisi belum dicek
  comparing,   // Sedang dibandingan secara aktif
  swapping,    // Sedang ditukar letaknya
  sorted       // Sudah terurut pada posisinya yang benar
}

class SortItem {
  final int value;
  SortItemState state;

  SortItem({
    required this.value,
    this.state = SortItemState.normal,
  });

  SortItem copyWith({SortItemState? state}) {
    return SortItem(
      value: this.value,
      state: state ?? this.state,
    );
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/sort_item.dart';

class SortBarWidget extends StatelessWidget {
  final SortItem item;
  final double width;
  final double maxAvailableHeight;
  final int maxValueInArray;

  const SortBarWidget({
    super.key,
    required this.item,
    required this.width,
    required this.maxAvailableHeight,
    required this.maxValueInArray,
  });

  @override
  Widget build(BuildContext context) {
    // Normalisasi tinggi (Proporsi max 100 dengan total tinggi space)
    final double normalizedHeight = (item.value / maxValueInArray) * maxAvailableHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      width: width,
      height: normalizedHeight,
      decoration: BoxDecoration(
        color: _getBarColor(item.state),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        boxShadow: _getShadow(item.state),
      ),
    );
  }

  Color _getBarColor(SortItemState state) {
    switch (state) {
      case SortItemState.normal:
        return const Color(0xFFE2E8F0); // Slate 200 (Default)
      case SortItemState.comparing:
        return const Color(0xFFFBBF24); // Amber 400 (Menganalisa/Bandingkan)
      case SortItemState.swapping:
        return const Color(0xFFEF4444); // Red 500 (Aksi Swap)
      case SortItemState.sorted:
        return const Color(0xFF10B981); // Emerald 500 (Selesai pada posisinya)
    }
  }

  List<BoxShadow>? _getShadow(SortItemState state) {
    if (state == SortItemState.comparing || state == SortItemState.swapping) {
      return [
        BoxShadow(
          color: _getBarColor(state).withOpacity(0.4),
          blurRadius: 6,
          offset: const Offset(0, -2),
        )
      ];
    }
    return null;
  }
}

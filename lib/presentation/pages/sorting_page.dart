import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/sorting_repository.dart';
import '../providers/sorting_provider.dart';
import '../widgets/sort_bar_widget.dart';

class SortingPage extends StatelessWidget {
  const SortingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildVisualizerArea(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildControlPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Algoritma Pengurutan (Sorting)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tinjau iterasi memposisikan elemen dari algoritma dasar.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisualizerArea() {
    return Consumer<SortingProvider>(
      builder: (context, provider, child) {
        if (provider.array.isEmpty) return const SizedBox();

        // Cari tahu nilai maksimal dari array untuk mapping height responsive
        int maxValue = 1;
        for (var item in provider.array) {
          if (item.value > maxValue) maxValue = item.value;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double availableHeight = constraints.maxHeight;
            
            // Hitung lebar setiap balok menyesuaikan dengan jumlah elemen padding 1 kanan kiri
            final double barWidth = (availableWidth / provider.array.length) - 2; 

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: provider.array.map((item) {
                return SortBarWidget(
                  item: item,
                  width: barWidth,
                  maxAvailableHeight: availableHeight,
                  maxValueInArray: maxValue,
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Consumer<SortingProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAlgorithmSelector(provider),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: provider.isRunning ? null : () => provider.generateRandomArray(),
                      icon: const Icon(Icons.shuffle, size: 18),
                      label: const Text('Acak Array'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: provider.isRunning ? null : () => provider.executeAlgorithm(),
                      icon: provider.isRunning 
                          ? const SizedBox(
                              width: 18, 
                              height: 18, 
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                            )
                          : const Icon(Icons.play_arrow_rounded),
                      label: Text(provider.isRunning ? 'Sedang Sortir...' : 'Mulai Sorting'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlgorithmSelector(SortingProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortAlgorithmType>(
          value: provider.selectedAlgorithm,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: const [
            DropdownMenuItem(value: SortAlgorithmType.bubble, child: Text('Bubble Sort')),
            DropdownMenuItem(value: SortAlgorithmType.selection, child: Text('Selection Sort')),
            DropdownMenuItem(value: SortAlgorithmType.insertion, child: Text('Insertion Sort')),
          ],
          onChanged: provider.isRunning 
            ? null 
            : (value) {
                if (value != null) provider.setAlgorithm(value);
              },
        ),
      ),
    );
  }
}

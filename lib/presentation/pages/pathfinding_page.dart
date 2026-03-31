import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/pathfinding_repository.dart';
import '../providers/pathfinding_provider.dart';
import '../widgets/grid_widget.dart';

class PathfindingPage extends StatelessWidget {
  const PathfindingPage({super.key});

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
              const Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GridWidget(),
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
                'Algoritma Pencarian Rute',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Visualisasi interaktif algoritma pathfinding seperti BFS, A*, dll.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Consumer<PathfindingProvider>(
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
                      onPressed: provider.isRunning
                          ? null
                          : () => provider.clearPath(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset Rute'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: provider.isRunning
                          ? null
                          : () => provider.clearGrid(),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Hapus Grid'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: provider.isRunning
                          ? null
                          : () => provider.executeAlgorithm(),
                      icon: provider.isRunning
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        provider.isRunning ? 'Memproses...' : 'Mulai Simulasi',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  Widget _buildAlgorithmSelector(PathfindingProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AlgorithmType>(
          value: provider.selectedAlgorithm,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: const [
            DropdownMenuItem(
              value: AlgorithmType.bfs,
              child: Text('Breadth-First Search'),
            ),
            DropdownMenuItem(
              value: AlgorithmType.aStar,
              child: Text('A* Search (A-Star)'),
            ),
            DropdownMenuItem(
              value: AlgorithmType.dijkstra,
              child: Text('Dijkstra Algorithm'),
            ),
            DropdownMenuItem(
              value: AlgorithmType.dfs,
              child: Text('Depth-First Search'),
            ),
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

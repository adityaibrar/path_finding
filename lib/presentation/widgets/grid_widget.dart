import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pathfinding_provider.dart';
import 'node_widget.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PathfindingProvider>(
      builder: (context, provider, child) {
        if (provider.grid.isEmpty) return const SizedBox();

        return LayoutBuilder(
          builder: (context, constraints) {
            // Lebar maksimum container
            final double availableWidth = constraints.maxWidth;
            final double availableHeight = constraints.maxHeight;

            // Ukuran setiap node supaya pas
            final double nodeWidth = availableWidth / provider.cols;
            final double nodeHeight = availableHeight / provider.rows;
            final double nodeSize = (nodeWidth < nodeHeight ? nodeWidth : nodeHeight).floorToDouble();

            final double gridTotalWidth = nodeSize * provider.cols;
            final double gridTotalHeight = nodeSize * provider.rows;

            return Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  _handleDrag(details.localPosition, nodeSize, provider);
                },
                onPanDown: (details) {
                  _handleDrag(details.localPosition, nodeSize, provider);
                },
                child: Container(
                  width: gridTotalWidth,
                  height: gridTotalHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Stack(
                    children: [
                      for (int r = 0; r < provider.rows; r++)
                        for (int c = 0; c < provider.cols; c++)
                          Positioned(
                            top: r * nodeSize,
                            left: c * nodeSize,
                            child: NodeWidget(
                              node: provider.grid[r][c],
                              size: nodeSize,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleDrag(Offset localPosition, double nodeSize, PathfindingProvider provider) {
    if (provider.isRunning) return;

    final int col = (localPosition.dx / nodeSize).floor();
    final int row = (localPosition.dy / nodeSize).floor();

    if (row >= 0 && row < provider.rows && col >= 0 && col < provider.cols) {
      provider.setWall(row, col);
    }
  }
}

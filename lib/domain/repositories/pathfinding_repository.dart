import '../entities/node.dart';

// Jenis Algoritma yang didukung
enum AlgorithmType {
  bfs,
  aStar,
  dijkstra,
  dfs,
}

class PathfindingResult {
  final List<CustomNode> visitedNodesInOrder;
  final List<CustomNode> pathNodesInOrder;

  PathfindingResult({
    required this.visitedNodesInOrder,
    required this.pathNodesInOrder,
  });
}

abstract class PathfindingRepository {
  PathfindingResult executeAlgorithm(
    List<List<CustomNode>> grid,
    CustomNode startNode,
    CustomNode endNode,
    AlgorithmType type,
  );
}

enum NodeType {
  empty,
  start,
  end,
  wall,
  visited,
  visiting,
  path,
}

class CustomNode {
  final int id;
  final int row;
  final int col;
  NodeType type;

  // Variabel bantuan untuk algoritma pathfinding
  double distance = double.infinity;
  double heuristic = double.infinity;
  CustomNode? previousNode;
  bool isVisited = false;

  CustomNode({
    required this.id,
    required this.row,
    required this.col,
    this.type = NodeType.empty,
  });

  void reset() {
    if (type != NodeType.start && type != NodeType.end && type != NodeType.wall) {
      type = NodeType.empty;
    }
    distance = double.infinity;
    heuristic = double.infinity;
    previousNode = null;
    isVisited = false;
  }
}

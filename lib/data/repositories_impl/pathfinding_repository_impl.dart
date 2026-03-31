import 'dart:collection';
import '../../domain/entities/node.dart';
import '../../domain/repositories/pathfinding_repository.dart';

class PathfindingRepositoryImpl implements PathfindingRepository {
  @override
  PathfindingResult executeAlgorithm(
    List<List<CustomNode>> grid,
    CustomNode startNode,
    CustomNode endNode,
    AlgorithmType type,
  ) {
    // PENTING: Untuk memastikan kemurnian state setiap menjalankan algoritma,
    // Kita bekerja dengan salinan data tetapi karena Dart menggunakan reference,
    // proses mapping grid ada di layer Provider agar tidak bermasalah dengan render.
    
    switch (type) {
      case AlgorithmType.bfs:
        return _runBfs(grid, startNode, endNode);
      case AlgorithmType.aStar:
        return _runAStar(grid, startNode, endNode);
      case AlgorithmType.dijkstra:
        return _runDijkstra(grid, startNode, endNode);
      case AlgorithmType.dfs:
        return _runDfs(grid, startNode, endNode);
    }
  }

  PathfindingResult _runBfs(List<List<CustomNode>> grid, CustomNode startNode, CustomNode endNode) {
    final visitedNodes = <CustomNode>[];
    final queue = Queue<CustomNode>();
    
    startNode.distance = 0;
    startNode.isVisited = true;
    queue.add(startNode);
    visitedNodes.add(startNode);

    while (queue.isNotEmpty) {
      final currentNode = queue.removeFirst();
      
      if (currentNode.type == NodeType.wall) continue;
      
      if (currentNode.id == endNode.id) {
        return PathfindingResult(
          visitedNodesInOrder: visitedNodes,
          pathNodesInOrder: _getNodesInShortestPathOrder(endNode),
        );
      }

      final neighbors = _getUnvisitedNeighbors(currentNode, grid);
      for (final neighbor in neighbors) {
        if (!neighbor.isVisited && neighbor.type != NodeType.wall) {
          neighbor.isVisited = true;
          neighbor.previousNode = currentNode;
          queue.add(neighbor);
          visitedNodes.add(neighbor);
        }
      }
    }

    return PathfindingResult(
      visitedNodesInOrder: visitedNodes,
      pathNodesInOrder: [],
    );
  }

  PathfindingResult _runDijkstra(List<List<CustomNode>> grid, CustomNode startNode, CustomNode endNode) {
    final visitedNodes = <CustomNode>[];
    final unvisitedNodes = <CustomNode>[];
    
    for (final row in grid) {
      for (final node in row) {
        unvisitedNodes.add(node);
      }
    }
    
    startNode.distance = 0;

    while (unvisitedNodes.isNotEmpty) {
      unvisitedNodes.sort((a, b) => a.distance.compareTo(b.distance));
      final closestNode = unvisitedNodes.removeAt(0);

      if (closestNode.type == NodeType.wall) continue;
      if (closestNode.distance == double.infinity) break;

      closestNode.isVisited = true;
      visitedNodes.add(closestNode);

      if (closestNode.id == endNode.id) {
        return PathfindingResult(
          visitedNodesInOrder: visitedNodes,
          pathNodesInOrder: _getNodesInShortestPathOrder(endNode),
        );
      }

      final neighbors = _getUnvisitedNeighbors(closestNode, grid);
      for (final neighbor in neighbors) {
        if (!neighbor.isVisited && neighbor.type != NodeType.wall) {
          final newDistance = closestNode.distance + 1;
          if (newDistance < neighbor.distance) {
            neighbor.distance = newDistance;
            neighbor.previousNode = closestNode;
          }
        }
      }
    }

    return PathfindingResult(
      visitedNodesInOrder: visitedNodes,
      pathNodesInOrder: [],
    );
  }

  PathfindingResult _runDfs(List<List<CustomNode>> grid, CustomNode startNode, CustomNode endNode) {
    final visitedNodes = <CustomNode>[];
    final stack = <CustomNode>[];
    
    stack.add(startNode);
    
    while (stack.isNotEmpty) {
      final currentNode = stack.removeLast();
      
      if (!currentNode.isVisited && currentNode.type != NodeType.wall) {
        currentNode.isVisited = true;
        visitedNodes.add(currentNode);
        
        if (currentNode.id == endNode.id) {
          return PathfindingResult(
            visitedNodesInOrder: visitedNodes,
            pathNodesInOrder: _getNodesInShortestPathOrder(endNode),
          );
        }
        
        final neighbors = _getUnvisitedNeighbors(currentNode, grid);
        for (final neighbor in neighbors.reversed) {
          if (!neighbor.isVisited && neighbor.type != NodeType.wall) {
            neighbor.previousNode = currentNode;
            stack.add(neighbor);
          }
        }
      }
    }

    return PathfindingResult(
      visitedNodesInOrder: visitedNodes,
      pathNodesInOrder: [],
    );
  }

  PathfindingResult _runAStar(List<List<CustomNode>> grid, CustomNode startNode, CustomNode endNode) {
    final visitedNodes = <CustomNode>[];
    final openSet = <CustomNode>[startNode];
    
    startNode.distance = 0; // g-score
    startNode.heuristic = _calculateHeuristic(startNode, endNode); // h-score
    
    while (openSet.isNotEmpty) {
      openSet.sort((a, b) {
        final fA = a.distance + a.heuristic;
        final fB = b.distance + b.heuristic;
        if (fA == fB) return a.heuristic.compareTo(b.heuristic);
        return fA.compareTo(fB);
      });
      
      final currentNode = openSet.removeAt(0);
      currentNode.isVisited = true;
      visitedNodes.add(currentNode);
      
      if (currentNode.id == endNode.id) {
        return PathfindingResult(
          visitedNodesInOrder: visitedNodes,
          pathNodesInOrder: _getNodesInShortestPathOrder(endNode),
        );
      }
      
      final neighbors = _getUnvisitedNeighbors(currentNode, grid);
      for (final neighbor in neighbors) {
        if (neighbor.type == NodeType.wall || neighbor.isVisited) continue;
        
        final tentativeGScore = currentNode.distance + 1;
        bool inOpenSet = openSet.contains(neighbor);
        
        if (tentativeGScore < neighbor.distance) {
          neighbor.previousNode = currentNode;
          neighbor.distance = tentativeGScore;
          neighbor.heuristic = _calculateHeuristic(neighbor, endNode);
          
          if (!inOpenSet) {
            openSet.add(neighbor);
          }
        }
      }
    }
    
    return PathfindingResult(
      visitedNodesInOrder: visitedNodes,
      pathNodesInOrder: [],
    );
  }
  
  double _calculateHeuristic(CustomNode node, CustomNode endNode) {
    return ((node.row - endNode.row).abs() + (node.col - endNode.col).abs()).toDouble();
  }

  List<CustomNode> _getUnvisitedNeighbors(CustomNode node, List<List<CustomNode>> grid) {
    final neighbors = <CustomNode>[];
    if (node.row > 0) neighbors.add(grid[node.row - 1][node.col]); 
    if (node.col < grid[0].length - 1) neighbors.add(grid[node.row][node.col + 1]); 
    if (node.row < grid.length - 1) neighbors.add(grid[node.row + 1][node.col]); 
    if (node.col > 0) neighbors.add(grid[node.row][node.col - 1]); 

    return neighbors.where((n) => !n.isVisited).toList();
  }

  List<CustomNode> _getNodesInShortestPathOrder(CustomNode endNode) {
    final nodesInShortestPathOrder = <CustomNode>[];
    CustomNode? currentNode = endNode;
    
    while (currentNode != null) {
      nodesInShortestPathOrder.add(currentNode);
      currentNode = currentNode.previousNode;
    }
    
    return nodesInShortestPathOrder.reversed.toList();
  }
}

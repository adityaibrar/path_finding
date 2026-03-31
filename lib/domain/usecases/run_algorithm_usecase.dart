import '../entities/node.dart';
import '../repositories/pathfinding_repository.dart';

class RunAlgorithmUseCase {
  final PathfindingRepository repository;

  RunAlgorithmUseCase(this.repository);

  PathfindingResult call(
    List<List<CustomNode>> grid,
    CustomNode startNode,
    CustomNode endNode,
    AlgorithmType type,
  ) {
    return repository.executeAlgorithm(grid, startNode, endNode, type);
  }
}

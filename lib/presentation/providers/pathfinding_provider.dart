import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/node.dart';
import '../../domain/repositories/pathfinding_repository.dart';
import '../../domain/usecases/run_algorithm_usecase.dart';
import '../../data/repositories_impl/pathfinding_repository_impl.dart';

class PathfindingProvider extends ChangeNotifier {
  final RunAlgorithmUseCase _runAlgorithmUseCase;

  int rows = 15;
  int cols = 15;
  List<List<CustomNode>> _grid = [];

  AlgorithmType _selectedAlgorithm = AlgorithmType.bfs;
  bool _isRunning = false;

  // Posisi Start dan End default
  int _startRow = 7;
  int _startCol = 2;
  int _endRow = 7;
  int _endCol = 12;

  PathfindingProvider({RunAlgorithmUseCase? useCase})
    : _runAlgorithmUseCase =
          useCase ?? RunAlgorithmUseCase(PathfindingRepositoryImpl()) {
    _initializeGrid();
  }

  List<List<CustomNode>> get grid => _grid;
  AlgorithmType get selectedAlgorithm => _selectedAlgorithm;
  bool get isRunning => _isRunning;

  void _initializeGrid() {
    _grid = [];
    for (int r = 0; r < rows; r++) {
      List<CustomNode> rowNodes = [];
      for (int c = 0; c < cols; c++) {
        CustomNode node = CustomNode(
          id: r * cols + c,
          row: r,
          col: c,
          type: NodeType.empty,
        );

        if (r == _startRow && c == _startCol) {
          node.type = NodeType.start;
        } else if (r == _endRow && c == _endCol) {
          node.type = NodeType.end;
        }

        rowNodes.add(node);
      }
      _grid.add(rowNodes);
    }
    notifyListeners();
  }

  void setAlgorithm(AlgorithmType type) {
    if (_isRunning) return;
    _selectedAlgorithm = type;
    notifyListeners();
  }

  void clearGrid() {
    if (_isRunning) return;
    _initializeGrid();
  }

  void clearPath() {
    if (_isRunning) return;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final node = _grid[r][c];
        node.reset();
      }
    }
    notifyListeners();
  }

  void toggleWall(int r, int c) {
    if (_isRunning) return;
    final node = _grid[r][c];

    if (node.type == NodeType.start || node.type == NodeType.end) return;

    if (node.type == NodeType.empty ||
        node.type == NodeType.visited ||
        node.type == NodeType.path) {
      node.type = NodeType.wall;
      node.reset();
    } else if (node.type == NodeType.wall) {
      node.type = NodeType.empty;
    }

    notifyListeners();
  }

  void setWall(int r, int c) {
    if (_isRunning) return;
    final node = _grid[r][c];
    if (node.type == NodeType.empty ||
        node.type == NodeType.visited ||
        node.type == NodeType.path) {
      node.type = NodeType.wall;
      node.reset();
      notifyListeners();
    }
  }

  void executeAlgorithm() async {
    if (_isRunning) return;
    clearPath();
    _isRunning = true;
    notifyListeners();

    CustomNode? startNode;
    CustomNode? endNode;

    for (var row in _grid) {
      for (var node in row) {
        if (node.type == NodeType.start) startNode = node;
        if (node.type == NodeType.end) endNode = node;
      }
    }

    if (startNode == null || endNode == null) {
      _isRunning = false;
      notifyListeners();
      return;
    }

    // Clone grid agar node instance-nya aman
    final result = _runAlgorithmUseCase.call(
      _grid,
      startNode,
      endNode,
      _selectedAlgorithm,
    );

    // Animasi
    await _animatePathfinding(result);

    _isRunning = false;
    notifyListeners();
  }

  Future<void> _animatePathfinding(PathfindingResult result) async {
    for (var i = 1; i < result.visitedNodesInOrder.length - 1; i++) {
      final node = result.visitedNodesInOrder[i];
      if (node.type != NodeType.start && node.type != NodeType.end) {
        node.type = NodeType.visiting;
        node.type = NodeType.visited;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 15));
      }
    }

    for (var i = 1; i < result.pathNodesInOrder.length - 1; i++) {
      final node = result.pathNodesInOrder[i];
      if (node.type != NodeType.start && node.type != NodeType.end) {
        node.type = NodeType.path;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 30));
      }
    }
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/node.dart';
import '../../core/theme/modern_theme.dart';

class NodeWidget extends StatelessWidget {
  final CustomNode node;
  final double size;

  const NodeWidget({
    super.key,
    required this.node,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getNodeColor(node.type),
        border: Border.all(
          color: ModernTheme.gridLineColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(
          node.type == NodeType.start || node.type == NodeType.end || node.type == NodeType.wall ? 4.0 : 0.0,
        ),
        boxShadow: _getBoxShadow(node.type),
      ),
      child: _getNodeIcon(node.type, size),
    );
  }

  Color _getNodeColor(NodeType type) {
    switch (type) {
      case NodeType.start: return ModernTheme.nodeStart;
      case NodeType.end: return ModernTheme.nodeEnd;
      case NodeType.wall: return ModernTheme.nodeWall;
      case NodeType.visited: return ModernTheme.nodeVisited;
      case NodeType.visiting: return ModernTheme.nodeVisiting;
      case NodeType.path: return ModernTheme.nodePath;
      case NodeType.empty: return ModernTheme.nodeEmpty;
    }
  }

  List<BoxShadow>? _getBoxShadow(NodeType type) {
    if (type == NodeType.path || type == NodeType.start || type == NodeType.end) {
      return [
        BoxShadow(
          color: _getNodeColor(type).withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 1,
        )
      ];
    } else if (type == NodeType.wall) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(1, 1),
        )
      ];
    }
    return null;
  }

  Widget? _getNodeIcon(NodeType type, double size) {
    double iconSize = size * 0.6;
    if (type == NodeType.start) {
      return Icon(Icons.play_arrow_rounded, color: Colors.white, size: iconSize);
    } else if (type == NodeType.end) {
      return Icon(Icons.flag_rounded, color: Colors.white, size: iconSize);
    }
    return null;
  }
}

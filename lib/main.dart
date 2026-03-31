import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/modern_theme.dart';
import 'presentation/providers/pathfinding_provider.dart';
import 'presentation/providers/sorting_provider.dart';
import 'presentation/pages/master_menu_page.dart';

void main() {
  runApp(const PathfindingApp());
}

class PathfindingApp extends StatelessWidget {
  const PathfindingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PathfindingProvider()),
        ChangeNotifierProvider(create: (_) => SortingProvider()),
      ],
      child: MaterialApp(
        title: 'Algoritma Visualizer',
        debugShowCheckedModeBanner: false,
        theme: ModernTheme.lightTheme,
        home: const MasterMenuPage(),
      ),
    );
  }
}

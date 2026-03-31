import 'package:flutter/material.dart';
import '../../core/theme/modern_theme.dart';
import 'pathfinding_page.dart';
import 'sorting_page.dart';

class MasterMenuPage extends StatelessWidget {
  const MasterMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Algorithm Explorer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih kategori algoritma yang ingin Anda pelajari secara interaktif.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                  childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.5 : 2.5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _MenuCard(
                      title: 'Pathfinding',
                      subtitle: 'Visualisasi BFS, A*, Dijkstra, DFS dalam mencari rute tercepat.',
                      icon: Icons.map_outlined,
                      color: const Color(0xFF3B82F6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PathfindingPage()),
                        );
                      },
                    ),
                    _MenuCard(
                      title: 'Sorting',
                      subtitle: 'Visualisasi Bubble Sort, Selection Sort, Insertion Sort pada elemen array.',
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFF10B981),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SortingPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

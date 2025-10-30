import 'package:flutter/material.dart';
import 'tree_design.dart';
import 'hive_service.dart';
import 'tree_editor_screen.dart';
import 'booking_form_screen.dart';

class SavedTreesScreen extends StatefulWidget {
  const SavedTreesScreen({super.key});

  @override
  State<SavedTreesScreen> createState() => _SavedTreesScreenState();
}

class _SavedTreesScreenState extends State<SavedTreesScreen> {
  List<TreeDesign> savedTrees = [];

  @override
  void initState() {
    super.initState();
    loadTrees();
  }

  Future<void> loadTrees() async {
    final trees = await HiveService.getAllTrees();
    setState(() => savedTrees = trees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Trees')),
      body: savedTrees.isEmpty
          ? const Center(child: Text('No saved trees yet.'))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: savedTrees.length,
        itemBuilder: (context, index) {
          final tree = savedTrees[index];
          return Card(
            elevation: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tree.treeType.toUpperCase()),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/trees/${tree.treeType}.png',
                      width: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BookingFormScreen(treeType: tree.treeType),
                      ),
                    );
                  },
                  child: const Text("Book This Tree"),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TreeEditorScreen(
                          existingTree: tree,
                          treeIndex: index,
                        ),
                      ),
                    );
                    loadTrees();
                  },
                  child: const Text("Re-edit"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'tree_design.dart';
import 'hive_service.dart';

class TreeEditorScreen extends StatefulWidget {
  final TreeDesign? existingTree;
  final int? treeIndex;

  const TreeEditorScreen({super.key, this.existingTree, this.treeIndex});

  @override
  State<TreeEditorScreen> createState() => _TreeEditorScreenState();
}

class _TreeEditorScreenState extends State<TreeEditorScreen> {
  String currentTree = 'pine';
  List<Map<String, dynamic>> decorations = [];
  List<List<Map<String, dynamic>>> history = [];
  int historyIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.existingTree != null) {
      currentTree = widget.existingTree!.treeType;
      decorations =
      List<Map<String, dynamic>>.from(widget.existingTree!.decorations);
    }
  }

  void addDecoration(String type, Offset position) {
    final newDecor = {
      'type': type,
      'x': position.dx - 20,
      'y': position.dy - 20,
    };
    setState(() {
      decorations.add(newDecor);
      saveHistory();
    });
  }

  void saveHistory() {
    history = history.sublist(0, historyIndex + 1);
    history.add(List.from(decorations));
    historyIndex++;
  }

  void undo() {
    if (historyIndex > 0) {
      setState(() {
        historyIndex--;
        decorations = List.from(history[historyIndex]);
      });
    }
  }

  void redo() {
    if (historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        decorations = List.from(history[historyIndex]);
      });
    }
  }

  void deleteLastDecoration() {
    if (decorations.isNotEmpty) {
      setState(() {
        decorations.removeLast();
        saveHistory();
      });
    }
  }

  void clearAllDecorations() {
    setState(() {
      decorations.clear();
      saveHistory();
    });
  }

  Future<void> saveDesign() async {
    final design = TreeDesign(treeType: currentTree, decorations: decorations);
    if (widget.existingTree != null && widget.treeIndex != null) {
      await HiveService.updateTree(widget.treeIndex!, design);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tree updated!')),
      );
    } else {
      await HiveService.saveTree(design);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tree saved locally!')),
      );
    }
  }

  void changeTree() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Select Tree Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                'pine',
                'snowy_fir',
                'golden_spruce',
                'modern',
                'special_tree'
              ]
                  .map((t) =>
                  ListTile(
                    title: Text(t.replaceAll('_', ' ').toUpperCase()),
                    onTap: () => Navigator.pop(context, t),
                  ))
                  .toList(),
            ),
          ),
    );
    if (selected != null) setState(() => currentTree = selected);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final treeWidth = screenSize.width * 0.8;  // 80% of screen width
    final treeHeight = treeWidth * 1.3;        // idk,seems fit

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Editor'),
        actions: [
          IconButton(onPressed: undo, icon: const Icon(Icons.undo)),
          IconButton(onPressed: redo, icon: const Icon(Icons.redo)),
          IconButton(onPressed: deleteLastDecoration,
              icon: const Icon(Icons.delete_outline)),
          IconButton(onPressed: clearAllDecorations,
              icon: const Icon(Icons.delete_forever)),
          IconButton(onPressed: saveDesign, icon: const Icon(Icons.save)),
        ],
      ),
      body: GestureDetector(
        onLongPress: changeTree,
        child: Center(
          child: Stack(
            children: [
              // 🌲 Center the tree perfectly
              Positioned(
                left: (screenSize.width - treeWidth) / 2,
                top: (screenSize.height - treeHeight) / 2 - 100,
                child: Image.asset(
                  'assets/trees/$currentTree.png',
                  width: treeWidth,
                  height: treeHeight,
                ),
              ),

              // 🧸 Decorations
              ...decorations
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final d = entry.value;
                return Positioned(
                  left: d['x'],
                  top: d['y'],
                  child: Draggable(
                    feedback: Image.asset(
                      'assets/decorations/${d['type']}.png',
                      width: 40,
                    ),
                    childWhenDragging: const SizedBox(),
                    onDragEnd: (details) {
                      setState(() {
                        decorations[index]['x'] = details.offset.dx - 60;
                        decorations[index]['y'] = details.offset.dy - 220;
                        saveHistory();
                      });
                    },
                    child: Image.asset(
                      'assets/decorations/${d['type']}.png',
                      width: 40,
                    ),
                  ),
                );
              }),

              // 🎨 Decoration toolbar
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['ornament', 'topper', 'light', 'garland']
                        .map(
                          (type) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTapDown: (details) {
                                final RenderBox box =
                                context.findRenderObject() as RenderBox;
                                final position =
                                box.globalToLocal(details.globalPosition);
                                addDecoration(type, position);
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/decorations/$type.png',
                                  width: 30,
                                ),
                              ),
                            ),
                          ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

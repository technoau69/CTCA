import 'dart:convert';
import 'package:hive/hive.dart';

part 'tree_design.g.dart';

@HiveType(typeId: 0)
class TreeDesign extends HiveObject {
  @HiveField(0)
  String treeType;

  @HiveField(1)
  List<Map<String, dynamic>> decorations; // [{type: "ornament", x: 120, y: 300}]

  TreeDesign({
    required this.treeType,
    required this.decorations,
  });

  Map<String, dynamic> toJson() => {
    'treeType': treeType,
    'decorations': decorations,
  };

  static TreeDesign fromJson(Map<String, dynamic> json) => TreeDesign(
    treeType: json['treeType'],
    decorations: List<Map<String, dynamic>>.from(json['decorations']),
  );
}

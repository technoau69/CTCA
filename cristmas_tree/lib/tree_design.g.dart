// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_design.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreeDesignAdapter extends TypeAdapter<TreeDesign> {
  @override
  final int typeId = 0;

  @override
  TreeDesign read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeDesign(
      treeType: fields[0] as String,
      decorations: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, TreeDesign obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.treeType)
      ..writeByte(1)
      ..write(obj.decorations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeDesignAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

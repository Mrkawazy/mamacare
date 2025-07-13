// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneAdapter extends TypeAdapter<Milestone> {
  @override
  final int typeId = 3;

  @override
  Milestone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Milestone(
      title: fields[0] as String,
      description: fields[1] as String,
      expectedDate: fields[2] as DateTime,
      completedDate: fields[3] as DateTime?,
      isCompleted: fields[4] as bool,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Milestone obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.expectedDate)
      ..writeByte(3)
      ..write(obj.completedDate)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PregnancyCheckupAdapter extends TypeAdapter<PregnancyCheckup> {
  @override
  final int typeId = 4;

  @override
  PregnancyCheckup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PregnancyCheckup(
      date: fields[0] as DateTime,
      weight: fields[1] as double,
      bloodPressure: fields[2] as double,
      notes: fields[3] as String?,
      facility: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PregnancyCheckup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.bloodPressure)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.facility);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PregnancyCheckupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

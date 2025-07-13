// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PregnancyAdapter extends TypeAdapter<Pregnancy> {
  @override
  final int typeId = 2;

  @override
  Pregnancy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pregnancy(
      id: fields[0] as String,
      userId: fields[1] as String,
      lastMenstrualPeriod: fields[2] as DateTime,
      estimatedDeliveryDate: fields[3] as DateTime,
      milestones: (fields[4] as List).cast<Milestone>(),
      checkups: (fields[5] as List).cast<PregnancyCheckup>(),
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Pregnancy obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.lastMenstrualPeriod)
      ..writeByte(3)
      ..write(obj.estimatedDeliveryDate)
      ..writeByte(4)
      ..write(obj.milestones)
      ..writeByte(5)
      ..write(obj.checkups)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PregnancyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

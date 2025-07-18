// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildAdapter extends TypeAdapter<Child> {
  @override
  final int typeId = 5;

  @override
  Child read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Child(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      dateOfBirth: fields[3] as DateTime,
      gender: fields[4] as String,
      birthWeight: fields[5] as double,
      growthRecords: (fields[6] as List).cast<GrowthRecord>(),
      vaccinations: (fields[7] as List).cast<VaccinationRecord>(),
    );
  }

  @override
  void write(BinaryWriter writer, Child obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.dateOfBirth)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.birthWeight)
      ..writeByte(6)
      ..write(obj.growthRecords)
      ..writeByte(7)
      ..write(obj.vaccinations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrowthRecordAdapter extends TypeAdapter<GrowthRecord> {
  @override
  final int typeId = 6;

  @override
  GrowthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrowthRecord(
      date: fields[0] as DateTime,
      weight: fields[1] as double,
      height: fields[2] as double,
      headCircumference: fields[3] as double,
      muac: fields[4] as double,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GrowthRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.headCircumference)
      ..writeByte(4)
      ..write(obj.muac)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrowthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VaccinationRecordAdapter extends TypeAdapter<VaccinationRecord> {
  @override
  final int typeId = 7;

  @override
  VaccinationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VaccinationRecord(
      vaccineName: fields[0] as String,
      dueDate: fields[1] as DateTime,
      administeredDate: fields[2] as DateTime?,
      isAdministered: fields[3] as bool,
      facility: fields[4] as String?,
      batchNumber: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VaccinationRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.vaccineName)
      ..writeByte(1)
      ..write(obj.dueDate)
      ..writeByte(2)
      ..write(obj.administeredDate)
      ..writeByte(3)
      ..write(obj.isAdministered)
      ..writeByte(4)
      ..write(obj.facility)
      ..writeByte(5)
      ..write(obj.batchNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaccinationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmergencyContactAdapter extends TypeAdapter<EmergencyContact> {
  @override
  final int typeId = 13;

  @override
  EmergencyContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergencyContact(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as EmergencyType,
      phoneNumber: fields[3] as String,
      location: fields[4] as String?,
      province: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContact obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.province);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmergencyReportAdapter extends TypeAdapter<EmergencyReport> {
  @override
  final int typeId = 14;

  @override
  EmergencyReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergencyReport(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as EmergencyType,
      reportedAt: fields[3] as DateTime,
      description: fields[4] as String,
      location: fields[5] as String?,
      latitude: fields[6] as double?,
      longitude: fields[7] as double?,
      isResolved: fields[8] as bool,
      responseNotes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyReport obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.reportedAt)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.isResolved)
      ..writeByte(9)
      ..write(obj.responseNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmergencyTypeAdapter extends TypeAdapter<EmergencyType> {
  @override
  final int typeId = 12;

  @override
  EmergencyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmergencyType.medical;
      case 1:
        return EmergencyType.police;
      case 2:
        return EmergencyType.fire;
      case 3:
        return EmergencyType.ambulance;
      default:
        return EmergencyType.medical;
    }
  }

  @override
  void write(BinaryWriter writer, EmergencyType obj) {
    switch (obj) {
      case EmergencyType.medical:
        writer.writeByte(0);
        break;
      case EmergencyType.police:
        writer.writeByte(1);
        break;
      case EmergencyType.fire:
        writer.writeByte(2);
        break;
      case EmergencyType.ambulance:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthFacilityAdapter extends TypeAdapter<HealthFacility> {
  @override
  final int typeId = 11;

  @override
  HealthFacility read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthFacility(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as FacilityType,
      address: fields[3] as String,
      province: fields[4] as String,
      district: fields[5] as String,
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      phoneNumber: fields[8] as String,
      email: fields[9] as String?,
      services: (fields[10] as List).cast<String>(),
      is24Hours: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HealthFacility obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.province)
      ..writeByte(5)
      ..write(obj.district)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.phoneNumber)
      ..writeByte(9)
      ..write(obj.email)
      ..writeByte(10)
      ..write(obj.services)
      ..writeByte(11)
      ..write(obj.is24Hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthFacilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FacilityTypeAdapter extends TypeAdapter<FacilityType> {
  @override
  final int typeId = 10;

  @override
  FacilityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FacilityType.clinic;
      case 1:
        return FacilityType.hospital;
      case 2:
        return FacilityType.maternity;
      case 3:
        return FacilityType.pharmacy;
      default:
        return FacilityType.clinic;
    }
  }

  @override
  void write(BinaryWriter writer, FacilityType obj) {
    switch (obj) {
      case FacilityType.clinic:
        writer.writeByte(0);
        break;
      case FacilityType.hospital:
        writer.writeByte(1);
        break;
      case FacilityType.maternity:
        writer.writeByte(2);
        break;
      case FacilityType.pharmacy:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FacilityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

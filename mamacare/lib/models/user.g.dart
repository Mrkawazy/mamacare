// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String,
      passwordHash: fields[4] as String,
      role: fields[5] as UserRole,
      registeredAt: fields[6] as DateTime,
      address: fields[7] as String?,
      province: fields[8] as String?,
      dateOfBirth: fields[9] as DateTime?,
      isActive: fields[10] as bool, createdAt: null, profileImageUrl: null,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.passwordHash)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.registeredAt)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.province)
      ..writeByte(9)
      ..write(obj.dateOfBirth)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 0;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.superuser;
      case 1:
        return UserRole.admin;
      case 2:
        return UserRole.user;
      default:
        return UserRole.superuser;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.superuser:
        writer.writeByte(0);
        break;
      case UserRole.admin:
        writer.writeByte(1);
        break;
      case UserRole.user:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

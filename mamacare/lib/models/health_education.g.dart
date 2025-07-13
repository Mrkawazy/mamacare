// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_education.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthEducationAdapter extends TypeAdapter<HealthEducation> {
  @override
  final int typeId = 9;

  @override
  HealthEducation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthEducation(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as EducationCategory,
      content: fields[3] as String,
      imageUrl: fields[4] as String?,
      publishDate: fields[5] as DateTime,
      author: fields[6] as String?,
      isFeatured: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HealthEducation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.publishDate)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.isFeatured);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthEducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationCategoryAdapter extends TypeAdapter<EducationCategory> {
  @override
  final int typeId = 8;

  @override
  EducationCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EducationCategory.nutrition;
      case 1:
        return EducationCategory.pregnancy;
      case 2:
        return EducationCategory.childcare;
      case 3:
        return EducationCategory.breastfeeding;
      case 4:
        return EducationCategory.family_planning;
      case 5:
        return EducationCategory.hygiene;
      case 6:
        return EducationCategory.disease_prevention;
      default:
        return EducationCategory.nutrition;
    }
  }

  @override
  void write(BinaryWriter writer, EducationCategory obj) {
    switch (obj) {
      case EducationCategory.nutrition:
        writer.writeByte(0);
        break;
      case EducationCategory.pregnancy:
        writer.writeByte(1);
        break;
      case EducationCategory.childcare:
        writer.writeByte(2);
        break;
      case EducationCategory.breastfeeding:
        writer.writeByte(3);
        break;
      case EducationCategory.family_planning:
        writer.writeByte(4);
        break;
      case EducationCategory.hygiene:
        writer.writeByte(5);
        break;
      case EducationCategory.disease_prevention:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

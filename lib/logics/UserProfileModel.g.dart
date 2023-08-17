// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserProfileModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 1;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      userEmail: fields[0] as String?,
      userName: fields[1] as String?,
      userPublicLeafCount: fields[2] as int?,
      userPrivateLeafCount: fields[3] as int?,
      userExperiencePoints: fields[4] as int?,
      userVerified: fields[5] as bool?,
      userFollowers: fields[6] as int?,
      userFollowing: fields[7] as int?,
      userLevel: fields[8] as int?,
      userUniversalLikes: fields[9] as int?,
      userUniversalDislikes: fields[10] as int?,
      userUniversalComments: fields[11] as int?,
      createdAt: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userEmail)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userPublicLeafCount)
      ..writeByte(3)
      ..write(obj.userPrivateLeafCount)
      ..writeByte(4)
      ..write(obj.userExperiencePoints)
      ..writeByte(5)
      ..write(obj.userVerified)
      ..writeByte(6)
      ..write(obj.userFollowers)
      ..writeByte(7)
      ..write(obj.userFollowing)
      ..writeByte(8)
      ..write(obj.userLevel)
      ..writeByte(9)
      ..write(obj.userUniversalLikes)
      ..writeByte(10)
      ..write(obj.userUniversalDislikes)
      ..writeByte(11)
      ..write(obj.userUniversalComments)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;


}

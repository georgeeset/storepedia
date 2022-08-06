import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/string_constants.dart' as StringConstants;

class UserModel {
  String? userName;

  ///device id used to prevent abuse of db access,
  ///if deviceId is empty, the user can use his device id
  ///if device is changed, the user will not be allowed to
  ///use the app till admin deletes device id
  String? deviceId;
  String? email;

  /// userUID
  String? userId;

  int? partsAddedCount;

  /// With access level you can control
  /// who has access to do some tasks
  int accessLevel = 0;

  UserModel({
    this.userName,
    this.deviceId,
    this.email,
    this.userId,
    this.partsAddedCount,
    this.accessLevel = 0,
  });

  UserModel.fromMap({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    userName = data[StringConstants.userName];
    deviceId = data[StringConstants.deviceId];
    email = data[StringConstants.email];
    userId = data[StringConstants.userId];
    partsAddedCount = data[StringConstants.partsAddedCount];
    accessLevel = data[StringConstants.accessLevel] ?? 0;
  }

  Map<String, dynamic> get toMap => {
        StringConstants.userName: userName,
        StringConstants.deviceId: deviceId,
        StringConstants.email: email,
        StringConstants.userId: userId,
        StringConstants.partsAddedCount: partsAddedCount,
        StringConstants.accessLevel: accessLevel,
      };

  copyWith({
    String? userName,
    String? deviceId,
    String? email,
    String? userId,
    int? partsAddedCount,
    int? accessLevel,
  }) {
    return UserModel(
        userName: userName ?? this.userName,
        deviceId: deviceId ?? this.deviceId,
        email: email ?? this.email,
        userId: userId ?? this.userId,
        partsAddedCount: partsAddedCount ?? this.partsAddedCount,
        accessLevel: accessLevel ?? this.accessLevel);
  }

  bool hasName() => userName != null;
}

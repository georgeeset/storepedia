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

  /// Company info describes location of its part collection.
  /// companyId and location will be combined to make the part collection.
  /// many companies and brances will make use of the app.
  String? companyId;
  String? location;

  UserModel({
    this.userName,
    this.deviceId,
    this.email,
    this.userId,
    this.partsAddedCount,
    this.accessLevel = 0,
    this.companyId,
    this.location,
  });

  UserModel.fromMap({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    userName = data[StringConstants.userName];
    deviceId = data[StringConstants.deviceId];
    email = data[StringConstants.email];
    userId = data[StringConstants.userId];
    partsAddedCount = data[StringConstants.partsAddedCount];
    accessLevel = data[StringConstants.accessLevel] ?? 0;
    companyId = data[StringConstants.companyId];
    location = data[StringConstants.location];
  }

  Map<String, dynamic> get toMap => {
        StringConstants.userName: userName,
        StringConstants.deviceId: deviceId,
        StringConstants.email: email,
        StringConstants.userId: userId,
        StringConstants.partsAddedCount: partsAddedCount,
        StringConstants.accessLevel: accessLevel,
        StringConstants.companyId: companyId,
        StringConstants.location: location,
      };

  copyWith({
    String? userName,
    String? deviceId,
    String? email,
    String? userId,
    int? partsAddedCount,
    int? accessLevel,
    String? location,
    String? companyId,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      deviceId: deviceId ?? this.deviceId,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      partsAddedCount: partsAddedCount ?? this.partsAddedCount,
      accessLevel: accessLevel ?? this.accessLevel,
      companyId: companyId ?? this.companyId,
      location: location ?? this.location,
    );
  }

  bool hasName() => userName != null;
  bool hasCompanyId() => companyId != null;
  bool hasLocation() => location != null;
}

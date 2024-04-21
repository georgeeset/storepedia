import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/string_constants.dart' as string_constants;

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

  String? company;
  String? branch;

  bool isAdmin = false;

  UserModel(
      {this.userName,
      this.deviceId,
      this.email,
      this.userId,
      this.partsAddedCount,
      this.accessLevel = 0,
      this.company,
      this.branch,
      this.isAdmin = false});

  UserModel.fromMap({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    userName = data[string_constants.userName];
    deviceId = data[string_constants.deviceId];
    email = data[string_constants.email];
    userId = data[string_constants.userId];
    partsAddedCount = data[string_constants.partsAddedCount];
    accessLevel = data[string_constants.accessLevel] ?? 0;
    company = data[string_constants.company];
    branch = data[string_constants.branch];
    isAdmin = data[string_constants.isAdmin] ?? false;
  }

  Map<String, dynamic> get toMap => {
        string_constants.userName: userName,
        string_constants.deviceId: deviceId,
        string_constants.email: email,
        string_constants.userId: userId,
        string_constants.partsAddedCount: partsAddedCount,
        string_constants.accessLevel: accessLevel,
        string_constants.company: company,
        string_constants.branch: branch,
        string_constants.isAdmin: isAdmin
      };

  copyWith(
      {String? userName,
      String? deviceId,
      String? email,
      String? userId,
      int? partsAddedCount,
      int? accessLevel,
      String? company,
      String? branch,
      bool? isAdmin}) {
    return UserModel(
        userName: userName ?? this.userName,
        deviceId: deviceId ?? this.deviceId,
        email: email ?? this.email,
        userId: userId ?? this.userId,
        partsAddedCount: partsAddedCount ?? this.partsAddedCount,
        accessLevel: accessLevel ?? this.accessLevel,
        company: company ?? this.company,
        branch: branch ?? this.branch,
        isAdmin: isAdmin ?? this.isAdmin);
  }

  bool hasName() => userName != null;
}
